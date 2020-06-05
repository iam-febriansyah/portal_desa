// To parse this JSON data, do
//
//     final modelGaleriEdit = modelGaleriEditFromJson(jsonString);

import 'dart:convert';

ModelGaleriEdit modelGaleriEditFromJson(String str) => ModelGaleriEdit.fromJson(json.decode(str));

String modelGaleriEditToJson(ModelGaleriEdit data) => json.encode(data.toJson());

class ModelGaleriEdit {
    bool statusjson;
    String remarks;
    String id;
    String idkategori;
    String judul;
    String keterangan;
    String gambar;
    String jenis;
    List<ListKategoriberita> listKategoriberita;

    ModelGaleriEdit({
        this.statusjson,
        this.remarks,
        this.id,
        this.idkategori,
        this.judul,
        this.keterangan,
        this.gambar,
        this.jenis,
        this.listKategoriberita,
    });

    factory ModelGaleriEdit.fromJson(Map<String, dynamic> json) => ModelGaleriEdit(
        statusjson: json["statusjson"],
        remarks: json["remarks"],
        id: json["id"],
        idkategori: json["idkategori"],
        judul: json["judul"],
        keterangan: json["keterangan"],
        gambar: json["gambar"],
        jenis: json["jenis"],
        listKategoriberita: List<ListKategoriberita>.from(json["list_kategoriberita"].map((x) => ListKategoriberita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "statusjson": statusjson,
        "remarks": remarks,
        "id": id,
        "idkategori": idkategori,
        "judul": judul,
        "keterangan": keterangan,
        "gambar": gambar,
        "jenis": jenis,
        "list_kategoriberita": List<dynamic>.from(listKategoriberita.map((x) => x.toJson())),
    };
}

class ListKategoriberita {
    String id;
    String kategori;

    ListKategoriberita({
        this.id,
        this.kategori,
    });

    factory ListKategoriberita.fromJson(Map<String, dynamic> json) => ListKategoriberita(
        id: json["id"],
        kategori: json["kategori"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kategori": kategori,
    };
}
