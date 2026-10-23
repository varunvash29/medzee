import 'package:flutter/material.dart';
import '../profile/cloud_sync_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/user_profile.dart';
import '../../routing/app_router.dart';
import '../../services/notification_service.dart';
import '../../state/profile_providers.dart';
import '../../state/providers.dart';
import '../shared/app_widgets.dart';
import '../shared/medzee_logo.dart';

/// First-run experience: explains what Medzee does and what it will never do,
/// then creates the local profile and asks for notification permission.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  final TextEditingController _nameController = TextEditingController();

  int _page = 0;
  bool _busy = false;

  static const List<_OnboardingPage> _pages = <_OnboardingPage>[
    _OnboardingPage(
      icon: Icons.notifications_active_outlined,
      title: 'Never miss a dose',
      body:
          'Medzee reminds you when a dose is due, keeps a precise log of what '
          'you took, and tells you honestly when something was missed. '
          'Reminders keep working across timezone changes.',
    ),
    _OnboardingPage(
      icon: Icons.inventory_2_outlined,
      title: 'Know what is left',
      body:
          'Stock is tracked dose by dose with a full audit trail. Medzee '
          'warns you before you run out, and never guesses when it cannot '
          'convert between units.',
    ),
    _OnboardingPage(
      icon: Icons.health_and_safety_outlined,
      title: 'No advice, ever',
      body:
          'Medzee does not prescribe, diagnose or invent clinical facts. '
          'Medicine information is shown with its source and date, and you '
          'stay in control of every decision.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final DateTime now = DateTime.now().toUtc();
      final String name = _nameController.text.trim();
      // Reuse the existing row when one exists. Creating a fresh id on every
      // run was how duplicate profiles could appear if onboarding was ever
      // shown again to a returning user.
      final UserProfile? existing = ref.read(profileProvider).value;
      final UserProfile base = existing ??
          UserProfile(
            id: const Uuid().v4(),
            createdAt: now,
          );
      final UserProfile profile = base.copyWith(
        displayName: name,
        clearDisplayName: name.isEmpty,
        onboardingCompleted: true,
        updatedAt: now,
      );
      await ref.read(profileControllerProvider).save(profile);

      // Ask for notification permission up front: the value proposition is
      // reminders, so waiting until the first medicine would be worse.
      final NotificationService notifications =
          ref.read(notificationServiceProvider);
      await notifications.initialize();
      await notifications.requestPermission();

      if (!mounted) return;
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Joins an existing cloud vault, then waits for its profile to arrive.
  Future<void> _joinWithCode() async {
    final bool joined = await showJoinVaultDialog(context, ref);
    if (!joined || !mounted) return;
    setState(() => _busy = true);
    for (int i = 0; i < 40; i++) {
      if (!mounted) return;
      if (ref.read(profileProvider).value?.onboardingCompleted ?? false) {
        context.go(AppRoutes.home);
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    if (mounted) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No synced data found for that code yet.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLast = _page >= _pages.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: <Widget>[
                  MedzeeMark.tile(size: 34),
                  const SizedBox(width: AppSpacing.sm),
                  const MedzeeWordmark(fontSize: 20),
                  const Spacer(),
                  TextButton(
                    onPressed: _busy ? null : _joinWithCode,
                    child: const Text('Have a code?'),
                  ),
                  TextButton(
                    onPressed: _busy ? null : _finish,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (int value) => setState(() => _page = value),
                children: <Widget>[
                  ..._pages.map((_OnboardingPage page) => _PageView(page: page)),
                  _NamePage(controller: _nameController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i <= _pages.length; i++)
                        AnimatedContainer(
                          duration: AppMotion.medium,
                          curve: AppMotion.standard,
                          width: i == _page ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: i == _page
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(
                              AppRadii.full,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: isLast ? 'Start using Medzee' : 'Continue',
                    busy: _busy,
                    onPressed: () {
                      if (isLast) {
                        _finish();
                        return;
                      }
                      _controller.nextPage(
                        duration: AppMotion.medium,
                        curve: AppMotion.enter,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _PageView extends StatelessWidget {
  const _PageView({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Icon(
              page.icon,
              size: 52,
              color: theme.colorScheme.primary,
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: AppMotion.medium,
                curve: AppMotion.enter,
              )
              .then()
              .shimmer(
                duration: const Duration(milliseconds: 700),
                color: AppColors.brandBright.withValues(alpha: 0.25),
              ),
          const SizedBox(height: AppSpacing.xxl),
          Text(page.title, style: theme.textTheme.headlineMedium)
              .animate()
              .fadeIn(duration: AppMotion.medium, delay: 80.ms)
              .slideY(begin: 0.15, curve: AppMotion.enter),
          const SizedBox(height: AppSpacing.md),
          Text(page.body, style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ))
              .animate()
              .fadeIn(duration: AppMotion.medium, delay: 160.ms)
              .slideY(begin: 0.1, curve: AppMotion.enter),
        ],
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  const _NamePage({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('What should we call you?', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Optional — used only for the greeting on your home screen. '
            'Everything stays on this device.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Preferred name',
              hintText: 'e.g. Alex',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const InfoBanner(
            message:
                'Medzee stores your data locally on this device. It does not '
                'send your medicine list anywhere.',
            icon: Icons.lock_outline_rounded,
          ),
        ],
      ),
    );
  }
}
