import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';


class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitThreeBounce(
              color: ColorsTheme.primary1,
              size: 25.0,
            ),
            SizedBox(height: 16),
            Text("Mohon tunggu",
              style: TextStyle(
                color: ColorsTheme.text1,
                height: 1.1,
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 8),
            Text("Loading ...",
              style: TextStyle(
                height: 1.1, fontSize: 14, color: ColorsTheme.text2
              )
            ),
          ],
        )
      )
    );
  }
}