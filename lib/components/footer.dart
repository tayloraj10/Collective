import 'package:collective/components/resource_link.dart';
import 'package:collective/constants.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SecondaryColorDark,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Collective is a platform to do interesting things with interesting people",
                style: pageTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ResourceLink(
              text: 'Discord',
              url: 'https://discord.gg/NqGXmvqCNx',
            ),
            SizedBox(
              width: 20,
            ),
            ResourceLink(
              text: 'Google Drive Folder',
              url:
                  'https://drive.google.com/drive/folders/1LBd6QIozQl0n2ajPlcDb9exHBlZw4gr7',
            )
          ],
        ),
      ),
    );
  }
}
