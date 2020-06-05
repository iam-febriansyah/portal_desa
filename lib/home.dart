import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progress.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/models/modelHome.dart';
import 'package:portal_desa/pages/artikel/artikel_form.dart';
import 'package:portal_desa/pages/artikel/artikel_search.dart';
import 'package:portal_desa/pages/pengumuman/pengumuman_form.dart';
import 'package:portal_desa/services/serviceArtikel.dart';
import 'package:portal_desa/services/serviceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  bool failed = true;
  String remarks;
  
  List resListArtikel = new List();
  List resListGaleri = new List();
  List resListPengumuman = new List();

  Future getData(BuildContext context) async{
    loading = true;
    failed = true;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    getClientLogin().getHome(pref.getString('kodedesa'))
    .then((res) async {
      loading = false;
      if(res.status == true){
        setState(() {
          failed = false;
          resListArtikel = res.listBerita;
          resListGaleri = res.listGaleri;
          resListPengumuman = res.listPengumuman;
        });
      }else{
        setState(() {
          failed = true;
          remarks = res.remarks;
        });
      }
    }).catchError((Object obj){
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

  List listDataArtikel = new List();

  Future getDataSearch(BuildContext context) async{
    loading = true;
    failed = true;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    getClientArtikel().getData(pref.getString('kodedesa'))
    .then((res) async {
      loading = false;
      if(res.status == true){
        setState(() {
          failed = false;
          listDataArtikel = res.listData;
        });
      }else{
        setState(() {
          // failed = true;
          remarks = res.remarks;
        });
      }
    }).catchError((Object obj){
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
    getDataSearch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading ? ProgressPage() 
        : failed ? ErrorConnection(
          (){
            getData(context);
          }, remarks: remarks,) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 52, 
                bottom: 24, 
                left: 16, 
                right: 16
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorsTheme.bag1,
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/images/splashScreen.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => SearchArtikel(listDataArtikel: listDataArtikel,)
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
                              "Cari Berita ...",
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
                ],
              ),
            ),

            Padding( padding: EdgeInsets.only(bottom: 10), child: buildBerita(context, resListArtikel)),
            SizedBox(height:24),
            Padding(
              padding: EdgeInsets.only(left: 26, right: 22,),
              child: Text("Galeri",
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsTheme.text1
                ),
              ),
            ),
            SizedBox( height:200, child: buildGalery(context, resListGaleri)),
            SizedBox(height:24),
            Padding(
              padding: EdgeInsets.only(left: 26, right: 22,),
              child: Text("Pengumuman",
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsTheme.text1
                ),
              ),
            ),
            SizedBox(height:16),
            Padding( padding: EdgeInsets.only(bottom: 10), child: buildPengumuman(context, resListPengumuman)),
            
          ],
        ),
      ),
    );
  }


  Widget buildBerita(BuildContext context, List resListArtikel){
    return ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      itemCount: resListArtikel.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        ListBerita item = resListArtikel[index];
        return InkWell(
          onTap: (){
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => ArtikelForm(
                  id : item.id,
                  title: "Edit Berita",
                )
              )
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 22, right: 22, top: 4, ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 64,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 2,
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: ConfigURL.urlGambarBerita+""+item.gambar,
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:6.0, right: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.judul,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsTheme.text1,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            SizedBox(height: 4,),
                            Text(
                              item.tanggalpublis,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsTheme.primary1
                              ),
                            ),
                            SizedBox(height: 4,),

                            // Html(
                            //   renderNewlines: false,
                            //   data: item.isi,
                            //   defaultTextStyle: TextStyle(
                            //     fontSize: 12,
                            //     color: ColorsTheme.text2,
                      
                            //   ),
                            // ),
                            
                            Text(
                              "By : " + item.penulis,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsTheme.text2,
                      
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      LineAwesomeIcons.angle_right, 
                      color: ColorsTheme.text2, 
                      size: 14,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Divider(height: 1,),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildGalery(BuildContext context, List resListGaleri){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: 8),
      shrinkWrap: true,
      itemCount: resListGaleri.length,
      itemBuilder: (context, index){
        ListGaleri item = resListGaleri[index];
        bool first = index == 0;
        bool last = resListGaleri.length == (index + 1);
        return Container(
          margin: EdgeInsets.only(left: first ? 16 : 0, right: last ? 16 : 0),
          padding: EdgeInsets.only(left: 4, right: 4),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            elevation: 2,
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: ConfigURL.urlGambarGalery+""+item.gambar,
                fit: BoxFit.cover
              ),
            ),
          ),
        );
      },
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
        ListPengumuman item = resListPengumuman[index];
        return InkWell(
          onTap: (){
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => PengumumanForm(
                  id : item.id,
                  title: "Edit Pengumuman",
                )
              )
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 22, right: 22, top: 4, ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:6.0, right: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.pengumuman,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 20,
                                color: ColorsTheme.text2,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            SizedBox(height: 4,),
                            Text(
                              item.createddate,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsTheme.primary1
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      LineAwesomeIcons.angle_right, 
                      color: ColorsTheme.text2, 
                      size: 14,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Divider(height: 1,),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}