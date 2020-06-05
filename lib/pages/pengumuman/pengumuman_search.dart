import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/models/modelPengumuman.dart';
import 'package:portal_desa/pages/pengumuman/pengumuman_form.dart';

class SearchPengumuman extends StatefulWidget {
  List<ListDataPengumuman> listDataPengumuman;
  SearchPengumuman(
    {Key key, this.listDataPengumuman,}
  ):super(key:key);

  @override
  _SearchPengumumanState createState() => _SearchPengumumanState();
}

class _SearchPengumumanState extends State<SearchPengumuman> {

  List<ListDataPengumuman> listDataPengumuman_new;
  
  _onChange(String value){
    setState(() {
     listDataPengumuman_new = value.isNotEmpty ? widget.listDataPengumuman.where( (d) => 
        d.pengumuman.toLowerCase().contains(value.toLowerCase()) 
     ).toList() : [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    listDataPengumuman_new = [];
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
                  "Pencarian Pengumuman",
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

          Expanded(child: buildListDataPengumuman(context, listDataPengumuman_new)),
        ],
      ),
    );
  }

  Widget buildListDataPengumuman(BuildContext context, List listDataPengumuman){
    return SingleChildScrollView(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        itemCount: listDataPengumuman.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          ListDataPengumuman item = listDataPengumuman[index];
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
                        onPressed: () {
                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (context) => PengumumanForm(id: item.id, title: "Edit Pengumuman Baru")
                            )
                          );
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
                        onPressed: () => {},
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
      )
    );
  }

}