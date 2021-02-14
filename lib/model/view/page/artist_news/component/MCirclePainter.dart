import 'package:flutter/material.dart';

class MCirclePainter extends CustomPainter {
  Paint mPaint;
  final Color color;
  MCirclePainter(this.color) {
    mPaint = Paint();
    mPaint.color = this.color;
    mPaint.style = PaintingStyle.fill; // Change this to fill
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(30, 65), 55, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
