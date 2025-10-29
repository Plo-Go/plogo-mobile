import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineSpinner extends StatefulWidget {
  const LineSpinner({
    super.key,
    this.size = 60,
    this.lineCount = 12,
    this.lineLength = 14,
    this.lineWidth = 3,
    this.duration = const Duration(milliseconds: 1000),
  });

  final double size;        // 전체 크기
  final int lineCount;      // 선 개수
  final double lineLength;  // 선의 세로 길이
  final double lineWidth;   // 선의 두께
  final Duration duration;  // 회전 속도

  @override
  State<LineSpinner> createState() => _LineSpinnerState();
}

class _LineSpinnerState extends State<LineSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _LinePainter(
              lineCount: widget.lineCount,
              lineLength: widget.lineLength,
              lineWidth: widget.lineWidth,
            ),
          ),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final int lineCount;
  final double lineLength;
  final double lineWidth;

  _LinePainter({
    required this.lineCount,
    required this.lineLength,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final paint = Paint()
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < lineCount; i++) {
      final angle = (2 * math.pi / lineCount) * i;
      final opacity = (i + 1) / lineCount;

      paint.color = Colors.black.withOpacity(opacity * 0.9);

      final start = Offset(
        center.dx + (radius - lineLength) * math.cos(angle),
        center.dy + (radius - lineLength) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
