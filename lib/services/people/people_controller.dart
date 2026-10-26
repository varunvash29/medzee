import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// One person who uses Medzee on this device.
///
/// Everyone has their own database and, if they switch sync on, their own sync
/// code, so nobody's medicines, history or settings ever mix with anyone
/// else's.
class Person {
  const Person({
    required this.id,
    required this.name,
    required this.databaseName,
  });

  /// The person who was here first, and everyone who installed Medzee before
  /// it supported more than one person. Their data lives in the original
  /// database and under the original sync keys.
  static const String primaryId = 'primary';
  static const String primaryDatabase = 'medzee';
  static const String defaultName = 'New person';

  final String id;

  /// Shown in the person switcher. Kept in step with the profile name.
  final String name;

  /// The name of this person's local database.
  final String databaseName;

  bool get isPrimary => id == primaryId;

  /// Appended to this person's secure-storage keys so each has their own sync
  /// code. Empty for the primary person, to keep existing codes working.
  String get storageSuffix => isPrimary ? '' : '.$id';

  /// A short label: the name, or a fallback when it is blank.
  String get label => name.trim().isEmpty ? defaultName : name.trim();

  Person copyWith({String? name}) =>
      Person(id: id, name: name ?? this.name, databaseName: databaseName);

  Map<String, Object?> toJson() =>
      <String, Object?>{'id': id, 'name': name, 'db': databaseName};

  static Person? fromJson(Object? json) {
    if (json is! Map) return null;
    final Object? id = json['id'];
    final Object? db = json['db'];
    if (id is! String || id.isEmpty || db is! String || db.isEmpty) return null;
    final Object? name = json['name'];
    return Person(id: id, name: name is String ? name : '', databaseName: db);
  }

  static Person create({String name = ''}) {
    final String id = const Uuid().v4().replaceAll('-', '').substring(0, 12);
    return Person(id: id, name: name, databaseName: 'medzee_$id');
  }

  static const Person primary = Person(
    id: primaryId,
    name: '',
    databaseName: primaryDatabase,
  );
}

/// Remembers who uses this device and who was open last.
class PeopleRegistry {
  PeopleRegistry([SharedPreferences? prefs]) : _prefs = prefs;

  static const String _listKey = 'medzee_people_v1';
  static const String _activeKey = 'medzee_active_person_v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Everyone on this device. Always contains at least the primary person.
  Future<List<Person>> load() async {
    final SharedPreferences prefs = await _store;
    final List<Person> people = <Person>[];
    final String? raw = prefs.getString(_listKey);
    if (raw != null) {
      try {
        final Object? decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final Object? item in decoded) {
            final Person? p = Person.fromJson(item);
            if (p != null && !people.any((Person q) => q.id == p.id)) {
              people.add(p);
            }
          }
        }
      } catch (_) {
        // A damaged list falls back to the primary person below.
      }
    }
    if (!people.any((Person p) => p.isPrimary)) {
      people.insert(0, Person.primary);
    }
    return people;
  }

  Future<void> save(List<Person> people) async {
    final SharedPreferences prefs = await _store;
    await prefs.setString(
      _listKey,
      jsonEncode(<Object?>[for (final Person p in people) p.toJson()]),
    );
  }

  Future<String> activeId() async {
    final SharedPreferences prefs = await _store;
    return prefs.getString(_activeKey) ?? Person.primaryId;
  }

  Future<void> saveActiveId(String id) async {
    final SharedPreferences prefs = await _store;
    await prefs.setString(_activeKey, id);
  }
}

/// Who is using Medzee right now, and the way to change that.
///
/// A [ChangeNotifier] so the switcher redraws when someone is added, renamed
/// or removed. The actual switch (closing one person's data and opening
/// another's) is done by the host through [onSwitch].
class PeopleController extends ChangeNotifier {
  PeopleController({
    required PeopleRegistry registry,
    required List<Person> people,
    required String activeId,
  })  : _registry = registry,
        _people = List<Person>.of(people),
        _activeId = people.any((Person p) => p.id == activeId)
            ? activeId
            : Person.primaryId;

  /// A single, unnamed person. The default when nothing else is provided, so
  /// screens and tests work without any host.
  PeopleController.solo()
      : _registry = null,
        _people = <Person>[Person.primary],
        _activeId = Person.primaryId;

  /// Loads the saved list and the person who was open last.
  static Future<PeopleController> load([PeopleRegistry? registry]) async {
    final PeopleRegistry reg = registry ?? PeopleRegistry();
    return PeopleController(
      registry: reg,
      people: await reg.load(),
      activeId: await reg.activeId(),
    );
  }

  final PeopleRegistry? _registry;
  final List<Person> _people;
  String _activeId;

  /// Installed by the host: opens [person]'s data and shows it.
  Future<void> Function(Person person)? onSwitch;

  /// Installed by the host: clears [person]'s data and reminders from this
  /// device. Called before they are taken off the list.
  Future<void> Function(Person person)? onForget;

  List<Person> get people => List<Person>.unmodifiable(_people);

  Person get active =>
      _people.firstWhere((Person p) => p.id == _activeId, orElse: () => _people.first);

  bool get hasSeveral => _people.length > 1;

  /// The person's name for reminder notifications, but only when more than one
  /// person shares the phone (otherwise it would just be noise).
  String? get labelForReminders => hasSeveral ? active.label : null;

  Future<void> _persist() async {
    final PeopleRegistry? registry = _registry;
    if (registry == null) return;
    await registry.save(_people);
    await registry.saveActiveId(_activeId);
  }

  /// Opens [id]. No-op for the person already open.
  Future<void> switchTo(String id) async {
    if (id == _activeId) return;
    final Person? next = _people.where((Person p) => p.id == id).firstOrNull;
    if (next == null) return;
    _activeId = id;
    await _persist();
    notifyListeners();
    await onSwitch?.call(next);
  }

  /// Adds someone new and opens them, ready for first-time setup.
  Future<Person> addPerson() async {
    final Person person = Person.create();
    _people.add(person);
    _activeId = person.id;
    await _persist();
    notifyListeners();
    await onSwitch?.call(person);
    return person;
  }

  /// Keeps the switcher's name in step with the profile's name.
  Future<void> syncName(String id, String? name) async {
    final int i = _people.indexWhere((Person p) => p.id == id);
    if (i < 0) return;
    final String clean = (name ?? '').trim();
    if (_people[i].name == clean) return;
    _people[i] = _people[i].copyWith(name: clean);
    await _persist();
    notifyListeners();
  }

  /// Takes someone off this device along with their local data and reminders.
  /// The person who is open cannot be removed, neither can the last one, and
  /// neither can the first person (their data predates the list).
  /// Anything they synced to the cloud stays there: their sync code still
  /// brings it back.
  Future<bool> remove(String id) async {
    if (id == _activeId || _people.length <= 1) return false;
    final Person? gone = _people.where((Person p) => p.id == id).firstOrNull;
    if (gone == null || gone.isPrimary) return false;
    await onForget?.call(gone);
    _people.removeWhere((Person p) => p.id == id);
    await _persist();
    notifyListeners();
    return true;
  }
}
