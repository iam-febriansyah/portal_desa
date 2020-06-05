import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/models/modelGalery.dart';
import 'package:portal_desa/pages/galery/galery_form.dart';
import 'package:portal_desa/services/serviceGalery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {

  bool loading = true;
  bool failed = true;
  String remarks;
  int currentPos;
  String stateText;


  List resListVideo = new List();

  Future getData(BuildContext context) async{
    loading = true;
    failed = true;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    print(pref.getString('kodedesa'));
    getClientGaleri().getData(pref.getString('kodedesa'), 'video')
    .then((res) async {
      loading = false;
      if(res.status == true){
        print("SUCCESS - TRUE");
        setState(() {
          failed = false;
          resListVideo = res.listData;
        });
      }else{
        print("SUCCESS - FALSE");
        setState(() {
          failed = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return loading ? ProgressPage() 
        : failed ? ErrorConnection(
          (){
            getData(context);
          }, remarks: remarks,) : SingleChildScrollView(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        itemCount: resListVideo.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          ListDataGaleri item = resListVideo[index];
          final List<String> playlist = <String>[ item.url];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 8),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.kategori,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorsTheme.primary1,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (context) => GaleriForm(
                                id : item.id,
                                title: "Edit Video",
                                jenis: "video",
                              )
                            )
                          );
                        },
                        child: ClipOval(
                          child: Container( 
                            padding: EdgeInsets.all(8), 
                            color: ColorsTheme.bag1, 
                            child: Icon(
                              LineAwesomeIcons.pencil,
                              color: ColorsTheme.primary1,
                            )
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 300,
                    child: FluTube.playlist(
                      playlist,
                      autoInitialize: true,
                      aspectRatio: 16 / 9,
                      allowMuting: false,
                      looping: true,
                      deviceOrientationAfterFullscreen: [
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ],
                      systemOverlaysAfterFullscreen: SystemUiOverlay.values,
                      onVideoStart: () {
                        setState(() {
                          stateText = 'Video started playing!';
                        });
                      },
                      onVideoEnd: () {
                        setState(() {
                          stateText = 'Video ended playing!';
                          if((currentPos + 1) < playlist.length)
                            currentPos++;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Text(
                  item.judul,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsTheme.text1,
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Text(
                  item.keterangan,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsTheme.text2,
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Divider(height: 1,),
              SizedBox(height: 16,),
            ],
          );
        },
      ),
    );
  }
}
