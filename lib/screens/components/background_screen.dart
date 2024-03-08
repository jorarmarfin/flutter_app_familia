import 'package:flutter/material.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';

class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: BackgroundPainter(),size: Size.infinite,);
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = appRedColor; // El color del fondo

    // Dibuja la forma superior
    final pathTop = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.2)
      ..arcToPoint(
        Offset(0, size.height * 0.4),
        radius: Radius.circular(size.width),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(pathTop, paint);

    // Dibuja la forma inferior
    final pathBottom = Path()
      ..moveTo(size.width, size.height)//Inferior izquierda
      ..lineTo(size.width, size.height * 0.7)//superior derecha
      ..arcToPoint(
        Offset(size.width*0.25, size.height ),
        radius: Radius.circular(size.width),
        clockwise: false,
      )
      ..close();
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
