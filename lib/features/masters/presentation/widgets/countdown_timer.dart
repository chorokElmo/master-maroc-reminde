import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

/// Live countdown to a deadline — ticks every second so the detail screen
/// feels alive rather than showing a static "12 days left" label.
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.deadline});

  final DateTime deadline;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining = widget.deadline.difference(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = widget.deadline.difference(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining.isNegative;
    final duration = expired ? Duration.zero : _remaining;

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (expired) {
      return Text(
        'Applications closed',
        style: context.textStyles.titleMedium?.copyWith(color: context.colors.error),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimeBlock(value: days, label: 'days'),
        _Colon(),
        _TimeBlock(value: hours, label: 'hrs'),
        _Colon(),
        _TimeBlock(value: minutes, label: 'min'),
        _Colon(),
        _TimeBlock(value: seconds, label: 'sec'),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: context.colors.primary.softer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: context.textStyles.titleLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: context.textStyles.labelSmall),
      ],
    );
  }
}

class _Colon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
