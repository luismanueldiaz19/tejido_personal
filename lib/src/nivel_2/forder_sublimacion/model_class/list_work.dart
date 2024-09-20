// To parse this JSON data, do
//
//     final listWork = listWorkFromJson(jsonString);

import 'dart:convert';

List<ListWork> listWorkFromJson(String str) =>
    List<ListWork>.from(json.decode(str).map((x) => ListWork.fromJson(x)));

String listWorkToJson(List<ListWork> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListWork {
  String? id;
  String? code;
  String? occupation;
  String? numOrden;
  String? typeWork;
  String? dateStart;
  String? dateEnd;
  String? ordenstarted;
  String? ordenend;
  String? idDepart;
  String? nameDepartment;
  String? nivel;
  String? statu;
  String? ficha;
  String? cantPieza;
  String? cantOrden;
  String? nameLogo;
  String? idKeyWork;
  String? comment;
  String? fullName;
  String? nameWork;

  ListWork({
    this.id,
    this.code,
    this.occupation,
    this.numOrden,
    this.typeWork,
    this.dateStart,
    this.dateEnd,
    this.ordenstarted,
    this.ordenend,
    this.idDepart,
    this.nameDepartment,
    this.nivel,
    this.statu,
    this.ficha,
    this.cantPieza,
    this.cantOrden,
    this.nameLogo,
    this.idKeyWork,
    this.comment,
    this.fullName,
    this.nameWork,
  });

  factory ListWork.fromJson(Map<String, dynamic> json) => ListWork(
        id: json["id"],
        code: json["code"],
        occupation: json["occupation"],
        numOrden: json["num_orden"],
        typeWork: json["type_work"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        ordenstarted: json["ordenstarted"],
        ordenend: json["ordenend"],
        idDepart: json["id_depart"],
        nameDepartment: json["name_department"],
        nivel: json["nivel"],
        statu: json["statu"],
        ficha: json["ficha"],
        cantPieza: json["cant_pieza"],
        cantOrden: json["cant_orden"],
        nameLogo: json["name_logo"],
        idKeyWork: json["id_key_work"],
        comment: json["comment"],
        fullName: json["full_name"],
        nameWork: json["name_work"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "occupation": occupation,
        "num_orden": numOrden,
        "type_work": typeWork,
        "date_start": dateStart,
        "date_end": dateEnd,
        "ordenstarted": ordenstarted,
        "ordenend": ordenend,
        "id_depart": idDepart,
        "name_department": nameDepartment,
        "nivel": nivel,
        "statu": statu,
        "ficha": ficha,
        "cant_pieza": cantPieza,
        "cant_orden": cantOrden,
        "name_logo": nameLogo,
        "id_key_work": idKeyWork,
        "comment": comment,
        "full_name": fullName,
        "name_work": nameWork,
      };
}
