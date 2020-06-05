import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progres_save.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/login.dart';
import 'package:portal_desa/services/serviceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;
  bool failed = true;
  String remarks;
  String status;
  String id;
  String password;
  String level;
  String foto;
  String username;
  String kodedesa;

  Future getData(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    loading = true;
    failed = true;
    getClientLogin().getUser(pref.getString('username')).then((res) async {
      loading = false;
      if(res.statusJson){
        print("getData Success");
        setState(() {
          remarks = res.remarks;
          failed = false;
          status = res.status;
          password = res.password;
          id = res.id;
          level = res.level;
          foto = res.foto;
          username = res.username;
          kodedesa = pref.getString('kodedesa');
        });
      }else{
        setState(() {
          failed = true;
          remarks = res.remarks;
        });
      }
    }).catchError((Object obj){
      print(obj);
      setState(() {
        loading = false;
        failed = true;
      });
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
    // TODO: implement initState
    super.initState();
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? ProgressPage() 
        : failed ? ErrorConnection(
          (){
            getData(context);
          }, remarks: remarks,) :
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:64),
              color: ColorsTheme.primary1,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        color: ColorsTheme.bag1,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 3.0
                        ),
                        borderRadius:BorderRadius.circular(70.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70.0),
                        child: CachedNetworkImage(
                          imageUrl: ConfigURL.urlGambarUser+""+foto,
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  kodedesa,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 12.0
                                      ),
                                      VerticalDivider(width: 4),
                                      Text(
                                        status,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                ]
                          
                        )
                      )
                    ),
                  ],
                ),
              )),
            Stack(children: [
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    height: 38,
                    color: ColorsTheme.primary1,
                  )),
                  Expanded(
                      child: Container(
                    height: 38,
                    color: Colors.white,
                  ))
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 19,
                    decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(19)),
                        color: ColorsTheme.primary1),
                  ),
                  Container(
                    height: 19,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //   shape: BoxShape.circle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19)),
                    ),
                  ),
                ],
              ),
            ]
            ),
            SizedBox(height: 32,),
            InkWell(
              onTap: (){
                _settingModalBottomSheet(context, password, id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(LineAwesomeIcons.lock, size: 32,),
                    SizedBox(width: 8,),
                    Text(
                      "Ganti Password",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            Divider(height:1),
            InkWell(
              onTap: (){
                logOut(context, username);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(LineAwesomeIcons.sign_out, size: 32,),
                    SizedBox(width: 8,),
                    Text(
                      "Log Out",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            Divider(height:1),
          ],
        ),
      )

    );
  }
}

dialogRes(BuildContext context, String value, bool status){
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => 
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          elevation: 50,
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:16.0),
                child: Icon(LineAwesomeIcons.smile_o, color: ColorsTheme.primary1, size: 16,),
              ),
              Container(
                height: 100,
                child: Center(child: Text(value, style: TextStyle(color: ColorsTheme.text2, fontSize: 24))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right:12, bottom: 16.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: ColorsTheme.primary1,
                  height: 46,
                  minWidth: MediaQuery.of(context).size.width,
                  elevation: 0,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    "Tutup"
                  ),
                ),
              ),
            ],
          ),
        ),
      barrierDismissible: false
    );
}

void logOut(BuildContext context, String username) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  Navigator.of(context).pop();
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext ctx) => Login(username: username)));
}

void postData(BuildContext context, String id, String password) async {
  showDialog(
    context: context,
    builder: (context) => ProgressSave(),
    barrierDismissible: false
  );
  print(id);
  print(password);

  getClientLogin().postChangePassword(
      id,
      password
    ).then((res) async {
      if(res.status == true){
        Navigator.pop(context);
        dialogRes(context, res.remarks, true);
      }else{
        print(res.remarks);
        dialogRes(context, res.remarks, false);
      }
    }).catchError((Object obj){
      dialogRes(context, "Koneksi Tidak ada", false);
      switch (obj.runtimeType){
        case DioError :
          final res =  (obj as DioError).response;
          print("GOT ERROR : ${res.statusCode} -> ${res.statusMessage}");
          break;
        default:
      }
    });
}

void _settingModalBottomSheet(context, password, id){
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validator;
  TextEditingController ctrlOld = TextEditingController();
  TextEditingController ctrlNew = TextEditingController();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc){
        return Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  obscureText : true,
                  controller: ctrlOld,
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "Password Lama Masih Kosong";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.lock),
                    labelText: 'Password Lama',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  obscureText : true,
                  controller: ctrlNew,
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "Password Baru Masih Kosong";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.lock),
                    labelText: 'Password Baru',
                  ),
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16),
                child: MaterialButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      if(password == ctrlOld.text){
                        postData(context, id, ctrlNew.text);
                      }else{
                          showDialog(
                            context: context,
                            builder: (context) => 
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                elevation: 50,
                                backgroundColor: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0),
                                      child: Icon(LineAwesomeIcons.smile_o, color: ColorsTheme.primary1, size: 16,),
                                    ),
                                    Container(
                                      height: 100,
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Password lama tidak sama, silakan coba lagi.", style: TextStyle(color: ColorsTheme.text2, fontSize: 14)),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right:12, bottom: 16.0),
                                      child: MaterialButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        color: ColorsTheme.primary1,
                                        height: 46,
                                        minWidth: MediaQuery.of(context).size.width,
                                        elevation: 0,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Text(
                                          "Tutup"
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            barrierDismissible: false
                          );
                        }
                      }
                  },
                  
                  color: ColorsTheme.primary1,
                  height: 46,
                  minWidth: MediaQuery.of(context).size.width,
                  elevation: 0,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    "Ganti Sekarang"
                  ),
                ),
              ),
            ],
          ),
          ),
        );
    }
  );
}