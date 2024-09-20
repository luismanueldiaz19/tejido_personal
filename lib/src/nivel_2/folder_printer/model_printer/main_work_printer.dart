// To parse this JSON data, do
//
//     final mainWorkPrint = mainWorkPrintFromJson(jsonString);

import 'dart:convert';

List<MainWorkPrint> mainWorkPrintFromJson(String str) =>
    List<MainWorkPrint>.from(
        json.decode(str).map((x) => MainWorkPrint.fromJson(x)));

String mainWorkPrintToJson(List<MainWorkPrint> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainWorkPrint {
  String? id;
  String? idMachine;
  String? idWorkPrinter;
  String? numberMachine;
  String? serial;
  String? modelo;
  String? tipo;
  String? fabricante;
  String? dimensionCm;
  String? wasteDimensionCm;
  String? isFinished;

  MainWorkPrint({
    this.id,
    this.idMachine,
    this.idWorkPrinter,
    this.numberMachine,
    this.serial,
    this.modelo,
    this.tipo,
    this.fabricante,
    this.dimensionCm,
    this.wasteDimensionCm,
    this.isFinished,
  });

  MainWorkPrint copyWith({
    String? id,
    String? idMachine,
    String? idWorkPrinter,
    String? numberMachine,
    String? serial,
    String? modelo,
    String? tipo,
    String? fabricante,
    String? dimensionCm,
    String? wasteDimensionCm,
    String? isFinished,
  }) =>
      MainWorkPrint(
        id: id ?? this.id,
        idMachine: idMachine ?? this.idMachine,
        idWorkPrinter: idWorkPrinter ?? this.idWorkPrinter,
        numberMachine: numberMachine ?? this.numberMachine,
        serial: serial ?? this.serial,
        modelo: modelo ?? this.modelo,
        tipo: tipo ?? this.tipo,
        fabricante: fabricante ?? this.fabricante,
        dimensionCm: dimensionCm ?? this.dimensionCm,
        wasteDimensionCm: wasteDimensionCm ?? this.wasteDimensionCm,
        isFinished: isFinished ?? this.isFinished,
      );

  factory MainWorkPrint.fromJson(Map<String, dynamic> json) => MainWorkPrint(
        id: json["id"],
        idMachine: json["id_machine"],
        idWorkPrinter: json["id_work_printer"],
        numberMachine: json["number_machine"],
        serial: json["serial"],
        modelo: json["modelo"],
        tipo: json["tipo"],
        fabricante: json["fabricante"],
        dimensionCm: json["dimension_cm"],
        wasteDimensionCm: json["waste_dimension_cm"],
        isFinished: json["is_finished"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_machine": idMachine,
        "id_work_printer": idWorkPrinter,
        "number_machine": numberMachine,
        "serial": serial,
        "modelo": modelo,
        "tipo": tipo,
        "fabricante": fabricante,
        "dimension_cm": dimensionCm,
        "waste_dimension_cm": wasteDimensionCm,
        "is_finished": isFinished,
      };
}
