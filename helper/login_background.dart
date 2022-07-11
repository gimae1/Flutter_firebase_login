import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{

  LoginBackground({required this.isJoin});

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin?Colors.red:Colors.blue;//..의 뜻->
    canvas.drawCircle(Offset(size.width*0.5, size.width*0.4), size.height*0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return false;
  }

}