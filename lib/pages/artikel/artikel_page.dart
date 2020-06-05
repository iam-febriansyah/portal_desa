import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/pages/artikel/artikel_form.dart';
import 'package:portal_desa/pages/artikel/artikel_search.dart';
import 'package:portal_desa/services/serviceArtikel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtikelPage extends StatefulWidget {
  @override
  _ArtikelPageState createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  bool loading = true;
  bool failed = true;
  String remarks;


  
  List resListArtikel = new List();

  Future getData(BuildContext context) async{
    loading = true;
    failed = true;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    getClientArtikel().getData(pref.getString('kodedesa'))
    .then((res) async {
      loading = false;
      if(res.status == true){
        setState(() {
          failed = false;
          resListArtikel = res.listData;
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
                            builder: (context) => SearchArtikel(listDataArtikel: resListArtikel,)
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
                              "Cari berita berdasarkan judul ...",
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
                            builder: (context) => ArtikelForm(id: "",title: "Buat Berita Baru")
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

            Padding( padding: EdgeInsets.only(bottom: 10), child: buildBerita(context, resListArtikel)),
            SizedBox(height:24),
            
            
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
        ListDataArtikel item = resListArtikel[index];
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
}