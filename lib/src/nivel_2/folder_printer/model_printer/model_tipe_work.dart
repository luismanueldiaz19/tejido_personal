// To parse this JSON data, do
//
//     final typeWorkPrinter = typeWorkPrinterFromJson(jsonString);

import 'dart:convert';

List<TypeWorkPrinter> typeWorkPrinterFromJson(String str) =>
    List<TypeWorkPrinter>.from(
        json.decode(str).map((x) => TypeWorkPrinter.fromJson(x)));

String typeWorkPrinterToJson(List<TypeWorkPrinter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeWorkPrinter {
  String? id;
  String? tipeWorkPrinter;

  TypeWorkPrinter({
    this.id,
    this.tipeWorkPrinter,
  });

  TypeWorkPrinter copyWith({
    String? id,
    String? tipeWorkPrinter,
  }) =>
      TypeWorkPrinter(
        id: id ?? this.id,
        tipeWorkPrinter: tipeWorkPrinter ?? this.tipeWorkPrinter,
      );

  factory TypeWorkPrinter.fromJson(Map<String, dynamic> json) =>
      TypeWorkPrinter(
        id: json["id"],
        tipeWorkPrinter: json["tipe_work_printer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipe_work_printer": tipeWorkPrinter,
      };
}
