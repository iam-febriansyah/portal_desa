// To parse this JSON data, do
//
//     final modelArtikelEdit = modelArtikelEditFromJson(jsonString);

import 'dart:convert';

ModelArtikelEdit modelArtikelEditFromJson(String str) => ModelArtikelEdit.fromJson(json.decode(str));

String modelArtikelEditToJson(ModelArtikelEdit data) => json.encode(data.toJson());

class ModelArtikelEdit {
    bool statusjson;
    String remarks;
    String id;
    String judul;
    String tanggal;
    String penulis;
    String status;
    String isi;
    String gambar;
    String jenis;
    String kategori;
    List<ListKategoriberita> listKategoriberita;

    ModelArtikelEdit({
        this.statusjson,
        this.remarks,
        this.id,
        this.judul,
        this.tanggal,
        this.penulis,
        this.status,
        this.isi,
        this.gambar,
        this.jenis,
        this.kategori,
        this.listKategoriberita,
    });

    factory ModelArtikelEdit.fromJson(Map<String, dynamic> json) => ModelArtikelEdit(
        statusjson: json["statusjson"],
        remarks: json["remarks"],
        id: json["id"],
        judul: json["judul"],
        tanggal: json["tanggal"],
        penulis: json["penulis"],
        status: json["status"],
        isi: json["isi"],
        gambar: json["gambar"],
        jenis: json["jenis"],
        kategori: json["kategori"],
        listKategoriberita: List<ListKategoriberita>.from(json["list_kategoriberita"].map((x) => ListKategoriberita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "statusjson": statusjson,
        "remarks": remarks,
        "id": id,
        "judul": judul,
        "tanggal": tanggal,
        "penulis": penulis,
        "status": status,
        "isi": isi,
        "gambar": gambar,
        "jenis": jenis,
        "kategori": kategori,
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
