// To parse this JSON data, do
//
//     final detailPrinterOrden = detailPrinterOrdenFromJson(jsonString);

import 'dart:convert';

List<DetailPrinterOrden> detailPrinterOrdenFromJson(String str) =>
    List<DetailPrinterOrden>.from(
        json.decode(str).map((x) => DetailPrinterOrden.fromJson(x)));

String detailPrinterOrdenToJson(List<DetailPrinterOrden> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailPrinterOrden {
  String? id;
  String? idMachine;
  String? numberMachine;
  String? serial;
  String? modelo;
  String? tipo;
  String? fabricante;
  String? dimensionCm;
  String? wasteDimensionCm;
  String? isFinished;
  String? userRegisted;
  String? idWorkPrinter;
  String? idTypeWork;
  String? tipeWorkPrinter;
  String? ficha;
  String? logo;
  String? numOrden;
  String? date;
  String? dateStart;
  String? dateEnd;
  String? pFull;
  String? pkt;
  String? cantImpr;
  String? comment;

  DetailPrinterOrden({
    this.id,
    this.idMachine,
    this.numberMachine,
    this.serial,
    this.modelo,
    this.tipo,
    this.fabricante,
    this.dimensionCm,
    this.wasteDimensionCm,
    this.isFinished,
    this.userRegisted,
    this.idWorkPrinter,
    this.idTypeWork,
    this.tipeWorkPrinter,
    this.ficha,
    this.logo,
    this.numOrden,
    this.date,
    this.dateStart,
    this.dateEnd,
    this.pFull,
    this.pkt,
    this.cantImpr,
    this.comment,
  });

  DetailPrinterOrden copyWith({
    String? id,
    String? idMachine,
    String? numberMachine,
    String? serial,
    String? modelo,
    String? tipo,
    String? fabricante,
    String? dimensionCm,
    String? wasteDimensionCm,
    String? isFinished,
    String? userRegisted,
    String? idWorkPrinter,
    String? idTypeWork,
    String? tipeWorkPrinter,
    String? ficha,
    String? logo,
    String? numOrden,
    String? date,
    String? dateStart,
    String? dateEnd,
    String? pFull,
    String? pkt,
    String? cantImpr,
    String? comment,
  }) =>
      DetailPrinterOrden(
        id: id ?? this.id,
        idMachine: idMachine ?? this.idMachine,
        numberMachine: numberMachine ?? this.numberMachine,
        serial: serial ?? this.serial,
        modelo: modelo ?? this.modelo,
        tipo: tipo ?? this.tipo,
        fabricante: fabricante ?? this.fabricante,
        dimensionCm: dimensionCm ?? this.dimensionCm,
        wasteDimensionCm: wasteDimensionCm ?? this.wasteDimensionCm,
        isFinished: isFinished ?? this.isFinished,
        userRegisted: userRegisted ?? this.userRegisted,
        idWorkPrinter: idWorkPrinter ?? this.idWorkPrinter,
        idTypeWork: idTypeWork ?? this.idTypeWork,
        tipeWorkPrinter: tipeWorkPrinter ?? this.tipeWorkPrinter,
        ficha: ficha ?? this.ficha,
        logo: logo ?? this.logo,
        numOrden: numOrden ?? this.numOrden,
        date: date ?? this.date,
        dateStart: dateStart ?? this.dateStart,
        dateEnd: dateEnd ?? this.dateEnd,
        pFull: pFull ?? this.pFull,
        pkt: pkt ?? this.pkt,
        cantImpr: cantImpr ?? this.cantImpr,
        comment: comment ?? this.comment,
      );

  factory DetailPrinterOrden.fromJson(Map<String, dynamic> json) =>
      DetailPrinterOrden(
        id: json["id"],
        idMachine: json["id_machine"],
        numberMachine: json["number_machine"],
        serial: json["serial"],
        modelo: json["modelo"],
        tipo: json["tipo"],
        fabricante: json["fabricante"],
        dimensionCm: json["dimension_cm"],
        wasteDimensionCm: json["waste_dimension_cm"],
        isFinished: json["is_finished"],
        userRegisted: json["user_registed"],
        idWorkPrinter: json["id_work_printer"],
        idTypeWork: json["id_type_work"],
        tipeWorkPrinter: json["tipe_work_printer"],
        ficha: json["ficha"],
        logo: json["logo"],
        numOrden: json["num_orden"],
        date: json["date"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        pFull: json["p_full"],
        pkt: json["pkt"],
        cantImpr: json["cant_impr"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_machine": idMachine,
        "number_machine": numberMachine,
        "serial": serial,
        "modelo": modelo,
        "tipo": tipo,
        "fabricante": fabricante,
        "dimension_cm": dimensionCm,
        "waste_dimension_cm": wasteDimensionCm,
        "is_finished": isFinished,
        "user_registed": userRegisted,
        "id_work_printer": idWorkPrinter,
        "id_type_work": idTypeWork,
        "tipe_work_printer": tipeWorkPrinter,
        "ficha": ficha,
        "logo": logo,
        "num_orden": numOrden,
        "date": date,
        "date_start": dateStart,
        "date_end": dateEnd,
        "p_full": pFull,
        "pkt": pkt,
        "cant_impr": cantImpr,
        "comment": comment,
      };
}
