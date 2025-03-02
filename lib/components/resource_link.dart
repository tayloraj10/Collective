import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class ResourceLink extends StatelessWidget {
  final String text;
  final String url;
  final double? fontSize;
  ResourceLink({required this.text, required this.url, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(this.text,
          // textAlign: TextAlign.center,
          style: pageTextStyle.copyWith(
              fontSize: fontSize,
              color: Colors.lightBlueAccent,
              decoration: TextDecoration.underline)),
      onTap: () {
        launchURL(this.url);
      },
    );
  }
}
