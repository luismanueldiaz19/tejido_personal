import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/folder_record_sublima/card_sublimacion_historial.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/screen_report_master/screen_report_master_admin.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

import '../../util/dialog_confimarcion.dart';

class SublimacionRecord extends StatefulWidget {
  const SublimacionRecord({Key? key, required this.current}) : super(key: key);
  final Department current;

  @override
  State<SublimacionRecord> createState() => _SublimacionRecordState();
}

class _SublimacionRecordState extends State<SublimacionRecord> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  bool isCombine = false;
  List<Sublima> listFilter = [];
  List<Sublima> list = [];
  String typeTrabajo = '';
  String usuario = '';

  @override
  void initState() {
    super.initState();
    getWork(_firstDate, _secondDate);
  }

  Future getWork(date1, date2) async {
    final res = await httpRequestDatabase(selectSublimacionWorkFinishedbydate,
        {'id_depart': widget.current.id, 'date1': date1, 'date2': date2});
    list = sublimaFromJson(res.body);
    listFilter = [...list];
    setState(() {});
  }

  Future deleteFromSublima(id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌❌Esta Seguro de Eliminar❌❌',
          titulo: 'Aviso',
          onConfirmar: () async {
            Navigator.of(context).pop();
            await httpRequestDatabase(
                deleteSublimacionWorkFinished, {'id': id});
            getWork(_firstDate, _secondDate);
          },
        );
      },
    );
  }

  tomarUsuariosList(List<Sublima> itemList) {
    List<Sublima> users = [...itemList];
    List<String> uniqueNames =
        users.toSet().map((user) => user.fullName ?? 'N/A').toList();
    List<String> nombres = uniqueNames.toSet().toList();
    return nombres;
  }

  tomarTrabajosList(List<Sublima> itemList) {
    List<Sublima> users = [...itemList];
    List<String> uniqueNames =
        users.toSet().map((user) => user.nameWork ?? 'N/A').toList();
    List<String> nombresUnicos = uniqueNames.toSet().toList();
    return nombresUnicos;
  }

  Future searchingEmploye(String? empleado) async {
    setState(() {
      listFilter = List.from(list
          .where((x) => x.fullName!
              .toUpperCase()
              .contains(empleado.toString().toUpperCase()))
          .toList());
    });
  }

  Future searchingTypeWork(String? type) async {
    setState(() {
      listFilter = List.from(list
          .where((x) =>
              x.nameWork!.toUpperCase().contains(type.toString().toUpperCase()))
          .toList());
    });
  }

  String getTotalPieza(List<Sublima> listFilterLocal) {
    int totalPieza = 0;
    for (var item in listFilterLocal) {
      totalPieza += int.parse(item.cantPieza ?? '0');
    }
    return '$totalPieza';
  }

  Future searchingCombine() async {
    listFilter = List.from(list
        .where((x) =>
            x.fullName!.toUpperCase() == usuario.toString().toUpperCase() &&
            x.nameWork!.toUpperCase() == typeTrabajo.toString().toUpperCase())
        .toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final styte = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial trabajos'),
        backgroundColor: const Color.fromARGB(255, 233, 234, 238),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 35, right: 10),
            child: Row(
              children: [
                const Text('COMBINAR'),
                Checkbox(
                  value: isCombine,
                  onChanged: (val) {
                    setState(() {
                      isCombine = !isCombine;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25, right: 10),
            child: IconButton(
              icon: const Icon(Icons.help),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenReportMaster(
                            list: listFilter, isReport: true)));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25, right: 10),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listFilter.isNotEmpty) {
                  // final pdfFile =
                  //     await PdfInventarioGeneral.generate(listInventarioFilter);

                  // PdfApi.openFile(pdfFile);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    _firstDate = dateee.toString();
                    // print(_firstDate);
                    setState(() {});
                  },
                  child: Text(_firstDate ?? 'N/A')),
              const SizedBox(width: 10),
              const Text('Entre', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 10),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    _secondDate = dateee.toString();
                    setState(() {});
                    getWork(_firstDate, _secondDate);
                  },
                  child: Text(_secondDate ?? 'N/A')),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 200,
            child: Material(
              color: Colors.white,
              child: TextField(
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      listFilter = List.from(list
                          .where((x) =>
                              x.ficha!
                                  .toUpperCase()
                                  .contains(val.toString().toUpperCase()) ||
                              x.numOrden!
                                  .toUpperCase()
                                  .contains(val.toString().toUpperCase()))
                          .toList());
                    });
                  } else {
                    setState(() {
                      listFilter = List.from(list);
                    });
                  }
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15.0),
                    hintText: 'Order/Ficha',
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // //// lista de trabajos de la machines
          SizedBox(
            height: 30,
            width: size.width * 0.70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tomarUsuariosList(list).length,
              itemBuilder: (context, index) {
                String text = tomarUsuariosList(list)[index];
                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          usuario = text;
                          isCombine
                              ? searchingCombine()
                              : searchingEmploye(usuario);
                        },
                        child: Text(text),
                      ),
                      usuario.toUpperCase() == text.toUpperCase()
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  usuario = '';
                                  listFilter = List.from(list);
                                });
                              },
                              icon: const Icon(Icons.close, color: colorsRed))
                          : const SizedBox()
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),

          // /// lista de los usuarios de los trabajos
          SizedBox(
            height: 35,
            width: size.width * 0.70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  tomarTrabajosList(isCombine ? list : listFilter).length,
              itemBuilder: (context, index) {
                String text =
                    tomarTrabajosList(isCombine ? list : listFilter)[index];
                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          typeTrabajo = text;
                          isCombine
                              ? searchingCombine()
                              : searchingTypeWork(typeTrabajo);
                        },
                        child: Text(text),
                      ),
                      typeTrabajo.toUpperCase() == text.toUpperCase()
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  typeTrabajo = '';
                                  listFilter = List.from(list);
                                });
                              },
                              icon: const Icon(Icons.close, color: colorsRed))
                          : const SizedBox()
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),

          //// lista de los  trabajo de la machines
          listFilter.isNotEmpty
              ? Expanded(
                  child: SizedBox(
                    width: size.width * 0.70,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: listFilter.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Sublima current = listFilter[index];
                          return CardSublimacionHistorial(
                            current: current,
                            eliminarPress: (Sublima element) {
                              deleteFromSublima(element.id);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('No hay Trabajos  '), Icon(Icons.error)],
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          ////Total de la pieza y maquina
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 30,
                  width: 150,
                  alignment: Alignment.center,
                  color: colorsBlueTurquesa,
                  child: Text('TRABAJOS : ${listFilter.length}',
                      style: styte.labelMedium?.copyWith(color: Colors.white))),
              const SizedBox(width: 25),
              Container(
                height: 30,
                width: 150,
                alignment: Alignment.center,
                color: colorsBlueTurquesa,
                child: Text('PIEZAS : ${getTotalPieza(listFilter)}',
                    style: styte.labelMedium?.copyWith(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

String diferentTime(Sublima current) {
  Duration? diferences;
  DateTime date1 =
      DateTime.parse(current.dateStart.toString().substring(0, 19));
  DateTime date2 = DateTime.parse(current.dateEnd.toString().substring(0, 19));
  diferences = date2.difference(date1);

  return diferences.toString().substring(0, 8);
}

class TableWork extends StatelessWidget {
  final List<Sublima> data;

  const TableWork({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          dataTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
          border: TableBorder.symmetric(
              inside: const BorderSide(
                  style: BorderStyle.solid, color: Colors.black45, width: 1)),
          columns: const [
            DataColumn(label: Text('ORDEN')),
            DataColumn(label: Text('FICHA')),
            DataColumn(label: Text('LOGO')),
            DataColumn(label: Text('TRABAJO')),
            DataColumn(label: Text('ORDEN/CANTIDAD')),
            DataColumn(label: Text('PKT/FULL')),
            DataColumn(label: Text('TIEMPOS')),
            DataColumn(label: Text('PROMEDIOS')),
            DataColumn(label: Text('EMPLEADOS')),
          ],
          rows: data.map((entry) {
            return DataRow(cells: [
              DataCell(Text(entry.numOrden ?? 'N/A')),
              DataCell(Text(
                entry.ficha ?? 'N/A',
                style: const TextStyle(
                    color: colorsBlueTurquesa, fontWeight: FontWeight.bold),
              )),
              DataCell(Text(entry.nameLogo ?? 'N/A')),
              DataCell(Text(entry.nameWork ?? 'N/A')),
              DataCell(Row(
                children: [
                  Text(
                    entry.cantOrden ?? 'N/A',
                    style: const TextStyle(color: Colors.teal),
                  ),
                  const SizedBox(child: Text('--')),
                  Text(
                    entry.cantPieza ?? 'N/A',
                    style: const TextStyle(
                        color: colorsAd, fontWeight: FontWeight.bold),
                  )
                ],
              )),
              DataCell(Row(
                children: [
                  Text(entry.pkt ?? 'N/A'),
                  const SizedBox(child: Text('--')),
                  Text(entry.dFull ?? 'N/A')
                ],
              )),
              DataCell(Row(
                children: [
                  Text(
                    entry.dateStart ?? 'N/A',
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(child: Text('--')),
                  Text(
                    entry.dateEnd ?? 'N/A',
                    style: const TextStyle(color: colorsAd),
                  )
                ],
              )),
              DataCell(Text(diferentTime(entry).toString().substring(0, 7),
                  style: const TextStyle(
                      color: colorsRedOpaco, fontWeight: FontWeight.bold))),
              DataCell(Text(entry.fullName ?? 'N/A')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
