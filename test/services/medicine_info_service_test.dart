import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:medzee/domain/models/medication.dart';
import 'package:medzee/domain/models/medicine_info.dart';
import 'package:medzee/services/medicine_info_service.dart';

/// An [http.Client] that records the requested URI and replies with a canned
/// JSON payload, so provider query construction can be tested offline.
class _CapturingHttpClient implements http.Client {
  _CapturingHttpClient({this.statusCode = 200, this.body = '{"results": []}'});

  final int statusCode;
  final String body;
  final List<Uri> requests = <Uri>[];

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    requests.add(url);
    return http.Response(body, statusCode);
  }

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Medication _medication({String name = 'Dolo 650', String? genericName}) =>
    Medication(
      id: 'med-1',
      name: name,
      genericName: genericName,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

const String _twoLabels = '''
{
  "results": [
    {
      "openfda": {"brand_name": ["TYLENOL"], "generic_name": ["ACETAMINOPHEN"]},
      "active_ingredient": ["ACETAMINOPHEN 650 mg"],
      "effective_time": "20240101"
    },
    {
      "openfda": {"brand_name": ["Dolo-650"], "generic_name": ["PARACETAMOL"]},
      "active_ingredient": ["PARACETAMOL 650 mg"],
      "effective_time": "20240101"
    }
  ]
}
''';

const String _searchLabels = '''
{
  "results": [
    {"openfda": {"generic_name": ["METFORMIN HYDROCHLORIDE"], "brand_name": ["GLUCOPHAGE"]}},
    {"openfda": {"generic_name": ["METFORMIN HYDROCHLORIDE"], "brand_name": ["FORTAMET"]}},
    {"openfda": {"brand_name": ["RIOMET"]}}
  ]
}
''';

void main() {
  group('OpenFdaProvider.lookup', () {
    test('queries generic (INN) name OR brand name, never AND', () async {
      final _CapturingHttpClient client = _CapturingHttpClient(body: _twoLabels);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      await provider.lookup(_medication(genericName: 'Paracetamol'));

      expect(client.requests, hasLength(1));
      final String search =
          client.requests.single.queryParameters['search'] ?? '';
      expect(search, contains('openfda.generic_name:"Dolo 650"'));
      expect(search, contains('openfda.generic_name:"Paracetamol"'));
      expect(search, contains('+OR+'));
      // An ANDed brand+generic query would never match real-world labels.
      expect(search, isNot(contains('brand_name:"Dolo 650"+openfda')));
    });

    test('prefers the result matching the recorded generic (INN) name',
        () async {
      final _CapturingHttpClient client = _CapturingHttpClient(body: _twoLabels);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      final MedicineInformation? info =
          await provider.lookup(_medication(genericName: 'Paracetamol'));

      expect(info, isNotNull);
      expect(info!.genericName, 'PARACETAMOL');
      expect(info.brandNames, contains('Dolo-650'));
    });

    test('falls back to the first result when no generic name is recorded',
        () async {
      final _CapturingHttpClient client = _CapturingHttpClient(body: _twoLabels);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      final MedicineInformation? info = await provider.lookup(_medication());

      expect(info, isNotNull);
      expect(info!.genericName, 'ACETAMINOPHEN');
    });

    test('returns null when nothing is found — never invents content',
        () async {
      final _CapturingHttpClient client = _CapturingHttpClient();
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      expect(await provider.lookup(_medication()), isNull);
    });

    test('returns null on HTTP errors instead of throwing', () async {
      final _CapturingHttpClient client = _CapturingHttpClient(statusCode: 500);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      expect(await provider.lookup(_medication()), isNull);
    });
  });

  group('OpenFdaProvider.search', () {
    test('returns every result, deduplicated, named INN-first', () async {
      final _CapturingHttpClient client = _CapturingHttpClient(body: _searchLabels);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      final List<MedicineSearchResult> results =
          await provider.search('metformin');

      expect(results, hasLength(2));
      expect(results.first.name, 'METFORMIN HYDROCHLORIDE');
      expect(results.last.name, 'RIOMET');

      final String search =
          client.requests.single.queryParameters['search'] ?? '';
      expect(search, contains('+OR+'));
    });

    test('ignores queries shorter than two characters', () async {
      final _CapturingHttpClient client = _CapturingHttpClient(body: _searchLabels);
      final OpenFdaProvider provider = OpenFdaProvider(client: client);

      expect(await provider.search('m'), isEmpty);
      expect(client.requests, isEmpty);
    });
  });
}
