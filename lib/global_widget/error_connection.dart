import 'package:flutter/material.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';


class ErrorConnection extends StatelessWidget {
  Function onRetry;
  String remarks;

  ErrorConnection(this.onRetry, {this.remarks});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Koneksi Buruk",
              style: TextStyle(
                color: ColorsTheme.text1,
                height: 1.1,
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 8),
            Text(
              remarks == null
                ? "Gagal tersambung ke internet!"
                : remarks.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2, fontSize: 14, color: ColorsTheme.text2,
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: RaisedButton(
                onPressed: () {
                  onRetry();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: ColorsTheme.primary1,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        )
      )
    );
  }
}