import 'package:flutter/material.dart';

class RwText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color color;

  const RwText({super.key, required this.text, this.textStyle, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: textStyle??Theme.of(context).textTheme.bodyText1,
    );
  }
}
