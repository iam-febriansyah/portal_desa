// To parse this JSON data, do
//
//     final modelHome = modelHomeFromJson(jsonString);

import 'dart:convert';

ModelHome modelHomeFromJson(String str) => ModelHome.fromJson(json.decode(str));

String modelHomeToJson(ModelHome data) => json.encode(data.toJson());

class ModelHome {
    bool status;
    String remarks;
    List<ListBerita> listBerita;
    List<ListGaleri> listGaleri;
    List<ListPengumuman> listPengumuman;

    ModelHome({
        this.status,
        this.remarks,
        this.listBerita,
        this.listGaleri,
        this.listPengumuman,
    });

    factory ModelHome.fromJson(Map<String, dynamic> json) => ModelHome(
        status: json["status"],
        remarks: json["remarks"],
        listBerita: List<ListBerita>.from(json["list_berita"].map((x) => ListBerita.fromJson(x))),
        listGaleri: List<ListGaleri>.from(json["list_galeri"].map((x) => ListGaleri.fromJson(x))),
        listPengumuman: List<ListPengumuman>.from(json["list_pengumuman"].map((x) => ListPengumuman.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
        "list_berita": List<dynamic>.from(listBerita.map((x) => x.toJson())),
        "list_galeri": List<dynamic>.from(listGaleri.map((x) => x.toJson())),
        "list_pengumuman": List<dynamic>.from(listPengumuman.map((x) => x.toJson())),
    };
}

class ListBerita {
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

    ListBerita({
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

    factory ListBerita.fromJson(Map<String, dynamic> json) => ListBerita(
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

class ListGaleri {
    String id;
    String judul;
    String keterangan;
    String gambar;
    String jenis;
    String idkategori;
    String kodedesa;

    ListGaleri({
        this.id,
        this.judul,
        this.keterangan,
        this.gambar,
        this.jenis,
        this.idkategori,
        this.kodedesa,
    });

    factory ListGaleri.fromJson(Map<String, dynamic> json) => ListGaleri(
        id: json["id"],
        judul: json["judul"],
        keterangan: json["keterangan"],
        gambar: json["gambar"],
        jenis: json["jenis"],
        idkategori: json["idkategori"],
        kodedesa: json["kodedesa"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "keterangan": keterangan,
        "gambar": gambar,
        "jenis": jenis,
        "idkategori": idkategori,
        "kodedesa": kodedesa,
    };
}

class ListPengumuman {
    String id;
    String pengumuman;
    String createddate;
    String statusbroadcast;
    String tanggalbroadcast;
    String kodedesa;

    ListPengumuman({
        this.id,
        this.pengumuman,
        this.createddate,
        this.statusbroadcast,
        this.tanggalbroadcast,
        this.kodedesa,
    });

    factory ListPengumuman.fromJson(Map<String, dynamic> json) => ListPengumuman(
        id: json["id"],
        pengumuman: json["pengumuman"],
        createddate: json["createddate"],
        statusbroadcast: json["statusbroadcast"],
        tanggalbroadcast: json["tanggalbroadcast"],
        kodedesa: json["kodedesa"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pengumuman": pengumuman,
        "createddate": createddate,
        "statusbroadcast": statusbroadcast,
        "tanggalbroadcast": tanggalbroadcast,
        "kodedesa": kodedesa,
    };
}
