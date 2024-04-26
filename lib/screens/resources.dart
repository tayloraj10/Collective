import 'package:collective/components/resource_link.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
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
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Text(
                      "Collective is a platform to do interesting things with interesting people",
                      style: pageTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Resources',
                      style: pageTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ResourceLink(
                      text: 'Discord',
                      url: 'https://discord.gg/NqGXmvqCNx',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ResourceLink(
                      text: 'Google Drive Folder',
                      url:
                          'https://drive.google.com/drive/folders/1LBd6QIozQl0n2ajPlcDb9exHBlZw4gr7',
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Tooltip(
                      message: 'tayloraj10@gmail.com',
                      waitDuration: Duration(seconds: 1),
                      child: ResourceLink(
                        text: 'Contact Me',
                        url: 'mailto:<tayloraj10@gmail.com>',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
