import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/services/people/people_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PeopleRegistry registry;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    registry = PeopleRegistry();
  });

  group('PeopleRegistry', () {
    test('starts with the primary person on the original database', () async {
      final List<Person> people = await registry.load();
      expect(people, hasLength(1));
      expect(people.single.isPrimary, isTrue);
      expect(people.single.databaseName, 'medzee',
          reason: 'existing installs keep their data');
      expect(people.single.storageSuffix, '',
          reason: 'existing sync codes keep working');
      expect(await registry.activeId(), Person.primaryId);
    });

    test('remembers people and who was open', () async {
      final Person mum = Person.create(name: 'Mum');
      await registry.save(<Person>[Person.primary, mum]);
      await registry.saveActiveId(mum.id);

      final PeopleRegistry again = PeopleRegistry();
      final List<Person> people = await again.load();
      expect(people.map((Person p) => p.name), <String>['', 'Mum']);
      expect(await again.activeId(), mum.id);
    });

    test('a damaged list falls back to the primary person', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'medzee_people_v1': '{not json',
      });
      final List<Person> people = await PeopleRegistry().load();
      expect(people.single.isPrimary, isTrue);
    });

    test('the primary person is restored if it is missing from the list',
        () async {
      await registry.save(<Person>[Person.create(name: 'Mum')]);
      final List<Person> people = await registry.load();
      expect(people.first.isPrimary, isTrue);
      expect(people, hasLength(2));
    });
  });

  group('Person', () {
    test('everyone but the first has their own database and sync keys', () {
      final Person a = Person.create();
      final Person b = Person.create();
      expect(a.databaseName, isNot(b.databaseName));
      expect(a.databaseName, isNot('medzee'));
      expect(a.storageSuffix, isNot(b.storageSuffix));
      expect(a.storageSuffix, startsWith('.'));
    });

    test('a blank name has a readable label', () {
      expect(Person.primary.label, Person.defaultName);
      expect(Person.create(name: '  Asha ').label, 'Asha');
    });
  });

  group('PeopleController', () {
    late PeopleController controller;
    late List<String> opened;

    setUp(() async {
      controller = await PeopleController.load(registry);
      opened = <String>[];
      controller.onSwitch = (Person p) async => opened.add(p.id);
    });

    test('adding a person opens them and persists the list', () async {
      final Person added = await controller.addPerson();

      expect(controller.active.id, added.id);
      expect(opened, <String>[added.id]);
      expect(controller.people, hasLength(2));
      expect((await PeopleRegistry().load()), hasLength(2));
      expect(await PeopleRegistry().activeId(), added.id);
    });

    test('switching back and forth opens the right person', () async {
      final Person added = await controller.addPerson();
      await controller.switchTo(Person.primaryId);
      await controller.switchTo(added.id);

      expect(opened, <String>[added.id, Person.primaryId, added.id]);
      expect(controller.active.id, added.id);
    });

    test('switching to the person already open does nothing', () async {
      await controller.switchTo(Person.primaryId);
      expect(opened, isEmpty);
    });

    test('an unknown person is ignored', () async {
      await controller.switchTo('nobody');
      expect(opened, isEmpty);
      expect(controller.active.isPrimary, isTrue);
    });

    test('the name follows the profile', () async {
      await controller.syncName(Person.primaryId, '  Dad ');
      expect(controller.active.label, 'Dad');
      expect((await PeopleRegistry().load()).first.name, 'Dad');
    });

    test('reminders only carry a name when people share the phone', () async {
      await controller.syncName(Person.primaryId, 'Dad');
      expect(controller.labelForReminders, isNull);
      await controller.addPerson();
      await controller.syncName(controller.active.id, 'Mum');
      expect(controller.labelForReminders, 'Mum');
    });

    test('removing someone clears their data first and keeps everyone else',
        () async {
      final List<String> forgotten = <String>[];
      controller.onForget = (Person p) async => forgotten.add(p.id);
      final Person added = await controller.addPerson();
      await controller.switchTo(Person.primaryId);

      expect(await controller.remove(added.id), isTrue);
      expect(forgotten, <String>[added.id]);
      expect(controller.people.map((Person p) => p.id), <String>[
        Person.primaryId,
      ]);
    });

    test('the open person, the first person and the last person stay', () async {
      final Person added = await controller.addPerson();
      expect(await controller.remove(added.id), isFalse, reason: 'open now');
      await controller.switchTo(Person.primaryId);
      expect(await controller.remove(Person.primaryId), isFalse,
          reason: 'their data predates the list');

      await controller.remove(added.id);
      expect(await controller.remove(Person.primaryId), isFalse,
          reason: 'never leave nobody');
    });
  });

  test('a standalone controller is one person and never fails', () async {
    final PeopleController solo = PeopleController.solo();
    expect(solo.hasSeveral, isFalse);
    expect(solo.labelForReminders, isNull);
    await solo.syncName(Person.primaryId, 'Asha');
    expect(solo.active.label, 'Asha');
  });
}
