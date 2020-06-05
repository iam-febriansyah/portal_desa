// To parse this JSON data, do
//
//     final modelGaleri = modelGaleriFromJson(jsonString);

import 'dart:convert';

ModelGaleri modelGaleriFromJson(String str) => ModelGaleri.fromJson(json.decode(str));

String modelGaleriToJson(ModelGaleri data) => json.encode(data.toJson());

class ModelGaleri {
    bool status;
    String remarks;
    List<ListDataGaleri> listData;

    ModelGaleri({
        this.status,
        this.remarks,
        this.listData,
    });

    factory ModelGaleri.fromJson(Map<String, dynamic> json) => ModelGaleri(
        status: json["status"],
        remarks: json["remarks"],
        listData: List<ListDataGaleri>.from(json["list_data"].map((x) => ListDataGaleri.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
        "list_data": List<dynamic>.from(listData.map((x) => x.toJson())),
    };
}

class ListDataGaleri {
    String id;
    String judul;
    String keterangan;
    String gambar;
    String url;
    String jenis;
    String idkategori;
    String kodedesa;
    String kategori;

    ListDataGaleri({
        this.id,
        this.judul,
        this.keterangan,
        this.gambar,
        this.url,
        this.jenis,
        this.idkategori,
        this.kodedesa,
        this.kategori,
    });

    factory ListDataGaleri.fromJson(Map<String, dynamic> json) => ListDataGaleri(
        id: json["id"],
        judul: json["judul"],
        keterangan: json["keterangan"],
        gambar: json["gambar"],
        url: json["url"],
        jenis: json["jenis"],
        idkategori: json["idkategori"],
        kodedesa: json["kodedesa"],
        kategori: json["kategori"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "keterangan": keterangan,
        "gambar": gambar,
        "url": url,
        "jenis": jenis,
        "idkategori": idkategori,
        "kodedesa": kodedesa,
        "kategori": kategori,
    };
}
