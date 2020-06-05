import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:portal_desa/general_setting/api.dart';
import 'package:portal_desa/general_setting/colors_theme.dart';
import 'package:portal_desa/global_widget/error_connection.dart';
import 'package:portal_desa/global_widget/progres_save.dart';
import 'package:portal_desa/global_widget/progress_page.dart';
import 'package:portal_desa/main_page.dart';
import 'package:portal_desa/models/modelGaleriEdit.dart';
import 'package:portal_desa/services/serviceGalery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class GaleriForm extends StatefulWidget {
  
  String title;
  String id;
  String jenis;
  
  GaleriForm(
    {
      Key key, 
      this.id,
      this.title,
      this.jenis
    }
  ):super(key:key);
  @override
  _GaleriFormState createState() => _GaleriFormState();
}

class Status{
  final String text;
  final String value;

  Status(this.text, this.value);
}

class _GaleriFormState extends State<GaleriForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List listKategori = List();
  final format = DateFormat("yyyy-MM-dd");
  File fileImage;
  String validator;
  bool loading = true;
  bool failed = true;
  String remarks;
  String notSelectedKategori;
  String selectedKategori;
  String checkWatch;
  String checkV;
  bool statusWatch;
  bool statusV;

  TextEditingController ctrlId = TextEditingController();
  TextEditingController ctrlJudul = TextEditingController();
  TextEditingController ctrlKeterangan = TextEditingController();
  TextEditingController ctrlKategori = TextEditingController();
  TextEditingController ctrlVideo = TextEditingController();
  String gambar;

  deleteData(BuildContext contex){
    print(widget.id);
    getClientGaleri().postDelete(
        widget.id,
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
                        builder: (context) => MainPage(setIndex : 3)
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
  
  Future postDataFoto(BuildContext context) async{
    
    print(notSelectedKategori);
    
    showDialog(
      context: context,
      builder: (context) => ProgressSave(),
      barrierDismissible: false
    );

    SharedPreferences pref = await SharedPreferences.getInstance(); 
    FormData formdata = new FormData();
    
    if (fileImage != null &&
      fileImage.path != null &&
      fileImage.path.isNotEmpty){

      String fileName = path.basename(fileImage.path);
      print("File Name : $fileName");
      print("File Size : ${fileImage.lengthSync()}");
      formdata.add("gambar", new UploadFileInfo(fileImage, fileName));

      print(pref.getString('kodedesa'));
      print(ctrlJudul.text);
      print(ctrlKeterangan.text);
      print(selectedKategori == null || selectedKategori.isEmpty || selectedKategori == "" ? notSelectedKategori : selectedKategori);
      print(widget.id == "" ? "0" : widget.id);

      getClientGaleri().postInsertFoto(
        pref.getString('kodedesa'),
        ctrlJudul.text,
        ctrlKeterangan.text,
        widget.id == "" || widget.id == null || widget.id.isEmpty ? "0" : widget.id,
        selectedKategori == null || selectedKategori.isEmpty || selectedKategori == "" ? notSelectedKategori : selectedKategori,
        "foto",
        fileImage
      ).then((res) async {
        Navigator.pop(context);
        print(res.remarks);
        if(res.status == true){
          dialogRes(context, res.remarks, true);
        }else{
          dialogRes(context, "Gagal Upload", false);
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

  Future postDataVideo(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance(); 
    statusWatch = ctrlVideo.text.contains("watch/");
    statusV = ctrlVideo.text.contains("v=");

    if(statusWatch == false && statusV == false){
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
                  child: Center(child: Text("Pastikan URL Youtube terisi dengan benar"))
                ),
              ],
            ),
          ),
        barrierDismissible: true
      );
    }else{
      if (ctrlVideo.text != null &&
        ctrlVideo.text != null &&
        ctrlVideo.text.isNotEmpty){

        showDialog(
          context: context,
          builder: (context) => ProgressSave(),
          barrierDismissible: false
        );

        getClientGaleri().postInsertVideo(
          pref.getString('kodedesa'),
          ctrlJudul.text,
          ctrlKeterangan.text,
          widget.id == "" || widget.id == null || widget.id.isEmpty ? "0" : widget.id,
          selectedKategori == null || selectedKategori.isEmpty || selectedKategori == "" ? notSelectedKategori : selectedKategori,
          "video",
          ctrlVideo.text
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
                    child: Center(child: Text("Anda belum mengisi URL Youtube"))
                  ),
                ],
              ),
            ),
          barrierDismissible: true
        );
      }
    }
  }

  Future getGaleriEdit(BuildContext context) async{
    loading = true;
    failed = true;
    getClientGaleri().getGaleriEdit(widget.id == "" ? "" : widget.id).then((res) async {
      loading = false;
      if(res.statusjson == true){
        setState(() {
          remarks = res.remarks;
          failed = false;
          listKategori =  res.listKategoriberita;
          ctrlJudul.text  = res.judul == "" ? "" : res.judul;
          ctrlKeterangan.text  = res.keterangan == "" ? "" : res.keterangan;
          selectedKategori  = res.idkategori == "" ? "" : res.idkategori;
          gambar  = res.gambar == "" ? "" : res.gambar;
          ctrlVideo.text = res.gambar.toString() == "" ? "" : res.gambar.toString();
          getOneDataKategori(context, listKategori);
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


  void getOneDataKategori(BuildContext context, List listKategori){
    for(int i = 0;  i < listKategori.length; i++){
      if(i == 0){
        setState(() {
          notSelectedKategori = listKategori[i].id;
        });
      }
    }
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
    String newPath = path.join(dir, 'Fotofromcamera.jpg');
    print('NewPath: ${newPath}');
    setState(() {
     fileImage = image.renameSync(newPath); 
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
    getGaleriEdit(context);
    ctrlId.text  = widget.id == "" ? "" : widget.id;
    String ch = "watch/2";
    bool ok;
    ok = ch.contains("watch/");
    print(ok);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title
        ),
        actions: <Widget>[
          widget.id != "" ? 
          InkWell(
            onTap: (){
              deleteData(context);
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
            getGaleriEdit(context);
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
                    hintText: 'Masukkan Judul Gambar / Video',
                    labelText: 'Judul',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  // minLines: 3,
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "Keterangan Masih Kosong";
                    }else{
                      return null;
                    }
                  },
                  controller: ctrlKeterangan,
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.align_justify),
                    labelText: 'Keterangan',
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
              
              widget.jenis == "foto" ?
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
              ) : Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  // minLines: 2,
                  validator: (String arg){
                    if(arg==null || arg.isEmpty){
                      return "URL Youtube masih kosong";
                    }else{
                      return null;
                    }
                  },
                  controller: ctrlVideo,
                  decoration: const InputDecoration(
                    icon: const Icon(LineAwesomeIcons.youtube),
                    labelText: 'URL Youtube',
                  ),
                ),
              ),

              widget.jenis == "foto" ?
              Center(
                child: gambar != "" && fileImage == null ? 
                  //JIKA EDIT GAMBAR NYA ADA MAKA MUNCUL GAMBAR
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(imageUrl: ConfigURL.urlGambarGalery + "" + gambar),
                  ) : Container()
              ) : Container(),
                
              widget.jenis == "foto" ?    //ELSE
              Center(
                  child:  fileImage == null ? 

                  //JIKA FITUR ADD (BELUM SELECT GAMBAR)
                  Container()

                  //JIKA FITUR ADD (SUDAH SELECT GAMBAR)
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(fileImage),
                  ),
              ) : Container(),
              
              SizedBox(height:8),

              Padding(
                padding: const EdgeInsets.only(left: 8, right:8, bottom: 32.0),
                child: MaterialButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      // Navigator.pop(context);
                      widget.jenis == "foto" ? postDataFoto(context) : postDataVideo(context);
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