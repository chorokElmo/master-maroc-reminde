import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  late final Animation<double> _scale =
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOutBack));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeIn));
  late final Animation<double> _textFade =
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        color: context.colors.onPrimary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 12)),
                        ],
                      ),
                      child: Icon(Icons.school_rounded, size: 56, color: context.colors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      Text(
                        'Master Maroc Reminder',
                        style: context.textStyles.titleLarge
                            ?.copyWith(color: context.colors.onPrimary, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Never miss a Master deadline',
                        style: context.textStyles.bodyMedium
                            ?.copyWith(color: context.colors.onPrimary.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
