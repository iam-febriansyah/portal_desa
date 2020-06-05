import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progres_save.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/main_page.dart';
import 'package:portal_desa/services/servicePengumuman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengumumanForm extends StatefulWidget {
  String title;
  String id;
  
  PengumumanForm(
    {
      Key key, 
      this.id,
      this.title,
    }
  ):super(key:key);
  @override
  _PengumumanFormState createState() => _PengumumanFormState();
}

class _PengumumanFormState extends State<PengumumanForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validator;
  bool loading = true;
  bool failed = true;
  String remarks;

  TextEditingController ctrlId = TextEditingController();
  TextEditingController ctrlJPengumuman = TextEditingController();

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
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(
                        builder: (context) => MainPage(setIndex : 2)
                      )
                    );
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

  Future getData(BuildContext context) async{
    loading = true;
    failed = true;
    getClientPengumuman().getPengumumanEdit(widget.id == "" ? "" : widget.id).then((res) async {
      loading = false;
      if(res.statusjson == true){
        print("getData Success");
        setState(() {
          remarks = res.remarks;
          failed = false;
          ctrlId.text  = res.id == "" ? "" : res.id;
          ctrlJPengumuman.text  = res.pengumuman == "" ? "" : res.pengumuman;
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

  deleteData(BuildContext context, String id){
    getClientPengumuman().postDelete(
        widget.id,
      ).then((res) async {
      Navigator.pop(context);
      if(res.status == true){
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
          setState(() {
            remarks = null ? "Failed connection to server" :  "${res.statusCode} - ${res.statusMessage}";
          }); 
          print("GOT ERROR : ${res.statusCode} -> ${res.statusMessage}");
          break;
        default:
      }
    });
  }

  Future postData(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    showDialog(
      context: context,
      builder: (context) => ProgressSave(),
      barrierDismissible: false
    );

    getClientPengumuman().postInsert(
      widget.id,
      ctrlJPengumuman.text,
      pref.getString('kodedesa')
    ).then((res) async {
      if(res.status == true){
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
    ctrlId.text  = widget.id == "" ? "" : widget.id;
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          widget.id != "" ? 
          InkWell(
            onTap: (){
              deleteData(context, widget.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(left:24, right: 24.0),
              child: Icon(LineAwesomeIcons.trash, color: Colors.white,),
            ),
          ) : Container()
        ],
      ),
      body: loading ? ProgressPage() 
        : failed ? ErrorConnection(
          (){
            getData(context);
          }, remarks: remarks,) :
      Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: TextField(
                controller: ctrlJPengumuman,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Tulis Pengumuman * ",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: FlatButton(
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    postData(context);
                  }
                },
                color: ColorsTheme.primary1,
                padding: EdgeInsets.all(10.0),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("SIMPAN", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}