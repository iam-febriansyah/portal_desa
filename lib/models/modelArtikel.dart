// To parse this JSON data, do
//
//     final modelArtikel = modelArtikelFromJson(jsonString);

import 'dart:convert';

ModelArtikel modelArtikelFromJson(String str) => ModelArtikel.fromJson(json.decode(str));

String modelArtikelToJson(ModelArtikel data) => json.encode(data.toJson());

class ModelArtikel {
    bool status;
    String remarks;
    List<ListDataArtikel> listData;

    ModelArtikel({
        this.status,
        this.remarks,
        this.listData,
    });

    factory ModelArtikel.fromJson(Map<String, dynamic> json) => ModelArtikel(
        status: json["status"],
        remarks: json["remarks"],
        listData: List<ListDataArtikel>.from(json["list_data"].map((x) => ListDataArtikel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
        "list_data": List<dynamic>.from(listData.map((x) => x.toJson())),
    };
}

class ListDataArtikel {
    String id;
    String judul;
    String tanggalpublis;
    String penulis;
    String isi;
    String gambar;
    String idkategori;
    String file;
    String tag;
    String status;
    String jenis;
    String viewer;
    String shared;
    String crearteddate;
    String creartedby;
    String creartedip;
    String modifieddate;
    String modifiedby;
    String modifiedip;
    String beritatop;
    String beritapenting;
    String kodedesa;

    ListDataArtikel({
        this.id,
        this.judul,
        this.tanggalpublis,
        this.penulis,
        this.isi,
        this.gambar,
        this.idkategori,
        this.file,
        this.tag,
        this.status,
        this.jenis,
        this.viewer,
        this.shared,
        this.crearteddate,
        this.creartedby,
        this.creartedip,
        this.modifieddate,
        this.modifiedby,
        this.modifiedip,
        this.beritatop,
        this.beritapenting,
        this.kodedesa,
    });

    factory ListDataArtikel.fromJson(Map<String, dynamic> json) => ListDataArtikel(
        id: json["id"],
        judul: json["judul"],
        tanggalpublis: json["tanggalpublis"],
        penulis: json["penulis"],
        isi: json["isi"],
        gambar: json["gambar"],
        idkategori: json["idkategori"],
        file: json["file"],
        tag: json["tag"],
        status: json["status"],
        jenis: json["jenis"],
        viewer: json["viewer"],
        shared: json["shared"],
        crearteddate: json["crearteddate"],
        creartedby: json["creartedby"],
        creartedip: json["creartedip"],
        modifieddate: json["modifieddate"],
        modifiedby: json["modifiedby"],
        modifiedip: json["modifiedip"],
        beritatop: json["beritatop"],
        beritapenting: json["beritapenting"],
        kodedesa: json["kodedesa"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "tanggalpublis": tanggalpublis,
        "penulis": penulis,
        "isi": isi,
        "gambar": gambar,
        "idkategori": idkategori,
        "file": file,
        "tag": tag,
        "status": status,
        "jenis": jenis,
        "viewer": viewer,
        "shared": shared,
        "crearteddate": crearteddate,
        "creartedby": creartedby,
        "creartedip": creartedip,
        "modifieddate": modifieddate,
        "modifiedby": modifiedby,
        "modifiedip": modifiedip,
        "beritatop": beritatop,
        "beritapenting": beritapenting,
        "kodedesa": kodedesa,
    };
}

class ModelAfterPost {
    bool status;
    String remarks;

    ModelAfterPost({
        this.status,
        this.remarks,
    });

    factory ModelAfterPost.fromJson(Map<String, dynamic> json) => ModelAfterPost(
        status: json["status"],
        remarks: json["remarks"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
    };
}
