import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/pages/galery/galery_form.dart';
import 'package:portal_desa/pages/galery/widget/foto.dart';
import 'package:portal_desa/pages/galery/widget/video.dart';

class GaleryPage extends StatefulWidget {
  @override
  _GaleryPageState createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage> with SingleTickerProviderStateMixin {
  TabController controller;
  int initialIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(length: 2, vsync: this, initialIndex: initialIndex);
    controller.addListener(_handleTabSelection);
    
  }

  _handleTabSelection() {
    setState(() {
      initialIndex = controller.index;
    });
    print(initialIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorsTheme.primary,
      appBar: AppBar(
        title: Text("Galeri"),
        elevation: 1,
      ),
      body: buildTab(context, controller, initialIndex),
      floatingActionButton: FloatingActionButton(
        tooltip: initialIndex == 0 ? "Add Gambar" : "Add Video Youtube",
        onPressed: () {
          Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => GaleriForm(
                id : "",
                title: initialIndex == 0 ? "Tambah Gambar" : "Tambah Video Youtube",
                jenis: initialIndex == 0 ? "foto" : "video",
              )
            )
          );
        },
        child: initialIndex == 0 ? Icon(LineAwesomeIcons.camera) : Icon(LineAwesomeIcons.video_camera),
        backgroundColor: Colors.green,
      ),
    );

  }
}

Widget buildTab(BuildContext context, controller, initialIndex){
  return DefaultTabController(
    length: 2,
    child: new Scaffold(
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: new Container(
          height: 50.0,
          child: new TabBar(
            indicatorColor: ColorsTheme.primary1,
            controller: controller,
            tabs: [
              Text("FOTO", style: TextStyle(color: initialIndex == 0 ? ColorsTheme.text1 : ColorsTheme.text2),),
              Text("VIDEO", style: TextStyle(color: initialIndex == 1 ? ColorsTheme.text1 : ColorsTheme.text2),)
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Foto(),
          Video()
        ],
      ),
    ),
  );

}