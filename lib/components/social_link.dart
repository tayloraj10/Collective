import 'package:flutter/material.dart';

class SocialLink extends StatelessWidget {
  final TextEditingController controller;
  final String socialName;
  final String icon;
  SocialLink(this.controller, this.socialName, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 0),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset('images/' + icon),
                onPressed: () => {},
              ),
              Text(
                socialName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controller,
          ),
        ),
      ],
    );
  }
}
