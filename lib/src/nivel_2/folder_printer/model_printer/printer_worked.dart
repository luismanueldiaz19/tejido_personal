// To parse this JSON data, do
//
//     final printerWorked = printerWorkedFromJson(jsonString);

import 'dart:convert';

List<PrinterWorked> printerWorkedFromJson(String str) =>
    List<PrinterWorked>.from(
        json.decode(str).map((x) => PrinterWorked.fromJson(x)));

String printerWorkedToJson(List<PrinterWorked> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrinterWorked {
  String? id;
  String? idPrinter;
  String? typePapel;
  String? dimecionCm;
  String? wasteCm;
  String? idWorked;

  PrinterWorked({
    this.id,
    this.idPrinter,
    this.typePapel,
    this.dimecionCm,
    this.wasteCm,
    this.idWorked,
  });

  PrinterWorked copyWith({
    String? id,
    String? idPrinter,
    String? typePapel,
    String? dimecionCm,
    String? wasteCm,
    String? idWorked,
  }) =>
      PrinterWorked(
        id: id ?? this.id,
        idPrinter: idPrinter ?? this.idPrinter,
        typePapel: typePapel ?? this.typePapel,
        dimecionCm: dimecionCm ?? this.dimecionCm,
        wasteCm: wasteCm ?? this.wasteCm,
        idWorked: idWorked ?? this.idWorked,
      );

  factory PrinterWorked.fromJson(Map<String, dynamic> json) => PrinterWorked(
        id: json["id"],
        idPrinter: json["id_printer"],
        typePapel: json["type_papel"],
        dimecionCm: json["dimecion_cm"],
        wasteCm: json["waste_cm"],
        idWorked: json["id_worked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_printer": idPrinter,
        "type_papel": typePapel,
        "dimecion_cm": dimecionCm,
        "waste_cm": wasteCm,
        "id_worked": idWorked,
      };
}
