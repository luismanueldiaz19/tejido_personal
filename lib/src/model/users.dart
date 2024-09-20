import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  Users({
    this.id,
    this.fullName,
    this.occupation,
    this.created,
    this.turn,
    this.code,
    this.type,
    this.statu,
  });

  String? id;
  String? fullName;
  String? occupation;
  String? created;
  String? turn;
  String? code;
  String? type;
  String? statu;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        fullName: json["full_name"],
        occupation: json["occupation"],
        created: json["created"],
        turn: json["turn"],
        code: json["code"],
        type: json['type'],
        statu: json['statu'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "occupation": occupation,
        "created": created,
        "turn": turn,
        "code": code,
        "type": type,
        "statu": statu,
      };
}
