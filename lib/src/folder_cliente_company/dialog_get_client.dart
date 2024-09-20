import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/folder_cliente_company/model_cliente/cliente.dart';

class DialogGetClients extends StatefulWidget {
  const DialogGetClients({super.key});

  @override
  State<DialogGetClients> createState() => _DialogGetClientsState();
}

class _DialogGetClientsState extends State<DialogGetClients> {
  List<Cliente> listClients = [];
  List<Cliente> listClientsFilter = [];

  Cliente? entregadorCurrent;

  Future getClient() async {
    String url = "http://$ipLocal/settingmat/admin/select/select_clientes.php";
    final res = await httpRequestDatabase(url, {'token': token});
    listClients = clienteFromJson(res.body);
    listClientsFilter = listClients;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getClient();
  }

  _seachingItem(String value) {
    if (value.isNotEmpty) {
      setState(() {
        listClientsFilter = listClients
            .where((element) =>
                element.nombre!.toUpperCase().contains(value.toUpperCase()))
            .toList();
      });
    } else {
      setState(() {
        listClientsFilter = listClients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Text('Elegir el Cliente', style: style.bodyMedium),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, entregadorCurrent);
            },
            child: const Text('Elegir'))
      ],
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          children: [
            Container(
              color: Colors.white54,
              height: 50,
              width: 200,
              child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _seachingItem(val),
                  decoration: const InputDecoration(
                      hintText: 'Buscar Cliente',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0))),
            ),
            const SizedBox(height: 10),
            listClientsFilter.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: 200,
                    child: ListView.builder(
                      itemCount: listClientsFilter.length,
                      itemBuilder: (context, index) {
                        Cliente item = listClientsFilter[index];
                        return Container(
                          color: entregadorCurrent == item
                              ? Colors.blue.shade100
                              : Colors.white,
                          width: 200,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                entregadorCurrent = item;
                              });
                            },
                            child: Text(
                                '${item.nombre ?? 'N/A'} ${item.apellido ?? 'N/A'}',
                                style: style.labelSmall),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text('No Hay Data'))
          ],
        ),
      ),
    );
  }
}
