import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_motion.dart';

/// The Medzee mark: a tilted two-tone capsule.
///
/// Geometry matches `tool/make_icons.py`, which renders the launcher icons, so
/// the in-app mark and the home-screen icon always agree.
class MedzeeMark extends StatelessWidget {
  const MedzeeMark({
    super.key,
    this.size = 48,
    this.primary = Colors.white,
    this.secondary = const Color(0xFFC9C9FF),
    this.seam = const Color(0x663D3DD1),
  });

  final double size;

  /// Colour of the lower-left half.
  final Color primary;

  /// Colour of the upper-right half.
  final Color secondary;
  final Color seam;

  /// Mark on a rounded teal tile, used on splash and onboarding.
  static Widget tile({double size = 72}) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.28),
          color: const Color(0xFF5B5BF0),
        ),
        child: MedzeeMark(size: size),
      );

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: CustomPaint(
          size: Size.square(size),
          painter: _MarkPainter(primary, secondary, seam),
        ),
      );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.primary, this.secondary, this.seam);

  final Color primary;
  final Color secondary;
  final Color seam;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final double length = s * 0.56 * 1.3;
    final double width = s * 0.27 * 1.3;
    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.rotate(-math.pi / 4);
    final RRect capsule = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: length, height: width),
      Radius.circular(width / 2),
    );
    canvas.clipRRect(capsule);
    canvas.drawRect(
      Rect.fromLTRB(-length / 2, -width / 2, 0, width / 2),
      Paint()..color = primary,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, -width / 2, length / 2, width / 2),
      Paint()..color = secondary,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width * 0.04, height: width),
      Paint()..color = seam,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.primary != primary || old.secondary != secondary || old.seam != seam;
}

/// "medzee" wordmark.
class MedzeeWordmark extends StatelessWidget {
  const MedzeeWordmark({super.key, this.fontSize = 28, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color resolved = color ?? Theme.of(context).colorScheme.onSurface;
    return Text(
      'medzee',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -fontSize * 0.03,
        color: resolved,
        height: 1,
      ),
    );
  }
}

/// Logo lock-up that settles in: tile scales up, wordmark fades after it.
class MedzeeLogoLockup extends StatelessWidget {
  const MedzeeLogoLockup({super.key, this.tileSize = 84, this.color});

  final double tileSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MedzeeMark.tile(size: tileSize)
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              duration: AppMotion.slow,
              curve: AppMotion.emphasized,
            )
            .fadeIn(duration: AppMotion.medium),
        SizedBox(height: tileSize * 0.22),
        MedzeeWordmark(fontSize: tileSize * 0.36, color: color)
            .animate(delay: 220.ms)
            .fadeIn(duration: AppMotion.medium)
            .slideY(begin: 0.3, curve: AppMotion.enter),
      ],
    );
  }
}
