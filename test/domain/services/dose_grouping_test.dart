import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/domain/models/core_enums.dart';
import 'package:medzee/domain/services/dose_grouping.dart';

typedef _D = ({String name, int minutes, DoseStatus status});

GroupedSchedule<_D> _group(List<_D> d) => groupSchedule<_D>(
      d,
      minutes: (_D x) => x.minutes,
      status: (_D x) => x.status,
      tieBreak: (_D x) => x.name,
    );

void main() {
  test('open doses are grouped by time, earliest first', () {
    final GroupedSchedule<_D> g = _group(<_D>[
      (name: 'B', minutes: 1200, status: DoseStatus.pending),
      (name: 'A', minutes: 480, status: DoseStatus.pending),
      (name: 'C', minutes: 480, status: DoseStatus.pending),
    ]);
    expect(g.open.map((TimeGroup<_D> t) => t.minutes), <int>[480, 1200]);
    expect(g.open.first.items.map((_D d) => d.name), <String>['A', 'C']);
    expect(g.done, isEmpty);
  });

  test('taken and skipped doses move to the bottom section', () {
    final GroupedSchedule<_D> g = _group(<_D>[
      (name: 'A', minutes: 480, status: DoseStatus.taken),
      (name: 'B', minutes: 840, status: DoseStatus.pending),
      (name: 'C', minutes: 600, status: DoseStatus.skipped),
    ]);
    expect(g.open.single.minutes, 840);
    expect(g.done.map((TimeGroup<_D> t) => t.minutes), <int>[480, 600]);
  });

  test('missed doses stay in the open section so they are not forgotten', () {
    final GroupedSchedule<_D> g = _group(<_D>[
      (name: 'A', minutes: 480, status: DoseStatus.missed),
      (name: 'B', minutes: 1200, status: DoseStatus.pending),
    ]);
    expect(g.open.map((TimeGroup<_D> t) => t.minutes), <int>[480, 1200]);
  });

  test('one time can appear in both sections', () {
    final GroupedSchedule<_D> g = _group(<_D>[
      (name: 'A', minutes: 480, status: DoseStatus.taken),
      (name: 'B', minutes: 480, status: DoseStatus.pending),
    ]);
    expect(g.open.single.items.single.name, 'B');
    expect(g.done.single.items.single.name, 'A');
  });

  test('cancelled doses are not shown', () {
    final GroupedSchedule<_D> g = _group(<_D>[
      (name: 'A', minutes: 480, status: DoseStatus.cancelled),
    ]);
    expect(g.isEmpty, isTrue);
  });
}
