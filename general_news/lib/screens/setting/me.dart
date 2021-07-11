import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:general_news/resources/string.dart';
import 'package:package_info/package_info.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({Key? key, required this.version, required this.buildNumber})
      : super(key: key);
  final String version;
  final String buildNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(0)),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.tag_faces,
              size: 45,
              color: Colors.white,
            ),
            Spacer(),
            Text(kWelcome,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              kWelcomeDescription,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text('$kVersion $version',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 5,
            ),
            Text('$kBuildNumber $buildNumber',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            Spacer(),
            CloseButton(
              color: Colors.white,
            )
          ],
        ));
  }
}
