import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class ResourceLink extends StatelessWidget {
  final String text;
  final String url;
  ResourceLink({this.text, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(this.text,
          textAlign: TextAlign.center,
          style: pageTextStyle.copyWith(
              color: Colors.lightBlueAccent,
              decoration: TextDecoration.underline)),
      onTap: () {
        launchURL(this.url);
      },
    );
  }
}
