import 'package:flutter/material.dart';
import 'package:my_local_market/values/app_theme.dart';

class RwText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;

  Function()? onTap;

  RwText({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
    this.onTap,
  });

  TextStyle? _getStyle(){
    if(textStyle != null){
      return textStyle?.copyWith(color: color);
    }else{
      return TextStyle(color: color, fontSize: themeData_light.textTheme.bodyText1?.fontSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: _getStyle(),
      ),
    );
  }
}

class RwRichText extends StatelessWidget {
  dynamic text;

  Function()? onTap;

  RwRichText({Key? key, required this.text, this.onTap, }) : super(key: key);

  List<String> _getListOfTextSpans(){
    if(text.runtimeType == String){
      String text2 = text as String;
      return text2.split(" ");
    } else if(text.runtimeType == List<String>){
      return text;
    }
    return [""];
  }
  @override
  Widget build(BuildContext context) {
    List<String> _listOfTextSpans = _getListOfTextSpans();
    return GestureDetector(
      onTap: onTap,
      child: const Text.rich(
        TextSpan(
          text: 'Hello ',
          style: TextStyle(fontSize: 50),
          children: <TextSpan>[
            TextSpan(
                text: 'world',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                )),
            // can add more TextSpans here...
          ],
        ),
      ),
    );
  }
}

