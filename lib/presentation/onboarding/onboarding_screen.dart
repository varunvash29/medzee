import 'package:flutter/material.dart';
import '../profile/cloud_sync_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

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
  static const int _pageCount = 3;
  bool _busy = false;

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
    final bool isLast = _page == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: TextButton(
                  onPressed: _busy || isLast ? null : _finish,
                  child: Text(isLast ? '' : 'Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (int v) => setState(() => _page = v),
                children: <Widget>[
                  const _WelcomePage(),
                  const _FeaturesPage(),
                  _NamePage(controller: _nameController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                0,
                AppSpacing.gutter,
                AppSpacing.lg,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < _pageCount; i++)
                        AnimatedContainer(
                          duration: AppMotion.medium,
                          curve: AppMotion.standard,
                          width: i == _page ? 22 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i == _page
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(AppRadii.full),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: isLast
                        ? 'Start using Medzee'
                        : (_page == 0 ? 'Get started' : 'Next'),
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
                  if (_page == 0)
                    TextButton(
                      onPressed: _busy ? null : _joinWithCode,
                      child: const Text('I already use Medzee on another device'),
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

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MedzeeMark.tile(size: 112)
              .animate()
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                duration: AppMotion.medium,
                curve: AppMotion.enter,
              )
              .fadeIn(),
          const SizedBox(height: AppSpacing.xl),
          const MedzeeWordmark(fontSize: 38),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your medicines, sorted.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesPage extends StatelessWidget {
  const _FeaturesPage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget row(IconData icon, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(body, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'A healthier you,\none reminder at a time',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          row(
            Icons.notifications_active_outlined,
            'Never miss a dose',
            'Reminders that work even offline.',
          ),
          row(
            Icons.document_scanner_outlined,
            'Scan prescriptions',
            'Add your medicines from a photo.',
          ),
          row(
            Icons.auto_awesome_outlined,
            'Just type the name',
            'Medzee fills in strength, form and Indian brand alternatives.',
          ),
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
          Text(
            'What should we call you?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Optional. Used only for your greeting.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'e.g. Asha',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const InfoBanner(
            message: 'Your medicines stay on this device unless you turn on '
                'cloud sync in Profile.',
            icon: Icons.lock_outline_rounded,
          ),
        ],
      ),
    );
  }
}
