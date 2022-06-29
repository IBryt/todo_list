import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddWidget extends StatelessWidget {
  final Color color;
  final double size;

  const AddWidget({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Paint(color, size),
    );
  }
}

class _Paint extends CustomPainter {
  final Color color;
  final double sizeWidget;

  _Paint(this.color, this.sizeWidget);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final sideCanvasLength = _sideCanvasLength(size, strokeWidth);
    final lineLength = _lineLength(sideCanvasLength);
    final padding = strokeWidth / 2 + (sideCanvasLength - lineLength) / 2;
    final paint = _paint(strokeWidth);

    canvas.drawLine(
      Offset(padding, sideCanvasLength / 2 + strokeWidth / 4),
      Offset(sideCanvasLength - padding + strokeWidth / 2,
          sideCanvasLength / 2 + strokeWidth / 4),
      paint,
    );

    canvas.drawLine(
      Offset(sideCanvasLength / 2 + strokeWidth / 4, padding),
      Offset(sideCanvasLength / 2 + strokeWidth / 4,
          sideCanvasLength - padding + strokeWidth / 2),
      paint,
    );
  }

  double _lineLength(double sideCanvasLength) =>
      sizeWidget < sideCanvasLength ? sizeWidget : sideCanvasLength;

  double _sideCanvasLength(Size size, double strokeWidth) =>
      min(size.width, size.height) - strokeWidth / 2;

  Paint _paint(double strokeWidth) {
    return Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  @override
  bool shouldRepaint(covariant _Paint oldDelegate) =>
      oldDelegate.color != color;
}
