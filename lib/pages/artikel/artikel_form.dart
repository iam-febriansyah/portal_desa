import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progres_save.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/main_page.dart';
import 'package:portal_desa/models/modelArtikelEdit.dart';
import 'package:portal_desa/models/modelMasterData.dart';
import 'package:portal_desa/services/serviceArtikel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class ArtikelForm extends StatefulWidget {
  
  String title;
  String id;
  
  ArtikelForm(
    {
      Key key, 
      this.id,
      this.title,
    }
  ):super(key:key);
  @override
  _ArtikelFormState createState() => _ArtikelFormState();
}

class Status{
  final String text;
  final String value;

  Status(this.text, this.value);
}

class _ArtikelFormState extends State<ArtikelForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List listKategori = List();
  // List dataStatus =  [{ 'text': 'Aktif', 'value' : 'Aktif'  }] ;

  final List<ArrayDefault> dataStatus = [
    ArrayDefault("Aktif", "aktif"),
    ArrayDefault("Tidak Aktif", "tidakaktif"),
  ];

  final List<ArrayDefault> dataJenis = [
    ArrayDefault("Artikel Berita", "artikel"),
    ArrayDefault("Kabar Desa", "kabardesa"),
    ArrayDefault("Potensi Desa", "potensidesa"),
  ];

  
  // List dataJenis = ['Artikel Berita', 'Kabar Desa', 'Potensi Desa']; 

  final format = DateFormat("yyyy-MM-dd");
  File fileImage;
  String validator;
  bool loading = true;
  bool failed = true;
  String remarks;
  String notSelectedKategori;
  String selectedKategori;
  String selectedJenis;
  String selectedStatus;

  TextEditingController ctrlId = TextEditingController();
  TextEditingController ctrlJudul = TextEditingController();
  TextEditingController ctrlTanggal = TextEditingController();
  TextEditingController ctrlPenulis = TextEditingController();
  TextEditingController ctrlStatus = TextEditingController();
  TextEditingController ctrlKategori = TextEditingController();
  TextEditingController ctrlIsi = TextEditingController();
  String gambar;
  bool camera;

  deleteData(BuildContext context, String id){
    getClientArtikel().postDelete(
        widget.id,
      ).then((res) async {
      // Navigator.pop(context);
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
                  padding: const EdgeInsets.only(left: 16.0, right:16),
                  child: Text(value, style: TextStyle(color: ColorsTheme.text2, fontSize: 16)),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right:12, bottom: 16.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(
                        builder: (context) => MainPage(setIndex : 1)
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
  
  Future postData(BuildContext context) async{
    print(ctrlTanggal.text);

    String ipAddress = await GetIp.ipAddress;
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    if((widget.id != "" ||  widget.id != null || widget.id != "0" || widget.id.isNotEmpty) 
      && fileImage == null
      ){
        showDialog(
          context: context,
          builder: (context) => ProgressSave(),
          barrierDismissible: false
        );

        getClientArtikel().postEditNotUpload(
            widget.id,
            ctrlJudul.text,
            ctrlTanggal.text,
            ctrlPenulis.text,
            selectedStatus,
            ctrlIsi.text,
            selectedKategori == null || selectedKategori.isEmpty || selectedKategori == "" ? notSelectedKategori : selectedKategori,
            selectedJenis,
            ipAddress,
            pref.getString('username'),
            pref.getString('kodedesa')
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

    }else{
    
      if (fileImage != null &&
        fileImage.path != null &&
        fileImage.path.isNotEmpty){

        showDialog(
          context: context,
          builder: (context) => ProgressSave(),
          barrierDismissible: false
        );

        FormData formdata = new FormData();

        String fileName = path.basename(fileImage.path);
        // print(base64Encode(fileImage.readAsBytesSync()));
        print("File Name : $fileName");
        print("File Size : ${fileImage.lengthSync()}");
        formdata.add("gambar", new UploadFileInfo(fileImage, fileName));
        
        getClientArtikel().postAddEdit(
            widget.id,
            ctrlJudul.text,
            ctrlTanggal.text,
            ctrlPenulis.text,
            selectedStatus,
            ctrlIsi.text,
            selectedKategori == null || selectedKategori.isEmpty || selectedKategori == "" ? notSelectedKategori : selectedKategori,
            selectedJenis,
            ipAddress,
            pref.getString('username'),
            pref.getString('kodedesa'),
            fileImage
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
                  Container(
                    height: 100,
                    child: Center(child: Text("Anda belum memilih gambar"))
                  ),
                ],
              ),
            ),
          barrierDismissible: true
        );
      }
    }
  }

  Future getBeritaEdit(BuildContext context) async{
    loading = true;
    failed = true;
    getClientArtikel().getBeritaEdit(widget.id == "" ? "" : widget.id).then((res) async {
      loading = false;
      if(res.statusjson == true){
        print("getData Success");
        setState(() {
          remarks = res.remarks;
          failed = false;
          listKategori =  res.listKategoriberita;
          ctrlJudul.text  = res.judul == "" ? "" : res.judul;
          ctrlTanggal.text  = res.tanggal == "" ? "" : res.tanggal;
          ctrlPenulis.text  = res.penulis == "" ? "" : res.penulis;
          selectedStatus = res.status == "" ? "aktif" : res.status;
          selectedJenis = res.jenis == "" ? "artikel" : res.jenis;
          selectedKategori  = res.kategori == "" ? "" : res.kategori;
          gambar  = res.gambar == "" ? "" : res.gambar;
          getOneDataKategori(context, listKategori);
          ctrlIsi.text = res.isi == "" ? " " : res.isi;
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


  void getOneDataKategori(BuildContext context, List listKategori){
    print(listKategori.length);
    for(int i = 0;  i < listKategori.length; i++){
      if(i == 0){
        setState(() {
          notSelectedKategori = listKategori[i].id;
        });
      }
    }
    print(notSelectedKategori);
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.camera,
      maxWidth: 1000,
      imageQuality: 75,
      maxHeight: 800,
    );
    String dir = path.dirname(image.path);
    String newPath = path.join(dir, 'Fotofromcamera.jpg');
    print('NewPath: ${newPath}');
    setState(() {
     fileImage = image.renameSync(newPath); 
     camera = true;
    });
  }

  Future getImageFromGallery() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,
      maxWidth: 1000,
      imageQuality: 75,
      maxHeight: 800,
    );
    String dir = path.dirname(image.path);
    String newPath = path.join(dir, 'FotofromGaleri.jpg');
    print('NewPath: ${newPath}');
    setState(() {
     fileImage = image.renameSync(newPath); 
     camera = false;
    });
  }

  Future showDialogPilihan(){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    child: Text(
                      "Kamera",
                    ),
                    onTap: (){
                      getImageFromCamera();
                    },
                  )
                ),
                SizedBox(height:6),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    child: Text(
                      "Pilih dari Galeri",
                    ),
                    onTap: (){
                      getImageFromGallery();
                    },
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBeritaEdit(context);
    ctrlId.text  = widget.id == "" ? "" : widget.id;
    print("GETID : " + widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final editor = 
      TextField(
        controller: ctrlIsi,
        maxLines: 500,
        decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title
        ),
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
            getBeritaEdit(context);
          }, remarks: remarks,) : SingleChildScrollView(
        controller: ScrollController(),
        reverse: true,
        child: Form(
          key: _formKey,
          // autovalidate: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  autofocus: true,
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "Judul Masih Kosong";
                    }else{
                      return null;
                    }
                  },
                  controller: ctrlJudul,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.title),
                    hintText: 'Masukkan Judul Berita',
                    labelText: 'Judul',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: DateTimeField(
                  // autofocus: false,
                  controller: ctrlTanggal,
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.calendar),
                    labelText: 'Tanggal Publish',
                  ),
                  format: format,
                  onShowPicker: (context, ctrlTanggal) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(2015),
                      initialDate: ctrlTanggal ?? DateTime.now(),
                      lastDate: DateTime(2030)
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "Penulis Masih Kosong";
                    }else{
                      return null;
                    }
                  },
                  controller: ctrlPenulis,
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.user),
                    labelText: 'Penulis',
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    icon: const Icon(LineAwesomeIcons.list_alt)
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    hint: Text('Kategori'), 
                    items: listKategori.map((item) {
                      ListKategoriberita i = item;
                      return DropdownMenuItem(
                        child: Text(i.kategori),
                        value: i.id,
                      );
                    }).toList(),
                    onChanged: (newKategori) {
                      setState(() {
                        selectedKategori = newKategori;
                      });
                    }, 
                    value: selectedKategori == "" || selectedKategori == null  ? "1" : selectedKategori,
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    icon: const Icon(LineAwesomeIcons.check)
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    hint: Text('Status'), 
                    items: dataStatus.map((status) {
                      ArrayDefault item = status;
                      return DropdownMenuItem(
                        child: new Text(item.text),
                        value: item.value,
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      setState(() {
                        selectedStatus = newStatus;
                      });
                    }, 
                    value: selectedStatus,
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Jenis',
                    icon: const Icon(LineAwesomeIcons.check)
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    hint: Text('Jenis'), 
                    items: dataJenis.map((jenis) {
                      ArrayDefault item = jenis;
                        return DropdownMenuItem(
                          child: new Text(item.text),
                          value: item.value,
                        );
                      }).toList(),
                    onChanged: (newJenis) {
                      setState(() {
                        selectedJenis = newJenis;
                      });
                    }, 
                    value: selectedJenis,
                  )
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: (){
                      showDialogPilihan();
                    },
                    color: ColorsTheme.text2,
                    elevation: 0,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(LineAwesomeIcons.camera), 
                        SizedBox(width: 8,),
                        Text('Pilih Gambar'),
                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: gambar != "" && fileImage == null ? 
                  //JIKA EDIT GAMBAR NYA ADA MAKA MUNCUL GAMBAR
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(imageUrl: ConfigURL.urlGambarBerita + "" + gambar),
                  ) : Container()
              ),
                  //ELSE
              Center(
                  child:  fileImage == null ? 

                  //JIKA FITUR ADD (BELUM SELECT GAMBAR)
                  Container()

                  //JIKA FITUR ADD (SUDAH SELECT GAMBAR)
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(fileImage),
                  ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container( 
                  height: MediaQuery.of(context).size.height * 0.5, 
                  child: editor
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, right:8, bottom: 32.0),
                child: MaterialButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      // Navigator.pop(context);
                      postData(context);
                    }
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
                    "SIMPAN"
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}