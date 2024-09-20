import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cliente_company/add_cliente.dart';
import 'package:tejidos/src/folder_cliente_company/detalles_cliente.dart';
import 'package:tejidos/src/folder_cliente_company/provider_clientes/provider_clientes.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

class ScreenClientes extends StatefulWidget {
  const ScreenClientes({super.key});

  @override
  State<ScreenClientes> createState() => _ScreenClientesState();
}

class _ScreenClientesState extends State<ScreenClientes> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClienteProvider>(context, listen: false).getCliente();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes $nameApp'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (conext) => const AddClientForm(),
                    ),
                  );
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Consumer<ClienteProvider>(
            builder: (context, provier, child) {
              if (provier.listClientsFilter.isEmpty) {
                return const Text('No hay Clientes');
              }
              return Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      dataRowMaxHeight: 20,
                      dataRowMinHeight: 10,
                      horizontalMargin: 10.0,
                      columnSpacing: 15,
                      headingRowHeight: 20,
                      dataTextStyle: style.bodySmall,
                      headingTextStyle:
                          style.labelSmall?.copyWith(color: Colors.white),
                      headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => colorsOrange),
                      border: TableBorder.symmetric(
                          outside: BorderSide(
                              color: Colors.grey.shade100,
                              style: BorderStyle.none)),
                      columns: const [
                        DataColumn(label: Text('ACTION')),
                        DataColumn(label: Text('#ID')),
                        DataColumn(label: Text('NOMBRES')),
                        DataColumn(label: Text('APELLIDOS')),
                        DataColumn(label: Text('DIRECCIONES')),
                        DataColumn(label: Text('TELEFONOS')),
                        DataColumn(label: Text('INFORMACIONES')),
                      ],
                      rows: provier.listClientsFilter
                          .map((item) => DataRow(cells: [
                                DataCell(
                                    const Text('Click !',
                                        style: TextStyle(color: Colors.blue)),
                                    onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetallesCliente(item: item)),
                                  );
                                }),
                                DataCell(Text(item.idCliente ?? 'N/A')),
                                DataCell(Text(item.nombre ?? 'N/A')),
                                DataCell(Text(item.apellido ?? 'N/A')),
                                DataCell(Text(item.direccion ?? 'N/A')),
                                DataCell(Text(item.telefono ?? 'N/A')),
                                DataCell(Text(item.correoElectronico ?? 'N/A')),
                              ]))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          identy(context)
        ],
      ),
    );
  }
}
