import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';

class ProgressSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      elevation: 50,
      backgroundColor: Colors.white,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.12,
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              padding: EdgeInsets.only(right: 16),
              child: SpinKitSquareCircle(
                color: ColorsTheme.primary1,
                size: 30,
                duration: Duration(milliseconds: 1200),
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Mohon tunggu ...",
                    style: TextStyle(
                      color: ColorsTheme.primary1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    "Wait until it's finished",
                    style: TextStyle(
                      color: ColorsTheme.text2,
                      fontSize: 14
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}