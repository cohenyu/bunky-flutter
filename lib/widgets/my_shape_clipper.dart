import 'package:flutter/material.dart';


class CustomShapeClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    var path = Path();

    path.lineTo(0.0, 390.0 - 100);
    path.quadraticBezierTo(size.width / 2, 400, size.width, 390.0 - 100);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}