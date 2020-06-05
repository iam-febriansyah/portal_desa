import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/models/modelArtikel.dart';
import 'package:portal_desa/pages/artikel/artikel_form.dart';

class SearchArtikel extends StatefulWidget {
  List<ListDataArtikel> listDataArtikel;
  SearchArtikel(
    {Key key, this.listDataArtikel,}
  ):super(key:key);

  @override
  _SearchArtikelState createState() => _SearchArtikelState();
}

class _SearchArtikelState extends State<SearchArtikel> {

  List<ListDataArtikel> listDataArtikel_new;
  
  _onChange(String value){
    setState(() {
     listDataArtikel_new = value.isNotEmpty ? widget.listDataArtikel.where( (d) => 
        d.judul.toLowerCase().contains(value.toLowerCase()) ||
        d.isi.toString().toLowerCase().contains(value.toLowerCase())
     ).toList() : [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    listDataArtikel_new = [];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 52, left: 22, right: 22, ),
            child: Column(
              children: <Widget>[
                Text(
                  "Pencarian Berita",
                  style: TextStyle(
                    color: ColorsTheme.text1,
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                    ),
                ),

                
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22.0),
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
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      cursorColor: ColorsTheme.primary1,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsTheme.text1
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Search ...",
                        hintStyle: TextStyle(
                          color: ColorsTheme.text2
                        ),
                        border: InputBorder.none
                      ),
                      onChanged: (value){
                        _onChange(value);
                      },
                    ),
                  )

                ],
              ),
            ),
          ),

          Expanded(child: buildListDataArtikel(context, listDataArtikel_new)),
        ],
      ),
    );
  }

  Widget buildListDataArtikel(BuildContext context, List listDataArtikel){
    return SingleChildScrollView(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        itemCount: listDataArtikel.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          ListDataArtikel item = listDataArtikel[index];
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
                              Text(
                                item.penulis,
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
      ),
    );
  }

}