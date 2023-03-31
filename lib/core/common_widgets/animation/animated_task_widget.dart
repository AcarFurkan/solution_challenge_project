import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask({Key? key}) : super(key: key);

  @override
  _AnimatedTaskState createState() => _AnimatedTaskState();
}

class _AnimatedTaskState extends State<AnimatedTask>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _animationController.addStatusListener(_checkStatusUpdates);
    _curveAnimation = _animationController.drive(
      CurveTween(curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_checkStatusUpdates);
    _animationController.dispose();
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (mounted) {
        setState(() => _showCheckIcon = true);
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _showCheckIcon = false);
        }
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    // print(details);
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.forward();
    } else if (!_showCheckIcon) {
      _animationController.value = 0.0;
    }
  }

  void _handleTapCancel() {
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel(),
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (BuildContext context, Widget? child) {
          // final themeData = AppTheme.of(context);
          final progress = _curveAnimation.value;
          final hasCompleted = progress == 1.0;
          // final iconColor =
          //     hasCompleted ? themeData.accentNegative : themeData.taskIcon;
          // print(progress);
          const factor = 0.5;

          return Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "%60 Completed",
                    style: context.textTheme.headlineLarge
                        ?.copyWith(color: Colors.teal),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/check.svg',
                // color: color,
              ),
              TaskCompletionRing(
                progress: progress,
              ),
              if (hasCompleted)
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: factor,
                    heightFactor: factor,
                    child: SvgPicture.asset(
                      'assets/check.svg', color: Colors.white,
                      // color: color,
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class TaskCompletionRing extends StatelessWidget {
  const TaskCompletionRing({super.key, required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context) {
    // final themeData = AppTheme.of(context);
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: RingPainter(
          progress: progress,
          taskNotCompletedColor: Colors.teal,
          taskCompletedColor: Colors.tealAccent,
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({
    required this.progress,
    required this.taskNotCompletedColor,
    required this.taskCompletedColor,
  });
  final double progress;
  final Color taskNotCompletedColor;
  final Color taskCompletedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final notCompleted = progress < 1.0;
    final strokeWidth = size.width / 15.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        notCompleted ? (size.width - strokeWidth) / 2 : size.width / 2;

    if (notCompleted) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth
        ..color = Colors.white.withOpacity(.4)
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, radius, backgroundPaint);
    }

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white54.withOpacity(.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4)
      ..style = notCompleted ? PaintingStyle.stroke : PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );

    final partialPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = taskCompletedColor
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * 0.2,
      false,
      foregroundPaint,
    );

    final partialPaint2 = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = Colors.deepOrangeAccent
      ..style = PaintingStyle.stroke;
    if (notCompleted) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + (2 * pi * 0.2),
        2 * pi * 0.4,
        false,
        partialPaint2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
