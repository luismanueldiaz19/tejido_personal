// To parse this JSON data, do
//
//     final forPaid = forPaidFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<ForPaid> forPaidFromJson(String str) =>
    List<ForPaid>.from(json.decode(str).map((x) => ForPaid.fromJson(x)));

String forPaidToJson(List<ForPaid> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForPaid {
  String? idPorPagarInter;
  String? fKeyInter;
  String? interFecha;
  String? interHora;
  String? interRegited;
  String? interComent;
  String? interStatu;
  String? idPorPagar;
  String? fDocumento;
  String? fNombre;
  String? fMonto;
  String? fBalance;
  String? fDireccion;
  String? fTelefono;
  String? numInter;
  String? statuPaid;
  String? aproved;
  String? fFechaVencimiento;
  String? fFecha;
  String? fecha;
  String? dias;

  ForPaid({
    this.idPorPagarInter,
    this.fKeyInter,
    this.interFecha,
    this.interHora,
    this.interRegited,
    this.interComent,
    this.interStatu,
    this.idPorPagar,
    this.fDocumento,
    this.fNombre,
    this.fMonto,
    this.fBalance,
    this.fDireccion,
    this.fTelefono,
    this.numInter,
    this.statuPaid,
    this.aproved,
    this.fFechaVencimiento,
    this.fFecha,
    this.fecha,
    this.dias,
  });

  factory ForPaid.fromJson(Map<String, dynamic> json) => ForPaid(
        idPorPagarInter: json["id_por_pagar_inter"],
        fKeyInter: json["f_key_inter"],
        interFecha: json["inter_fecha"],
        interHora: json["inter_hora"],
        interRegited: json["inter_regited"],
        interComent: json["inter_coment"],
        interStatu: json["inter_statu"],
        idPorPagar: json["id_por_pagar"],
        fDocumento: json["f_documento"],
        fNombre: json["f_nombre"],
        fMonto: json["f_monto"],
        fBalance: json["f_balance"],
        fDireccion: json["f_direccion"],
        fTelefono: json["f_telefono"],
        numInter: json["num_inter"],
        statuPaid: json["statu_paid"],
        aproved: json["aproved"],
        fFechaVencimiento: json["f_fecha_vencimiento"],
        fFecha: json["f_fecha"],
        fecha: json["fecha"],
        dias: json['dias'],
      );

  Map<String, dynamic> toJson() => {
        "id_por_pagar_inter": idPorPagarInter ?? '0',
        "f_key_inter": fKeyInter ?? '0',
        "inter_fecha": interFecha ?? '0',
        "inter_hora": interHora ?? '0',
        "inter_regited": interRegited ?? '0',
        "inter_coment": interComent ?? '0',
        "inter_statu": interStatu ?? '0',
        "id_por_pagar": idPorPagar ?? '0',
        "f_documento": fDocumento ?? '0',
        "f_nombre": fNombre ?? '0',
        "f_monto": fMonto ?? '0',
        "f_balance": fBalance ?? '0',
        "f_direccion": fDireccion ?? '0',
        "f_telefono": fTelefono ?? '0',
        "num_inter": numInter ?? '0',
        "statu_paid": statuPaid ?? '0',
        "aproved": aproved ?? '0',
        "f_fecha_vencimiento": fFechaVencimiento ?? '0',
        "f_fecha": fFecha ?? '0',
        "fecha": fecha ?? '0',
        "dias": dias ?? '0',
      };

  static String restaItem(ForPaid item) {
    String cleanMonto = item.fMonto!
        .replaceAll(RegExp(r'[a-zA-Z]'),
            '') // Reemplazar todas las letras por un String vacío
        .replaceAll('\$', '') // Eliminar el signo de dólar
        .replaceAll('-', '0');
    String cleanMontoBalance = item.fBalance!
        .replaceAll(RegExp(r'[a-zA-Z]'),
            '') // Reemplazar todas las letras por un String vacío
        .replaceAll('\$', '') // Eliminar el signo de dólar
        .replaceAll('-', '0');
    double num1 = double.parse(cleanMonto);
    double num2 = double.parse(cleanMontoBalance);
    double result = num1 - num2;
    return result.toStringAsFixed(0);
  }

  static String getTotalRestate(List<ForPaid> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(restaItem(element));
    }
    return value.toStringAsFixed(2);
  }

  static String getTotalBalance(List<ForPaid> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.fBalance ?? '0');
    }
    return value.toStringAsFixed(2);
  }

  static String getTotalMonto(List<ForPaid> collection) {
    double value = 0.0;
    for (var element in collection) {
      String cleanMonto = element.fMonto!
          .replaceAll(RegExp(r'[a-zA-Z]'),
              '') // Reemplazar todas las letras por un String vacío
          .replaceAll('\$', '') // Eliminar el signo de dólar
          .replaceAll('-', '0'); // Reemplazar los guiones por ceros

      value += double.parse(cleanMonto);
    }
    return value.toStringAsFixed(2);
  }

  static String getTotalVencidos(List<ForPaid> collection) {
    double value = 0.0;
    for (var element in collection) {
      if (element.statuPaid == 'f' &&
          int.parse(element.dias
                  .toString()
                  .replaceAll(',', '')
                  .replaceAll('.', '')) >
              30) {
        value++;
      }
    }
    return value.toStringAsFixed(2);
  }

  static Color getColorFromStatus(ForPaid status) {
    if (status.statuPaid == 'f' &&
        int.parse(status.dias
                .toString()
                .replaceAll(',', '')
                .replaceAll('.', '')) >
            30) {
      return Colors.red.shade100;
    }

    if (status.statuPaid == 't') {
      return Colors.green.shade100;
    }
    return Colors.white;
  }

  static String getPercent(String valor1, String valor2) {
    double num1 = double.parse(valor1);
    double num2 = double.parse(valor2);
    double percent = (num1 / num2) * 100;

    return percent.toStringAsFixed(2);
  }
}
