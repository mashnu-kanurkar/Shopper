import 'package:flutter/material.dart';

class RwNetworkImageView extends StatelessWidget {
  final String imageUrl;
  GestureTapCallback? onTap;

  double? radius;

  RwNetworkImageView({Key? key, required this.imageUrl, this.onTap, this.radius = 120.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
    );
  }
}


class RwAssetImageView extends StatelessWidget {
  String imagePath;
  GestureTapCallback? onTap;
  RwAssetImageView({Key? key, required this.imagePath, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          imagePath,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: child,
            );
          },
        ),
      ),
    );
    ;
  }
}
