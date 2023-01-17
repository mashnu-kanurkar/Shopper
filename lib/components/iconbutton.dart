import 'package:flutter/material.dart';

class RwIconButton extends StatelessWidget {
  IconData icon;

  GestureTapCallback? onTap;

  Color color;

  double size;

  RwIconButton({Key? key, required this.icon, required this.onTap, this.color = Colors.black, this.size = 24.0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
