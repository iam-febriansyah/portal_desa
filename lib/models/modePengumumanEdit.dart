// To parse this JSON data, do
//
//     final modelPengumumanEdit = modelPengumumanEditFromJson(jsonString);

import 'dart:convert';

ModelPengumumanEdit modelPengumumanEditFromJson(String str) => ModelPengumumanEdit.fromJson(json.decode(str));

String modelPengumumanEditToJson(ModelPengumumanEdit data) => json.encode(data.toJson());

class ModelPengumumanEdit {
    bool statusjson;
    String remarks;
    String id;
    String pengumuman;

    ModelPengumumanEdit({
        this.statusjson,
        this.remarks,
        this.id,
        this.pengumuman,
    });

    factory ModelPengumumanEdit.fromJson(Map<String, dynamic> json) => ModelPengumumanEdit(
        statusjson: json["statusjson"],
        remarks: json["remarks"],
        id: json["id"],
        pengumuman: json["pengumuman"],
    );

    Map<String, dynamic> toJson() => {
        "statusjson": statusjson,
        "remarks": remarks,
        "id": id,
        "pengumuman": pengumuman,
    };
}
