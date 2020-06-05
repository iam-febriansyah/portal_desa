import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/login.dart';
import 'package:portal_desa/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;
  String appName;
  String packageName;
  String version;
  String buildNumber; 

  AnimationController animationController;
  Animation<double> animation;

  dynamic startTime() async {
    final _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  _getVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState((){
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber; 
    });
  }

  void navigationPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pref.getBool('isLogin') == true ?  MainPage() : Login()),
    );
  }

  void initState(){
    _getVersion();
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: animation.value * MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                "assets/images/splashScreen.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Align( alignment: Alignment.bottomCenter, child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(version == null ? "Beta Version" : version, style: TextStyle(
                fontSize: 18,
                color: ColorsTheme.text2
              ),),
            ))
          ],
        ),
      ),
    );
  }
}