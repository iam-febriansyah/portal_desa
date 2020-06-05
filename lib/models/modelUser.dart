// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(String str) => UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
    bool statusJson;
    String remarks;
    String id;
    String username;
    String password;
    String level;
    String status;
    String foto;

    UserDetail({
        this.statusJson,
        this.remarks,
        this.id,
        this.username,
        this.password,
        this.status,
        this.level,
        this.foto,
    });

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        statusJson: json["statusJson"],
        remarks: json["remarks"],
        id: json["id"],
        username: json["username"],
        password: json["password"],
        status: json["status"],
        level: json["level"],
        foto: json["foto"],
    );

    Map<String, dynamic> toJson() => {
        "statusJson": statusJson,
        "remarks": remarks,
        "id": id,
        "username": username,
        "password": password,
        "status": status,
        "level": level,
        "foto": foto,
    };
}
