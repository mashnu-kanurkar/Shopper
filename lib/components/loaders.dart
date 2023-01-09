import 'package:flutter/material.dart';
import 'package:my_local_market/values/strings.dart';

toggleLoaderDialog({
  required BuildContext context,
  required bool isLoaderPresent,
  String loaderInfo = AppStrings.loader_info,
}) {
  if (isLoaderPresent) {
    Navigator.pop(context);
    return;
  } else {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7), child: Text(loaderInfo)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
