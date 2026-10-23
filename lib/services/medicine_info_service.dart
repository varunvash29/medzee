import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/models/core_enums.dart';
import '../domain/models/medication.dart';
import '../domain/models/medicine_info.dart';

/// A medicine data provider.
///
/// Medzee does not embed clinical content. It asks a provider for verified
/// information and shows the source alongside every result, so the user can
/// always tell where a claim came from.
abstract interface class MedicineInfoProvider {
  /// Human readable name of the provider, e.g. "openFDA".
  String get sourceName;

  /// Base URL of the provider, shown to the user.
  String get sourceUrl;

  /// Whether the provider can be reached right now.
  Future<bool> isAvailable();

  /// Looks up verified information for a medication.
  ///
  /// Returns null when nothing usable was found — Medzee never invents
  /// clinical content.
  Future<MedicineInformation?> lookup(Medication medication);

  /// Looks up medicines that could match this one.
  Future<List<MedicineSearchResult>> search(String query);

  /// Finds generic equivalents and brand variants.
  ///
  /// The provider must explain *why* each result appears. It must never
  /// present a therapeutic alternative as an interchangeable product.
  Future<List<AlternativeMedicine>> alternatives(
    Medication medication,
    MedicineInformation? information,
  );
}

/// Raised when a provider request fails or times out.
class MedicineInfoException implements Exception {
  MedicineInfoException(this.message, {this.isNetwork = false});

  final String message;
  final bool isNetwork;

  @override
  String toString() => 'MedicineInfoException: $message';
}

/// [MedicineInfoProvider] backed by the public openFDA API.
///
/// openFDA is a free, key-less HTTP API operated by the U.S. Food and Drug
/// Administration. It indexes medicines by their INN generic name — the same
/// international naming that Indian law requires on every strip — so lookups
/// are generic-first: an Indian user who types the generic name printed on
/// their medicine gets correct results. Indian *brand* names (e.g. Dolo,
/// Crocin) are not in the FDA database; the UI therefore steers users to the
/// generic name and stays honest when nothing is found — Medzee never invents
/// clinical content.
class OpenFdaProvider implements MedicineInfoProvider {
  OpenFdaProvider({http.Client? client, this.timeout = const Duration(seconds: 12)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  static const String _labelEndpoint = 'https://api.fda.gov/drug/label.json';
  static const String _fdaEndpoint = 'https://api.fda.gov/drug/drugsfda.json';

  @override
  String get sourceName => 'openFDA (U.S. Food and Drug Administration)';

  @override
  String get sourceUrl => 'https://open.fda.gov';

  @override
  Future<bool> isAvailable() async {
    try {
      final http.Response response = await _client
          .get(Uri.parse('https://api.fda.gov/drug/label.json?limit=1'))
          .timeout(timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<MedicineInformation?> lookup(Medication medication) async {
    final List<Map<String, dynamic>> labels = await _fetchList(
      _labelEndpoint,
      <String, String>{
        'search': _labelSearch(medication),
        'limit': '5',
      },
    );
    if (labels.isEmpty) return null;

    // Prefer the entry whose generic (INN) name matches what the user
    // recorded — Indian strips always print it — over a loose brand hit.
    Map<String, dynamic> label = labels.first;
    final String? wantedGeneric = medication.genericName?.toLowerCase();
    if (wantedGeneric != null && wantedGeneric.isNotEmpty) {
      for (final Map<String, dynamic> candidate in labels) {
        final List<String> generics = _asStringList(
          _asMap(candidate['openfda'])['generic_name'],
        );
        if (generics.any((String g) => g.toLowerCase().contains(wantedGeneric))) {
          label = candidate;
          break;
        }
      }
    }

    final Map<String, dynamic> openfda = _asMap(label['openfda']);
    final List<String> brandNames = _asStringList(openfda['brand_name']);
    final String? generic =
        _firstString(openfda['generic_name']) ?? medication.genericName;
    final List<String> activeIngredients = _asStringList(
      label['active_ingredients'] ?? label['active_ingredient'],
    );

    final List<String> strengths = <String>[];
    for (final dynamic entry in _asList(label['active_ingredients'])) {
      final Map<String, dynamic> map = _asMap(entry);
      final String? strength = _firstString(map['strength']);
      if (strength != null && !strengths.contains(strength)) {
        strengths.add(strength);
      }
    }

    final DateTime lastUpdated = _parseDate(label['effective_time']) ??
        DateTime.now().toUtc();

    return MedicineInformation(
      medicationId: medication.id,
      sourceName: sourceName,
      sourceUrl: 'https://open.fda.gov/apis/drug/label/',
      lastUpdated: lastUpdated,
      genericName: generic,
      brandNames: brandNames.isEmpty
          ? (medication.brandName == null ? const <String>[] : <String>[medication.brandName!])
          : brandNames,
      activeIngredients: activeIngredients,
      indications: _asStringList(label['indications_and_usage']),
      warnings: _asStringList(label['warnings'] ?? label['boxed_warning']),
      contraindications: _asStringList(label['contraindications']),
      sideEffects: _asStringList(label['adverse_reactions']),
      storage: _firstString(label['storage_and_handling']),
      dosageForm: _firstString(openfda['dosage_form']) ?? medication.form.label,
      strengths: strengths,
      foodInteractions:
          _asStringList(label['food_and_alcohol_interactions']),
      patientAdvice: _asStringList(label['patient_advice']),
    );
  }

  @override
  Future<List<MedicineSearchResult>> search(String query) async {
    final String trimmed = query.trim();
    if (trimmed.length < 2) return const <MedicineSearchResult>[];
    // Generic (INN) first, brand second — Indian users look medicines up by
    // the generic name printed on the strip.
    final List<Map<String, dynamic>> labels = await _fetchList(
      _labelEndpoint,
      <String, String>{
        'search':
            'openfda.generic_name:"$trimmed"+OR+openfda.brand_name:"$trimmed"',
        'limit': '10',
      },
    );
    if (labels.isEmpty) return const <MedicineSearchResult>[];

    final List<MedicineSearchResult> results = <MedicineSearchResult>[];
    final Set<String> seen = <String>{};
    for (final Map<String, dynamic> payload in labels) {
      final Map<String, dynamic> openfda = _asMap(payload['openfda']);
      final List<String> brands = _asStringList(openfda['brand_name']);
      final String? generic = _firstString(openfda['generic_name']);
      final String name = generic ?? (brands.isNotEmpty ? brands.first : trimmed);
      if (!seen.add(name.toLowerCase())) continue;
      results.add(
        MedicineSearchResult(
          name: name,
          sourceName: sourceName,
          sourceUrl: 'https://open.fda.gov/apis/drug/label/',
          genericName: generic,
          brandNames: brands,
          activeIngredients: _asStringList(payload['active_ingredients']),
          dosageForm: _firstString(openfda['dosage_form']),
          route: _firstString(openfda['route']),
        ),
      );
    }
    return results;
  }

  @override
  Future<List<AlternativeMedicine>> alternatives(
    Medication medication,
    MedicineInformation? information,
  ) async {
    final String? ingredient =
        (information?.activeIngredients.isNotEmpty ?? false)
            ? _ingredientName(information!.activeIngredients.first)
            : medication.genericName;

    if (ingredient == null || ingredient.isEmpty) {
      return const <AlternativeMedicine>[];
    }

    final List<Map<String, dynamic>> applications = await _fetchList(
      _fdaEndpoint,
      <String, String>{
        'search': 'products.active_ingredients.name:"$ingredient"',
        'limit': '20',
      },
    );
    if (applications.isEmpty) return const <AlternativeMedicine>[];

    final List<dynamic> products = applications
        .expand((Map<String, dynamic> a) => _asList(a['products']))
        .toList(growable: false);
    final List<AlternativeMedicine> results = <AlternativeMedicine>[];

    for (final dynamic entry in products) {
      final Map<String, dynamic> product = _asMap(entry);
      final List<dynamic> brandNames = _asList(product['brand_name']);
      final List<dynamic> dosageForms = _asList(product['dosage_form']);
      final List<dynamic> routes = _asList(product['route']);
      final List<dynamic> strengths = _asList(product['strength']);

      for (final dynamic brand in brandNames) {
        final String brandName = brand.toString();
        if (brandName.toLowerCase() == medication.name.toLowerCase()) continue;
        if (brandName.toLowerCase() == medication.brandName?.toLowerCase()) {
          continue;
        }

        final String? strength =
            strengths.isEmpty ? null : strengths.first.toString();
        final String? dosageForm =
            dosageForms.isEmpty ? null : dosageForms.first.toString();
        final String? route = routes.isEmpty ? null : routes.first.toString();

        // Resolved once, while `strength` is still nullable, so the copy reads
        // the same regardless of how the flow analysis treats the branch below.
        final String strengthText = strength ?? 'not stated';

        final bool sameStrength = strength != null &&
            medication.strength != null &&
            strength.toLowerCase().contains(
                  medication.strength!.toStringAsFixed(
                    medication.strength! == medication.strength!.roundToDouble()
                        ? 0
                        : 1,
                  ),
                );

        final AlternativeRelation relation = sameStrength
            ? AlternativeRelation.genericEquivalent
            : AlternativeRelation.brandEquivalent;

        results.add(
          AlternativeMedicine(
            id: '$brandName|${strength ?? ''}|$dosageForm',
            name: brandName,
            relation: relation,
            reason: sameStrength
                ? 'Contains the same active ingredient ($ingredient) and the '
                    'same strength ($strengthText).'
                : 'Contains the same active ingredient ($ingredient). '
                    'Strength may differ - check before switching.',
            sourceName: sourceName,
            sourceUrl: 'https://open.fda.gov/apis/drug/drugsfda/',
            brandNames: <String>[brandName],
            activeIngredients: <String>[ingredient],
            strength: strength,
            dosageForm: dosageForm,
            route: route,
          ),
        );
      }
    }

    return results.take(20).toList(growable: false);
  }

  // ------------------------------------------------------------------ utils

  String _labelSearch(Medication medication) {
    // INN-first: the generic name printed on every strip (required by Indian
    // labelling rules) is the primary key; the brand name is a fallback.
    final Set<String> terms = <String>{
      medication.name,
      if (medication.genericName != null) medication.genericName!,
    }.map((String t) => t.replaceAll('"', ' ').trim())
        .where((String t) => t.isNotEmpty)
        .toSet();
    return terms
        .expand(
          (String t) => <String>[
            'openfda.generic_name:"$t"',
            'openfda.brand_name:"$t"',
          ],
        )
        .join('+OR+');
  }

  Future<List<Map<String, dynamic>>> _fetchList(
    String endpoint,
    Map<String, String> query,
  ) async {
    try {
      final Uri uri = Uri.parse(endpoint).replace(queryParameters: query);
      final http.Response response = await _client.get(uri).timeout(timeout);
      if (response.statusCode != 200) return const <Map<String, dynamic>>[];
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      return _asList(body['results'])
          .map(_asMap)
          .toList(growable: false);
    } catch (_) {
      return const <Map<String, dynamic>>[];
    }
  }

  static String _ingredientName(String raw) {
    final int bracket = raw.indexOf('[');
    if (bracket > 0) return raw.substring(0, bracket).trim();
    final int colon = raw.indexOf(':');
    if (colon > 0) return raw.substring(0, colon).trim();
    return raw.trim();
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  static List<dynamic> _asList(dynamic value) {
    if (value is List) return value;
    if (value == null) return const <dynamic>[];
    return <dynamic>[value];
  }

  static List<String> _asStringList(dynamic value) {
    return _asList(value)
        .map((dynamic e) => e.toString().trim())
        .where((String e) => e.isNotEmpty)
        .toList(growable: false);
  }

  static String? _firstString(dynamic value) {
    final List<String> values = _asStringList(value);
    return values.isEmpty ? null : values.first;
  }

  static DateTime? _parseDate(dynamic value) {
    final String? raw = _firstString(value);
    if (raw == null) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }
}

/// A provider that is not configured.
///
/// Medzee shows an honest "information unavailable" state rather than
/// inventing clinical content.
class UnavailableMedicineInfoProvider implements MedicineInfoProvider {
  const UnavailableMedicineInfoProvider([this.reason = 'No medicine database is configured.']);

  final String reason;

  @override
  String get sourceName => 'Not configured';

  @override
  String get sourceUrl => '';

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<MedicineInformation?> lookup(Medication medication) async => null;

  @override
  Future<List<MedicineSearchResult>> search(String query) async =>
      const <MedicineSearchResult>[];

  @override
  Future<List<AlternativeMedicine>> alternatives(
    Medication medication,
    MedicineInformation? information,
  ) async =>
      const <AlternativeMedicine>[];
}
