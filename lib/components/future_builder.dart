import 'package:flutter/material.dart';
import 'package:my_local_market/components/imageview.dart';
import 'package:my_local_market/values/constants.dart';

class RwFutureBuilder extends StatelessWidget {
  final Future future;

  final Function final_widget;

  final Widget? initial_widget;

  const RwFutureBuilder({Key? key, required this.future, required this.final_widget, this.initial_widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: RwAssetImageView(imagePath: StaticImages.error,)
            );
            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data as String;
            return final_widget(data);
          }
        }
        return const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        );
      },
      initialData: initial_widget,
    );
  }
}
