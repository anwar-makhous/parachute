import 'package:flutter/material.dart';
import '../../global_state.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = GlobalState.logoColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.49, size.height * -2.33);
    path_1.cubicTo(size.width * 0.86, size.height * -2.34, size.width * 1.42,
        size.height * -1.92, size.width * 1.42, size.height * -0.85);
    path_1.cubicTo(size.width * 1.42, size.height * -0.26, size.width * 1.14,
        size.height * 0.63, size.width * 0.49, size.height * 0.63);
    path_1.cubicTo(size.width * 0.12, size.height * 0.63, size.width * -0.44,
        size.height * 0.19, size.width * -0.44, size.height * -0.85);
    path_1.cubicTo(size.width * -0.44, size.height * -1.45, size.width * -0.16,
        size.height * -2.34, size.width * 0.49, size.height * -2.33);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = GlobalState.logoColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(14.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
