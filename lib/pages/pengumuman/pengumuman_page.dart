import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progres_save.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/main_page.dart';
import 'package:portal_desa/models/modelPengumuman.dart';
import 'package:portal_desa/pages/pengumuman/pengumuman_form.dart';
import 'package:portal_desa/pages/pengumuman/pengumuman_search.dart';
import 'package:portal_desa/services/servicePengumuman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengumumanPage extends StatefulWidget {
  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  bool loading = true;
  bool failed = true;
  String remarks;

  List resListPengumuman = new List();

  Future getData(BuildContext context) async{
    loading = true;
    failed = true;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    print(pref.getString('kodedesa'));
    getClientPengumuman().getDataPengumuman(pref.getString('kodedesa'))
    .then((res) async {
      loading = false;
      if(res.status == true){
        print("SUCCESS - TRUE");
        setState(() {
          failed = false;
          resListPengumuman = res.listData;
        });
      }else{
        print("SUCCESS - FALSE");
        setState(() {
          // failed = true;
          remarks = res.remarks;
        });
      }
    }).catchError((Object obj){
      setState(() {
        loading = false;
        failed = false;
      });
      print("FAILED");
      print(obj);
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

  postPengumuman(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (context) => ProgressSave(),
      barrierDismissible: false
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    getClientPengumuman().postBroadcast(id, pref.getString('kodedesa')).then((res) async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading ? ProgressPage() 
        : failed ? ErrorConnection(
          (){
            getData(context);
          }, remarks: remarks,) : 
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 52, 
                bottom: 24, 
                left: 22, 
                right: 16
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => SearchPengumuman(listDataPengumuman: resListPengumuman,)
                          )
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorsTheme.bag1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.search, 
                              color: ColorsTheme.primary1, 
                              size: 20,
                            ),
                            SizedBox(width: 16,),
                            Text(
                              "Cari pengumuman berdasarkan isi ...",
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsTheme.text2
                              )
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width:8),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorsTheme.primary1,
                      shape: BoxShape.circle
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => PengumumanForm(id: "",title: "Buat Pengumuman Baru")
                          )
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Icon(LineAwesomeIcons.plus, color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding( padding: EdgeInsets.only(bottom: 10), child: buildPengumuman(context, resListPengumuman)),
            SizedBox(height:24),
            
            
          ],
        ),
      ),
    );
  }

  Widget buildPengumuman(BuildContext context, List resListPengumuman){
    return ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      itemCount: resListPengumuman.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        ListDataPengumuman item = resListPengumuman[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                    child: Text(
                      item.pengumuman,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsTheme.text1
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
              child: Text(
                item.createddate,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsTheme.primary1,
                ),
              ),
            ),
            item.statusbroadcast == "Sudah di sebar" ?
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
              child: Text(
                "Sudah di sebar per tanggal : " + item.tanggalbroadcast,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsTheme.primary2,
                ),
              ),
            ) : Container(),

            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left:16, top: 8, bottom: 8, right: 2),
                    child: OutlineButton(
                      onPressed: () => {
                        Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => PengumumanForm(
                              id : item.id,
                              title: "Edit Pengumuman",
                            )
                          )
                        )
                      },
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      borderSide: BorderSide(color: ColorsTheme.primary1),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("EDIT", style: TextStyle(color: ColorsTheme.primary1),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left:2, top: 8, bottom: 8, right: 16),
                    child: FlatButton(
                      onPressed: () => {
                        postPengumuman(context, item.id)
                      },
                      color: ColorsTheme.primary1,
                      padding: EdgeInsets.all(10.0),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("BROADCAST", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 8,),
            Divider(height: 1,)
          ],
        );
      },
    );
  }
}