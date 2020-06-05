// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
    bool statusJson;
    String remarks;
    String id;
    String username;
    String password;
    String level;
    String status;
    String foto;
    String kodedesa;
    String date;
    String ip;

    ModelLogin({
        this.statusJson,
        this.remarks,
        this.id,
        this.username,
        this.password,
        this.level,
        this.status,
        this.foto,
        this.kodedesa,
        this.date,
        this.ip,
    });

    factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        statusJson: json["status_json"],
        remarks: json["remarks"],
        id: json["id"],
        username: json["username"],
        password: json["password"],
        level: json["level"],
        status: json["status"],
        foto: json["foto"],
        kodedesa: json["kodedesa"],
        date: json["date"],
        ip: json["ip"],
    );

    Map<String, dynamic> toJson() => {
        "status_json": statusJson,
        "remarks": remarks,
        "id": id,
        "username": username,
        "password": password,
        "level": level,
        "status": status,
        "foto": foto,
        "kodedesa": kodedesa,
        "date": date,
        "ip": ip,
    };
}
