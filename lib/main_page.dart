import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/pages/artikel/artikel_page.dart';
import 'package:portal_desa/pages/galery/galery_page.dart';
import 'package:portal_desa/pages/pengumuman/pengumuman_page.dart';
import 'package:portal_desa/pages/profile/profile_page.dart';

import 'home.dart';

class MainPage extends StatefulWidget {
  int setIndex;
  
  MainPage(
    {
      Key key, 
      this.setIndex,
    }
  ):super(key:key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex;
  List<Widget> pages = [
    Home(),
    ArtikelPage(),
    PengumumanPage(),
    GaleryPage(),
    ProfilePage()
  ];

  _onItemTap(int index){
    setState(() {
     _selectedIndex = index; 
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.setIndex == null ? 0 : widget.setIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.home),
            title: Text(
              "Home",
              style: TextStyle(

              ),
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.newspaper_o),
            title: Text(
              "Berita",
              style: TextStyle(

              ),
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.bullhorn),
            title: Text(
              "Pengumuman",
              style: TextStyle(
                
              ),
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.photo),
            title: Text(
              "Galery",
              style: TextStyle(
                
              ),
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user),
            title: Text(
              "Profile",
              style: TextStyle(
                
              ),
            )
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsTheme.primary1,
        unselectedItemColor: ColorsTheme.line1,
        onTap: _onItemTap,
      ),
      
    );
  }
}