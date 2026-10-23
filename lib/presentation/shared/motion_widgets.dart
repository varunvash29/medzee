/// Small, reusable motion primitives shared across screens.
library;

import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_motion.dart';
import '../../domain/models/core_enums.dart';

/// Whether the platform asked for reduced motion.
bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Wraps [child] with a subtle press-scale and optional haptic tick.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.97,
    this.haptic = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptic;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && widget.onTap != null) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) => _set(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.haptic) HapticFeedback.selectionClick();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _down && !reduceMotion(context) ? widget.scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Circular progress ring that animates between values.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 88,
    this.stroke = 9,
    this.color,
    this.trackColor,
    this.child,
  });

  final double value;
  final double size;
  final double stroke;
  final Color? color;
  final Color? trackColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.clamp(0.0, 1.0)),
      duration: reduceMotion(context) ? Duration.zero : AppMotion.celebrate,
      curve: AppMotion.emphasized,
      builder: (BuildContext context, double v, Widget? _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            v,
            stroke,
            color ?? scheme.primary,
            trackColor ?? scheme.primary.withValues(alpha: 0.14),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.value, this.stroke, this.color, this.track);

  final double value;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final Paint base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        base..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Check mark that draws itself when it first appears.
class AnimatedCheck extends StatelessWidget {
  const AnimatedCheck({super.key, this.size = 20, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: reduceMotion(context) ? Duration.zero : AppMotion.medium,
      curve: AppMotion.enter,
      builder: (BuildContext context, double t, Widget? _) => CustomPaint(
        size: Size.square(size),
        painter: _CheckPainter(t, color),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.t, this.color);

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path full = Path()
      ..moveTo(size.width * 0.2, size.height * 0.54)
      ..lineTo(size.width * 0.43, size.height * 0.76)
      ..lineTo(size.width * 0.8, size.height * 0.27);
    final Path partial = Path();
    for (final PathMetric metric in full.computeMetrics()) {
      partial.addPath(metric.extractPath(0, metric.length * t), Offset.zero);
    }
    canvas.drawPath(
      partial,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.t != t || old.color != color;
}

/// Understated dosage-form glyph (capsule / tablet painted, others iconic).
class DoseFormIcon extends StatelessWidget {
  const DoseFormIcon({
    super.key,
    required this.form,
    this.size = 44,
    this.color,
    this.background,
  });

  final DosageForm form;
  final double size;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color fg = color ?? scheme.primary;
    final Color bg =
        background ?? scheme.primaryContainer.withValues(alpha: 0.7);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(size * 0.34),
        ),
        child: switch (form) {
          DosageForm.capsule => CustomPaint(painter: _PillPainter(fg, true)),
          DosageForm.tablet => CustomPaint(painter: _PillPainter(fg, false)),
          _ => Icon(_icon(form), size: size * 0.5, color: fg),
        },
      ),
    );
  }

  static IconData _icon(DosageForm form) => switch (form) {
        DosageForm.liquid => Icons.science_outlined,
        DosageForm.injection => Icons.vaccines_outlined,
        DosageForm.inhaler => Icons.air_rounded,
        DosageForm.drops => Icons.water_drop_outlined,
        DosageForm.cream => Icons.spa_outlined,
        DosageForm.patch => Icons.healing_outlined,
        _ => Icons.medication_outlined,
      };
}

class _PillPainter extends CustomPainter {
  const _PillPainter(this.color, this.capsule);

  final Color color;
  final bool capsule;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final Paint fill = Paint()..color = color;
    if (capsule) {
      canvas.rotate(-math.pi / 4);
      final double l = size.width * 0.54, w = size.width * 0.26;
      final RRect r = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: l, height: w),
        Radius.circular(w / 2),
      );
      canvas.drawRRect(r, Paint()..color = color.withValues(alpha: 0.35));
      canvas.save();
      canvas.clipRRect(r);
      canvas.drawRect(Rect.fromLTRB(-l / 2, -w / 2, 0, w / 2), fill);
      canvas.restore();
    } else {
      // A round tablet: tinted face, solid rim and a score line.
      canvas.rotate(-math.pi / 6);
      final double d = size.width * 0.5;
      canvas.drawCircle(
        Offset.zero,
        d / 2,
        Paint()..color = color.withValues(alpha: 0.22),
      );
      canvas.drawCircle(
        Offset.zero,
        d / 2,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        Offset(-d / 2, 0),
        Offset(d / 2, 0),
        Paint()
          ..color = color
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_PillPainter old) =>
      old.color != color || old.capsule != capsule;
}
