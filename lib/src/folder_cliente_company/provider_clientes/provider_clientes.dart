import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';

import '../model_cliente/cliente.dart';

class ClienteProvider extends ChangeNotifier {
  List<Cliente> _listClients = [];
  List<Cliente> _listClientsFilter = [];

  List<Cliente> get listClients => _listClients;
  List<Cliente> get listClientsFilter => _listClientsFilter;

// List<Cliente> clienteFromJson(

  Future getCliente() async {
    debugPrint('Get Cliente ..... Esperes ...');
    String url = "http://$ipLocal/settingmat/admin/select/select_clientes.php";
    final res = await httpRequestDatabase(url, {'token': token});
    _listClients = clienteFromJson(res.body);
    _listClientsFilter = _listClients;
    notifyListeners();
  }

  Future<String> deleteCliente(data) async {
    String url = "http://$ipLocal/settingmat/admin/delete/delete_client.php";
    final res = await httpRequestDatabase(url, data);
    getCliente();
    return res.body;
  }

  Future<String> updateMethodCliente(data) async {
    String url = "http://$ipLocal/settingmat/admin/update/update_cliente.php";
    final res = await httpRequestDatabase(url, data);
    getCliente();
    return res.body;
  }

  Future<String> addNewClient(data) async {
    String url = "http://$ipLocal/settingmat/admin/insert/insert_clientes.php";
    final res = await httpRequestDatabase(url, data);
    getCliente();
    return res.body;
  }
}
