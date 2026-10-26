import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../services/people/people_controller.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';

String _initial(Person p) => p.label.characters.first.toUpperCase();

/// A small "who is this for" chip for the Home header. Only shown once more
/// than one person shares the device; tapping it opens the switcher.
class PersonChip extends ConsumerWidget {
  const PersonChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PeopleController people = ref.watch(peopleControllerProvider);
    return ListenableBuilder(
      listenable: people,
      builder: (BuildContext context, Widget? _) {
        if (!people.hasSeveral) return const SizedBox.shrink();
        final ThemeData theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                _initial(people.active),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            label: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 90),
              child: Text(
                people.active.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () => showPeopleSheet(context, ref),
          ),
        );
      },
    );
  }
}

void showPeopleSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.xl,
        ),
        child: PeopleList(onChosen: () => Navigator.of(ctx).pop()),
      ),
    ),
  );
}

/// The people who use Medzee on this device, with a way to switch, add and
/// remove them. Everyone has their own medicines, history, settings and sync
/// code.
class PeopleCard extends ConsumerWidget {
  const PeopleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: const PeopleList(),
    );
  }
}

class PeopleList extends ConsumerWidget {
  const PeopleList({super.key, this.onChosen});

  final VoidCallback? onChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PeopleController people = ref.watch(peopleControllerProvider);
    final ThemeData theme = Theme.of(context);
    return ListenableBuilder(
      listenable: people,
      builder: (BuildContext context, Widget? _) {
        final Person active = people.active;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (onChosen != null) ...<Widget>[
              Text('Who is using Medzee?', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
            ],
            for (final Person person in people.people)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: person.id == active.id
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primaryContainer,
                  child: Text(
                    _initial(person),
                    style: TextStyle(
                      color: person.id == active.id
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Text(person.label),
                subtitle: Text(
                  person.id == active.id ? 'Open now' : 'Tap to switch',
                ),
                trailing: person.id == active.id
                    ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
                    : (person.isPrimary
                        ? null
                        : IconButton(
                            tooltip: 'Remove from this device',
                            icon: const Icon(Icons.person_remove_outlined),
                            onPressed: () =>
                                _confirmRemove(context, people, person),
                          )),
                onTap: person.id == active.id
                    ? null
                    : () async {
                        onChosen?.call();
                        await people.switchTo(person.id);
                      },
              ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_add_alt_1)),
              title: const Text('Add a person'),
              subtitle: const Text(
                'Their own medicines, history and sync code',
              ),
              onTap: () => _confirmAdd(context, people),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAdd(BuildContext context, PeopleController people) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Add a person'),
        content: const Text(
          'They get their own space in Medzee: separate medicines, history, '
          'reminders and sync code. On the next screen they can set up from '
          'scratch, or enter an existing sync code to bring their data in.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    onChosen?.call();
    await people.addPerson();
  }

  Future<void> _confirmRemove(
    BuildContext context,
    PeopleController people,
    Person person,
  ) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('Remove ${person.label}?'),
        content: const Text(
          'Their medicines, history and reminders are deleted from this '
          'device. If they use cloud sync, their data stays in the cloud and '
          'their sync code brings it back.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true) await people.remove(person.id);
  }
}
