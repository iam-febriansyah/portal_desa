import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/main_page.dart';
import 'package:portal_desa/services/serviceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_widget/progress.dart';

class Login extends StatefulWidget {
  String username;
  
  Login(
    {
      Key key, 
      this.username,
    }
  ):super(key:key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obscurePassword = true;
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  String validator;
  String remarks;
  final _formKey = GlobalKey<FormState>();
  int timeOut;

  Future login(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance(); 


    
    showDialog(
      context: context,
      builder: (context) => ProgressSubmit(),
      barrierDismissible: false
    );

    getClientLogin().postLogin(ctrlUsername.text, ctrlPassword.text)
    .then((res) async {
      Navigator.pop(context);
      if(res.statusJson == true){
        pref.setString("username", res.username);
        pref.setString("kodedesa", res.kodedesa);
        pref.setBool("isLogin", true);
        Navigator.pushReplacement(context, 
          MaterialPageRoute(
            builder: (context) => MainPage()
          )
        );
      }else{
        setState(() {
          validator = res.remarks;
        });
        print(res.remarks);
      }
    }).catchError((Object obj){
      Navigator.pop(context);
      switch (obj.runtimeType){
        case DioError :
          final res =  (obj as DioError).response;
          setState(() {
            remarks = null ? "Failed connection to server" :  "${res.statusCode} - ${res.statusMessage}";
          }); 
          print("GOT ERROR : ${res.statusCode} -> ${res.statusMessage}");
          break;
        default:
      }
    });
  }


  @override
  void initState() {
    super.initState();
    obscurePassword = true;
    ctrlUsername.text = widget.username != "" || widget.username != null || widget.username.isEmpty ? widget.username : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Container(
              key: _formKey,
              padding: EdgeInsets.only(left: 32, right: 32, top: 52, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Image.asset(
                      "assets/images/splashScreen.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 22,),
                  Text(
                    "Selamat Datang, ",
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold, 
                      color: ColorsTheme.text1,
                      fontFamily: "Indie_Flower"
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text(
                    "Silakan login untuk melanjutkan",
                    style: TextStyle(
                      color: ColorsTheme.text2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 42,),
                  TextFormField(
                    validator: (String arg){
                      if(arg==null || arg.isEmpty){
                        return "Username masih kosong";
                      }else{
                        return null;
                      }
                    },
                    controller: ctrlUsername,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 16
                    ),
                    cursorColor: ColorsTheme.primary1,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 16),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorsTheme.line2.withOpacity(0.4),
                          width: 1.5
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorsTheme.primary1.withOpacity(0.5),
                          width: 1.5
                        )
                      )
                    ),
                  ),
                  SizedBox(height: 24,),
                  TextFormField(
                    validator: (String arg){
                      if(arg==null || arg.isEmpty){
                        return "Password masih kosong";
                      }else{
                        return null;
                      }
                    },
                    controller: ctrlPassword,
                    obscureText: obscurePassword,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 16
                    ),
                    cursorColor: ColorsTheme.primary1,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                           obscurePassword = !obscurePassword; 
                          });
                        },
                        icon: Icon( 
                          obscurePassword ?  Icons.visibility : Icons.visibility_off,
                          color: ColorsTheme.line1.withOpacity(0.6),
                          size: 24,
                        ),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorsTheme.line2.withOpacity(0.4),
                          width: 1.5
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorsTheme.primary1.withOpacity(0.5),
                          width: 1.5
                        )
                      )
                    ),
                  ),
                  validator != null ?
                  Text(
                    validator.toString(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14
                    ),
                  ) : Container(),
                  SizedBox(height: 60),
                  MaterialButton(
                    onPressed: (){
                      // Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => MainPage()));
                      // serviceLogin.postLogin(context, ctrlUsername.text, ctrlPassword.text);
                      // if(_formKey.currentState.validate()){
                        login(context);
                      // }
                    },
                    
                    color: ColorsTheme.primary1,
                    height: 46,
                    minWidth: MediaQuery.of(context).size.width,
                    elevation: 0,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text(
                      "Sign In"
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      " ",
                      style: TextStyle(
                        color: ColorsTheme.text2,
                        fontSize: 14
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
