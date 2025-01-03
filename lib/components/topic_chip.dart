import 'package:flutter/material.dart';

class TopicChip extends StatelessWidget {
  final String topic;

  TopicChip(this.topic);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.black,
      label: Text(
        topic,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
