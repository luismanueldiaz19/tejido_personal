// To parse this JSON data, do
//
//     final planificacionItem = planificacionItemFromJson(jsonString);

import 'dart:convert';

List<PlanificacionItem> planificacionItemFromJson(String str) =>
    List<PlanificacionItem>.from(
        json.decode(str).map((x) => PlanificacionItem.fromJson(x)));

String planificacionItemToJson(List<PlanificacionItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanificacionItem {
  String? id;
  String? numOrden;
  String? nameLogo;
  String? ficha;
  String? isKeyUniqueProduct;
  String? tipoProduct;
  String? cant;
  String? department;
  String? fechaStart;
  String? fechaEnd;
  String? isDone;
  String? isCalidad;
  String? isWorking;
  String? statu;
  String? userDoneOrden;
  String? comment;

  PlanificacionItem(
      {this.id,
      this.numOrden,
      this.nameLogo,
      this.ficha,
      this.isKeyUniqueProduct,
      this.tipoProduct,
      this.cant,
      this.department,
      this.fechaStart,
      this.fechaEnd,
      this.isDone,
      this.isCalidad,
      this.isWorking,
      this.statu,
      this.userDoneOrden,
      this.comment});

  PlanificacionItem copyWith({
    String? id,
    String? numOrden,
    String? nameLogo,
    String? ficha,
    String? isKeyUniqueProduct,
    String? tipoProduct,
    String? cant,
    String? department,
    String? fechaStart,
    String? fechaEnd,
    String? isDone,
    String? isCalidad,
    String? isWorking,
    String? statu,
    String? userDoneOrden,
    String? comment,
  }) =>
      PlanificacionItem(
        id: id ?? this.id,
        numOrden: numOrden ?? this.numOrden,
        nameLogo: nameLogo ?? this.nameLogo,
        ficha: ficha ?? this.ficha,
        isKeyUniqueProduct: isKeyUniqueProduct ?? this.isKeyUniqueProduct,
        tipoProduct: tipoProduct ?? this.tipoProduct,
        cant: cant ?? this.cant,
        department: department ?? this.department,
        fechaStart: fechaStart ?? this.fechaStart,
        fechaEnd: fechaEnd ?? this.fechaEnd,
        isDone: isDone ?? this.isDone,
        isCalidad: isCalidad ?? this.isCalidad,
        isWorking: isWorking ?? this.isWorking,
        statu: statu ?? this.statu,
        userDoneOrden: userDoneOrden ?? this.userDoneOrden,
        comment: comment ?? this.comment,
      );

  factory PlanificacionItem.fromJson(Map<String, dynamic> json) =>
      PlanificacionItem(
        id: json["id"],
        numOrden: json["num_orden"],
        nameLogo: json["name_logo"],
        ficha: json["ficha"],
        isKeyUniqueProduct: json["is_key_unique_product"],
        tipoProduct: json["tipo_product"],
        cant: json["cant"],
        department: json["department"],
        fechaStart: json["fecha_start"],
        fechaEnd: json["fecha_end"],
        isDone: json["is_done"],
        isCalidad: json["is_calidad"],
        isWorking: json["is_working"],
        statu: json["statu"],
        userDoneOrden: json["user_done_orden"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num_orden": numOrden,
        "name_logo": nameLogo,
        "ficha": ficha,
        "is_key_unique_product": isKeyUniqueProduct,
        "tipo_product": tipoProduct,
        "cant": cant,
        "department": department,
        "fecha_start": fechaStart,
        "fecha_end": fechaEnd,
        "is_done": isDone,
        "is_calidad": isCalidad,
        "is_working": isWorking,
        "statu": statu,
        "user_done_orden": userDoneOrden,
        "comment": comment,
      };
}
