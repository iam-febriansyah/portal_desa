// To parse this JSON data, do
//
//     final modelPengumuman = modelPengumumanFromJson(jsonString);

import 'dart:convert';

ModelPengumuman modelPengumumanFromJson(String str) => ModelPengumuman.fromJson(json.decode(str));

String modelPengumumanToJson(ModelPengumuman data) => json.encode(data.toJson());

class ModelPengumuman {
    bool status;
    String remarks;
    List<ListDataPengumuman> listData;

    ModelPengumuman({
        this.status,
        this.remarks,
        this.listData,
    });

    factory ModelPengumuman.fromJson(Map<String, dynamic> json) => ModelPengumuman(
        status: json["status"],
        remarks: json["remarks"],
        listData: List<ListDataPengumuman>.from(json["list_pengumuman"].map((x) => ListDataPengumuman.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
        "list_pengumuman": List<dynamic>.from(listData.map((x) => x.toJson())),
    };
}

class ListDataPengumuman {
    String id;
    String pengumuman;
    String createddate;
    String statusbroadcast;
    String tanggalbroadcast;
    String kodedesa;

    ListDataPengumuman({
        this.id,
        this.pengumuman,
        this.createddate,
        this.statusbroadcast,
        this.tanggalbroadcast,
        this.kodedesa,
    });

    factory ListDataPengumuman.fromJson(Map<String, dynamic> json) => ListDataPengumuman(
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
