import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';

import '../../folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import '../model/cuentas_por_cobrar.dart';

class ProviderCuentasPorCobrar extends ChangeNotifier {
  List<CuentaPorCobrar> _storyListCuentaPorPagar = [];
  List<CuentaPorCobrar> _storyListCuentaPorPagarFilter = [];

  List<CuentaPorCobrar> get storyListCuentaPorPagar => _storyListCuentaPorPagar;
  List<CuentaPorCobrar> get storyListCuentaPorPagarFilter =>
      _storyListCuentaPorPagarFilter;

  List<CuentaPorCobrar> _listCuentaPorPagar = [];
  List<CuentaPorCobrar> _listCuentaPorPagarFilter = [];

  List<CuentaPorCobrar> get listCuentaPorPagar => _listCuentaPorPagar;
  List<CuentaPorCobrar> get listCuentaPorPagarFilter =>
      _listCuentaPorPagarFilter;

  Future getCuentasPorCobrar() async {
    //select_cuentas_por_cobrar
    debugPrint('Get Cuentas Por Cobrar ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_cuentas_por_cobrar.php";
    final res = await httpRequestDatabase(url, {'token': token});
    print(res.body);
    _listCuentaPorPagar = cuentaPorCobrarFromJson(res.body);
    _listCuentaPorPagarFilter = _listCuentaPorPagar;
    notifyListeners();
  }

  Future getStoryCuentasPorCobrar() async {
    // select_cuentas_por_cobrar
    // debugPrint('Get Story Cuentas Por Cobrar ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_cuentas_por_cobrar_story.php";
    final res = await httpRequestDatabase(url, {'token': token});
    // print(res.body);
    _storyListCuentaPorPagar = cuentaPorCobrarFromJson(res.body);
    _storyListCuentaPorPagarFilter = _storyListCuentaPorPagar;
    notifyListeners();
  }

  Future addCuentasPorCobrar(data) async {
    //insert_cuenta_por_cobrar
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_cuenta_por_cobrar.php";
    final res = await httpRequestDatabase(url, data);
    getCuentasPorCobrar();
    return res.body;
  }

  Future addPagosCuentasPorCobrar(data) async {
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_cuenta_por_cobrar_pagos.php";
    final res = await httpRequestDatabase(url, data);
    getCuentasPorCobrar();
    return res.body;
  }

  Future updateEstadoCuentasPorCobrar(data) async {
    String url =
        "http://$ipLocal/settingmat/admin/update/update_estado_cuentas_por_cobrar.php";
    final res = await httpRequestDatabase(url, data);
    getCuentasPorCobrar();
    return res.body;
  }

  seachingCuentas(String value) {
    if (value.isNotEmpty) {
      _listCuentaPorPagarFilter = _listCuentaPorPagar
          .where((element) =>
              element.nombre!.toUpperCase().contains(value.toUpperCase()) ||
              element.apellido!.toUpperCase().contains(value.toUpperCase()) ||
              element.estado!.toUpperCase().contains(value.toUpperCase()) ||
              element.telefono!.toUpperCase().contains(value.toUpperCase()))
          .toList();
      notifyListeners();
    } else {
      _listCuentaPorPagarFilter = _listCuentaPorPagar;
      notifyListeners();
    }
  }

  seachingItem(String value, bool isClient) {
    if (isClient) {
      _listCuentaPorPagarFilter = _listCuentaPorPagar
          .where(
              (element) => element.nombre!.toUpperCase() == value.toUpperCase())
          .toList();
      notifyListeners();
    } else {
      _listCuentaPorPagarFilter = _listCuentaPorPagar
          .where(
              (element) => element.estado!.toUpperCase() == value.toUpperCase())
          .toList();
      notifyListeners();
    }
  }

  normalizarList() {
    _listCuentaPorPagarFilter = _listCuentaPorPagar;
    notifyListeners();
  }

  seachingItemStory(String value) {
    _storyListCuentaPorPagarFilter = _storyListCuentaPorPagar
        .where(
            (element) => element.nombre!.toUpperCase() == value.toUpperCase())
        .toList();
    notifyListeners();
  }

  normalizarListStory() {
    _storyListCuentaPorPagarFilter = _storyListCuentaPorPagar;
    notifyListeners();
  }

  List<ForPaid> _listForPaid = [];
  List<ForPaid> _listForPaidFilter = [];

  List<ForPaid> get listForPaid => _listForPaid;
  List<ForPaid> get listForPaidFilter => _listForPaidFilter;

  Future getPorCobrar(date1, date2) async {
    //select_cuentas_por_cobrar
    debugPrint(
        'Get Cuentas Por Cobrar ..... Esperes ... Fecha : $date1 --- $date2');
    String url = "http://$ipLocal/settingmat/admin/select/select_por_pagar.php";
    final res =
        await httpRequestDatabase(url, {'date1': date1, 'date2': date2});
    // print(res.body);
    _listForPaid = forPaidFromJson(res.body);
    _listForPaidFilter =
        _listForPaid.where((element) => element.statuPaid == 'f').toList();
    notifyListeners();
  }

  Future deleteFrom(id, date1, date2) async {
    String url =
        "http://$ipLocal/settingmat/admin/delete/delete_por_cobrar.php";
    await httpRequestDatabase(url, {'id_por_pagar': id});
    getPorCobrar(date1, date2);
  }

  Future updateFrom(ForPaid item, date1, date2) async {
    //update_por_cobrar
    String url =
        "http://$ipLocal/settingmat/admin/update/update_por_cobrar.php";
    await httpRequestDatabase(url, item.toJson());

    getPorCobrar(date1, date2);
  }

  Future<String> insertSegumiento(ForPaid item, date1, date2) async {
    //update_por_cobrar
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_por_pagar_inter.php";
    final res = await httpRequestDatabase(url, item.toJson());

    getPorCobrar(date1, date2);
    return res.body.toString();
  }

  ///insert_por_pagar_inter

  normalizarFoPaid() {
    _listForPaidFilter =
        _listForPaid.where((element) => element.statuPaid == 'f').toList();
    notifyListeners();
  }

  serachingPagado() {
    _listForPaidFilter =
        _listForPaid.where((element) => element.statuPaid == 't').toList();
    notifyListeners();
  }

  serachingList(String value) {
    // print(val);
    if (value.isNotEmpty) {
      _listForPaidFilter = List.from(_listForPaid
          .where((x) =>
              x.fDireccion!.toUpperCase().contains(value.toUpperCase()) ||
              x.fNombre!.toUpperCase().contains(value.toUpperCase()) ||
              x.fTelefono!.toUpperCase().contains(value.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _listForPaidFilter =
          _listForPaid.where((element) => element.statuPaid == 'f').toList();
      notifyListeners();
    }
  }

  serachingListByClient(String value) {
    _listForPaidFilter = List.from(_listForPaid
        .where((x) => x.fNombre!.toUpperCase().contains(value.toUpperCase()))
        .toList());
    notifyListeners();
  }

// select_por_pagar
}
