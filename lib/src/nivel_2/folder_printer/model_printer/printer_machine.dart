// To parse this JSON data, do
//
//     final machinePrinter = machinePrinterFromJson(jsonString);

import 'dart:convert';

List<MachinePrinter> machinePrinterFromJson(String str) =>
    List<MachinePrinter>.from(
        json.decode(str).map((x) => MachinePrinter.fromJson(x)));

String machinePrinterToJson(List<MachinePrinter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MachinePrinter {
  String? id;
  String? idPrinterMachine;
  String? numberMachine;
  String? serial;
  String? modelo;
  String? tipo;
  String? fabricante;

  MachinePrinter({
    this.id,
    this.idPrinterMachine,
    this.numberMachine,
    this.serial,
    this.modelo,
    this.tipo,
    this.fabricante,
  });

  MachinePrinter copyWith({
    String? id,
    String? idMachine,
    String? numberMachine,
    String? serial,
    String? modelo,
    String? tipo,
    String? fabricante,
  }) =>
      MachinePrinter(
        id: id ?? this.id,
        idPrinterMachine: idMachine ?? this.idPrinterMachine,
        numberMachine: numberMachine ?? this.numberMachine,
        serial: serial ?? this.serial,
        modelo: modelo ?? this.modelo,
        tipo: tipo ?? this.tipo,
        fabricante: fabricante ?? this.fabricante,
      );

  factory MachinePrinter.fromJson(Map<String, dynamic> json) => MachinePrinter(
        id: json["id"],
        idPrinterMachine: json["id_machine"],
        numberMachine: json["number_machine"],
        serial: json["serial"],
        modelo: json["modelo"],
        tipo: json["tipo"],
        fabricante: json["fabricante"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_machine": idPrinterMachine,
        "number_machine": numberMachine,
        "serial": serial,
        "modelo": modelo,
        "tipo": tipo,
        "fabricante": fabricante,
      };
}
