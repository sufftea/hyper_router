import 'package:example/features/widgets/banner_button.dart';
import 'package:flutter/material.dart';

class UsecaseBanner extends StatelessWidget {
  const UsecaseBanner({
    required this.onPressed,
    required this.title,
    required this.caption,
    required this.image,
    super.key,
  });

  final String title;
  final String caption;
  final String image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HorizontalBannerButton(
      onPressed: onPressed,
      title: title,
      caption: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          caption,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      image: image,
    );
  }
}
