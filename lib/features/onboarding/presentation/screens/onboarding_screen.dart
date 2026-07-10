import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class _OnboardingPage {
  const _OnboardingPage({required this.icon, required this.title, required this.description});
  final IconData icon;
  final String title;
  final String description;
}

const _pages = [
  _OnboardingPage(
    icon: Icons.travel_explore_rounded,
    title: 'Discover Master programs',
    description: "Browse Master's programs from universities across Morocco, all in one place.",
  ),
  _OnboardingPage(
    icon: Icons.notifications_active_rounded,
    title: 'Receive smart reminders',
    description: 'Save a program and we\'ll remind you 30, 15, 7, 3 and 1 day before it closes.',
  ),
  _OnboardingPage(
    icon: Icons.checklist_rounded,
    title: 'Track every application',
    description: 'Organize your documents and follow your application from interested to accepted.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  void _finish() {
    ref.read(onboardingCompleteProvider.notifier).complete();
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(onPressed: _finish, child: const Text('Skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardingPageView(page: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? context.colors.primary : context.colors.primary.softer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    if (isLast) {
                      _finish();
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
                    }
                  },
                  child: Text(isLast ? 'Get Started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(color: context.colors.primary.softer, shape: BoxShape.circle),
            child: Icon(page.icon, size: 76, color: context.colors.primary),
          ),
          const SizedBox(height: 40),
          Text(page.title, style: context.textStyles.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            page.description,
            style: context.textStyles.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
