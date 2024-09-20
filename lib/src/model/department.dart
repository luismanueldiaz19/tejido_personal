// To parse this JSON data, do
//
//     final department = departmentFromJson(jsonString);

import 'dart:convert';

List<Department> departmentFromJson(String str) =>
    List<Department>.from(json.decode(str).map((x) => Department.fromJson(x)));

String departmentToJson(List<Department> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Department {
  Department({
    this.id,
    this.nameDepartment,
    this.date,
    this.statu,
    this.nivel,
    this.nameNivel,
    this.idKeyWork,
    this.type,
  });

  String? id;
  String? nameDepartment;
  String? date;
  String? statu;
  String? nivel;
  String? nameNivel;
  String? idKeyWork;
  String? type;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        nameDepartment: json["name_department"],
        date: json["date"],
        statu: json["statu"],
        nivel: json["nivel"],
        nameNivel: json["name_nivel"],
        idKeyWork: json['id_key_work'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_department": nameDepartment,
        "date": date,
        "statu": statu,
        "nivel": nivel,
        "name_nivel": nameNivel,
        "id_key_work": idKeyWork,
        "type": type,
      };
}
