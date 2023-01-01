import 'package:flutter/material.dart';

class MySpace extends StatelessWidget {
  final color;
  final clipper;
  MySpace({this.color, this.clipper});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: ClipPath(
        clipper: clipper,
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
