import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/detalles_card.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/model/incidencia.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class HomeIncidenciaPendientes extends StatefulWidget {
  const HomeIncidenciaPendientes({Key? key}) : super(key: key);

  @override
  State<HomeIncidenciaPendientes> createState() =>
      _HomeIncidenciaPendientesState();
}

class _HomeIncidenciaPendientesState extends State<HomeIncidenciaPendientes> {
  List<Incidencia> list = [];
  bool isFinished = false;
  @override
  void initState() {
    super.initState();

    getIncidencia();
  }

  Future getIncidencia() async {
    list.clear();

    final res = await httpRequestDatabase(
        selectReportIncidencia, {'is_finished': 'f'}); ////sin resolver////
    // print(res.body);

    /// ver todas la incidencia sin terminar
    list = incidenciaFromJson(res.body);

    if (list.isNotEmpty) {
      setState(() {});
    }
  }

  Future deleteFromIncidencia(id, imageKey) async {
    // print('ID : $id');
    var data = {
      'id': id,
      'id_key_image': imageKey,
    };
    // print(data);
    await httpRequestDatabase(deleteImageIncidencia, data);
    list.removeWhere((element) => element.id == id);

    setState(() {});
  }

  // bool isShow = false;
  //     const SizedBox(height: 15),
  //                 list.isNotEmpty
  //                     ? ElevatedButton.icon(
  //                         onPressed: () {
  //                           // Acción a realizar cuando se presiona el botón
  //                         },
  //                         icon: const Icon(Icons.print,
  //                             color: Colors.white), // Icono de impresión
  //                         label: const Text(
  //                           'Imprimir',
  //                           style: TextStyle(color: Colors.white),
  //                         ), // Texto del botón
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor:
  //                               colorsPuppleOpaco, // Color de fondo del botón
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 30.0,
  //                               vertical: 1.0), // Padding del botón
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(
  //                                 5.0), // Bordes redondeados del botón
  //                           ),
  //                         ),
  //                       )
  //                     : const SizedBox(),

  //  ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       isShow = !isShow;
  //                     });
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.black, // Color de fondo del botón
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 25.0, vertical: 5.0), // Padding del botón
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(
  //                           10.0), // Bordes redondeados del botón
  //                       side: const BorderSide(
  //                           color: Colors.black), // Borde del botón
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Mostrar Detalles Reporte',
  //                     style: TextStyle(
  //                         fontSize: 18.0,
  //                         fontWeight: FontWeight.bold,
  //                         letterSpacing: 2.0,
  //                         color: Colors.white),
  //                   ),
  //                 ),

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 20, left: 16),
          child: const BackButton(),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 20, right: 16),
          child: const Text('Departamento Incidencias Pendientes'),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          // listFilter.isNotEmpty
          //     ? Container(
          //         margin: const EdgeInsets.only(top: 25, right: 25),
          //         child: IconButton(
          //           icon: const Icon(Icons.print, color: Colors.black),
          //           onPressed: () async {
          //             final pdfFile = await PdfIncidenciaGeneral.generate(
          //                 listFilter, _firstDate, _secondDate);

          //             PdfApi.openFile(pdfFile);
          //           },
          //         ),
          //       )
          //     : const SizedBox(),
        ],
      ),
      body: Column(
        children: [
          list.isEmpty
              ? const Center(
                  child: SizedBox(
                    child: Text('No hay Incidencia'),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: DataTable(
                          dataRowMaxHeight: 20,
                          dataRowMinHeight: 15,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 205, 208, 221),
                                Color.fromARGB(255, 225, 228, 241),
                                Color.fromARGB(255, 233, 234, 238),
                              ],
                            ),
                          ),
                          border: TableBorder.symmetric(
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('num Orden')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('Ficha')),
                            DataColumn(label: Text('Motivo')),
                            DataColumn(label: Text('Resp. Depart')),
                            DataColumn(label: Text('Resp. Users')),
                            DataColumn(label: Text('Fecha')),
                          ],
                          rows: list
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(Text('${data.id}')),
                                    DataCell(Text('${data.depart}')),
                                    DataCell(Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => DetallesCard(
                                                      current: data),
                                                ),
                                              );
                                            },
                                            child: Text('${data.numOrden}')),
                                        const SizedBox(width: 10),
                                        currentUsers?.occupation.toString() ==
                                                    OptionAdmin.admin.name ||
                                                currentUsers?.occupation
                                                        .toString() ==
                                                    OptionAdmin.master.name
                                            ? IconButton(
                                                onPressed: () =>
                                                    deleteFromIncidencia(
                                                        data.id,
                                                        data.idKeyImage),
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 10,
                                                ))
                                            : const SizedBox(),
                                      ],
                                    )),
                                    DataCell(Text('${data.logo}')),
                                    DataCell(Text('${data.ficha}')),
                                    DataCell(Text('${data.whycause}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: fontTenali))),
                                    DataCell(Text('${data.departResponsed}')),
                                    DataCell(Text('${data.usersResponsed}')),
                                    DataCell(Text('${data.date}')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          const Text('Reportes Incidencia Pendientes',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0)),
          const SizedBox(height: 20),
          Expanded(child: IncidenciaTableUser(list: list)),
          const SizedBox(height: 20),
          Expanded(child: IncidenciaTable(list: list)),
        ],
      ),
    );
  }
}

class IncidenciaTable extends StatelessWidget {
  final List<Incidencia> list;

  const IncidenciaTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    Map<String, int> countMap = {};
    for (var incidencia in list) {
      if (countMap.containsKey(incidencia.depart)) {
        countMap[incidencia.depart ?? ''] = countMap[incidencia.depart]! + 1;
      } else {
        countMap[incidencia.depart ?? ''] = 1;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DataTable(
        dataRowMaxHeight: 20,
        dataRowMinHeight: 15,
        horizontalMargin: 10.0,
        columnSpacing: 15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 221, 216, 205),
              Color.fromARGB(255, 241, 236, 225),
              Color.fromARGB(255, 233, 234, 238),
            ],
          ),
        ),
        border: TableBorder.symmetric(
            inside:
                const BorderSide(style: BorderStyle.solid, color: Colors.grey)),
        columns: const [
          DataColumn(label: Text('Departamentos')),
          DataColumn(label: Text('Cantidad')),
        ],
        rows: countMap.entries
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.key)),
                  DataCell(Text('${e.value}')),
                ]))
            .toList(),
      ),
    );
  }
}

class IncidenciaTableUser extends StatelessWidget {
  final List<Incidencia> list;

  const IncidenciaTableUser({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, int> countMap = {};
    for (var incidencia in list) {
      if (countMap.containsKey(incidencia.usersResponsed ?? '')) {
        countMap[incidencia.usersResponsed ?? ''] =
            countMap[incidencia.usersResponsed ?? '']! + 1;
      } else {
        countMap[incidencia.usersResponsed ?? ''] = 1;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DataTable(
        dataRowMaxHeight: 20,
        dataRowMinHeight: 15,
        horizontalMargin: 10.0,
        columnSpacing: 15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 221, 205, 211),
              Color.fromARGB(255, 241, 225, 239),
              Color.fromARGB(255, 233, 234, 238),
            ],
          ),
        ),
        border: TableBorder.symmetric(
            inside:
                const BorderSide(style: BorderStyle.solid, color: Colors.grey)),
        columns: const [
          DataColumn(label: Text('Empleados')),
          DataColumn(label: Text('Cantidad')),
        ],
        rows: countMap.entries
            .map((e) => DataRow(cells: [
                  DataCell(
                      SizedBox(
                          width: 200,
                          child: Text(e.key,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis))),
                      onTap: () {
                    utilShowMesenger(context, e.key, title: 'Empleados');
                  }),
                  DataCell(Text(e.value.toString()))
                ]))
            .toList(),
      ),
    );
  }
}


// {"id":"33","depart":"Sublimacion","num_orden":"73481","logo":"fedofutbol","ficha":"175","whycause":"se dano por mala calidad","depart_responsed":"Sastreria","users_responsed":"AXEL ISMAEL","date":"2023-05-06"}



