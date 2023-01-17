import 'package:flutter/material.dart';
import 'package:my_local_market/values/constants.dart';

class RwDividerLine extends StatelessWidget {
  double height;

  double width;

  Color color;

  bool removeBasePadding;

  RwDividerLine({Key? key, this.height = double.infinity, this.width = double.infinity, this.color = Colors.teal, this.removeBasePadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: height,
      width: width,
      child: Container(
        color: color,
      ),
    ),);
  }
}
