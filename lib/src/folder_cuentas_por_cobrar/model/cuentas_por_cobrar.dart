// To parse this JSON data, do
//
//     final cuentaPorCobrar = cuentaPorCobrarFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<CuentaPorCobrar> cuentaPorCobrarFromJson(String str) =>
    List<CuentaPorCobrar>.from(
        json.decode(str).map((x) => CuentaPorCobrar.fromJson(x)));

String cuentaPorCobrarToJson(List<CuentaPorCobrar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CuentaPorCobrar {
  String? id;
  String? idCliente;
  String? numOrden;
  String? montoPendiente;
  String? fechaVencimiento;
  String? estado;
  String? nombre;
  String? apellido;
  String? direccion;
  String? telefono;
  String? correoElectronico;
  String? totalMontoPagado;
  String? cuentaPorCobrarId;
  String? fechaPago;
  String? montoPagado;
  String? usuario;
  String? nota;

  CuentaPorCobrar(
      {this.id,
      this.idCliente,
      this.numOrden,
      this.montoPendiente,
      this.fechaVencimiento,
      this.estado,
      this.nombre,
      this.apellido,
      this.direccion,
      this.telefono,
      this.correoElectronico,
      this.totalMontoPagado,
      this.cuentaPorCobrarId,
      this.fechaPago,
      this.montoPagado,
      this.usuario,
      this.nota});

  factory CuentaPorCobrar.fromJson(Map<String, dynamic> json) =>
      CuentaPorCobrar(
        id: json["id"] ?? 'N/A',
        idCliente: json["id_cliente"] ?? '0',
        numOrden: json["num_orden"] ?? 'N/A',
        montoPendiente: json["monto_pendiente"] ?? '0',
        fechaVencimiento: json["fecha_vencimiento"] ?? 'N/A',
        estado: json["estado"] ?? 'N/A',
        nombre: json["nombre"] ?? 'N/A',
        apellido: json["apellido"] ?? 'N/A',
        direccion: json["direccion"] ?? 'N/A',
        telefono: json["telefono"] ?? 'N/A',
        correoElectronico: json["correo_electronico"] ?? 'N/A',
        totalMontoPagado: json["total_monto_pagado"] ?? '0',
        cuentaPorCobrarId: json["cuenta_por_cobrar_id"],
        fechaPago: json["fecha_pago"] ?? 'N/A',
        montoPagado: json["monto_pagado"] ?? '0',
        usuario: json["usuario"] ?? 'N/A',
        nota: json["nota"] ?? 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? '0',
        "id_cliente": idCliente ?? '0',
        "num_orden": numOrden ?? 'N/A',
        "monto_pendiente": montoPendiente ?? '0',
        "fecha_vencimiento": fechaVencimiento ?? 'N/A',
        "estado": estado ?? 'N/A',
        "nombre": nombre ?? 'N/A',
        "apellido": apellido ?? 'N/A',
        "direccion": direccion ?? 'N/A',
        "telefono": telefono ?? 'N/A',
        "correo_electronico": correoElectronico ?? 'N/A',
        "total_monto_pagado": totalMontoPagado ?? '0',
        "cuenta_por_cobrar_id": cuentaPorCobrarId ?? '0',
        "fecha_pago": fechaPago ?? '0',
        "monto_pagado": montoPagado ?? '0',
        "usuario": usuario ?? 'N/A',
        "nota": nota ?? 'N/A',
      };

  static String getRestante(CuentaPorCobrar item) {
    double restante = double.parse(item.montoPendiente ?? '0');
    double pagado = double.parse(item.totalMontoPagado ?? '0');
    double result = restante - pagado;
    return result.toStringAsFixed(2);
  }

  static String getTotalPendiente(List<CuentaPorCobrar> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.montoPendiente ?? '0');
    }
    return value.toStringAsFixed(2);
  }

  static String getRestar(String val, String val2) {
    double value = double.parse(val) - double.parse(val2);

    return value.toStringAsFixed(2);
  }

  static String getTotalPagado(List<CuentaPorCobrar> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.totalMontoPagado ?? '0');
    }
    return value.toStringAsFixed(2);
  }

  static String getMontoPagadoItem(List<CuentaPorCobrar> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.montoPagado ?? '0');
    }
    return value.toStringAsFixed(2);
  }

  static Color getColorFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Colors.transparent;
      case 'pendiente':
        return Colors.transparent;
      case 'pagado':
        return Colors.transparent;
      case 'vencida':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade50;
    }
  }

  static bool getValidaBalance(CuentaPorCobrar item) {
    double value = double.parse(item.montoPendiente ?? '0');
    double value2 = double.parse(item.totalMontoPagado ?? '0');
    print('este es Menor ${value2} A $value');
    print(value2 >= value);
    return value2 >= value;
  }
}
