import 'package:collective/components/initiatives_stream.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class Initiatives extends StatefulWidget {
  @override
  State<Initiatives> createState() => _InitiativesState();
}

class _InitiativesState extends State<Initiatives> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Scrollbar(
            child: Container(
              color: SecondaryColor,
              child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 75),
                  child: Column(
                    children: [
                      // Text(
                      //   'Main Initiatives: Trash Cleanups, Animal Welfare, Fitness',
                      //   style: pageTextStyle,
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      Text(
                        'These are the currently ongoing initiatives (click to contribute)',
                        style: pageTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InitiativesStream()
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
