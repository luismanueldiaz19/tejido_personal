import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';
import '../../../datebase/methond.dart';
import '../folder_print_planificacion/print_planificacion.dart';

class ScreenRecordPlanificacion extends StatefulWidget {
  const ScreenRecordPlanificacion({Key? key}) : super(key: key);

  @override
  State<ScreenRecordPlanificacion> createState() =>
      _ScreenRecordPlanificacionState();
}

class _ScreenRecordPlanificacionState extends State<ScreenRecordPlanificacion> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  List<PlanificacionItem> listRecord = [];
  List<PlanificacionItem> listRecordFilter = [];
  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getRecord('t', _firstDate, _secondDate);
  }

  Future getRecord(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectProductoPlanificacionLastRecordByDate,
        {'is_done': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionItemFromJson(res.body);
    listRecordFilter = [...listRecord];
    depurarDepartment(listRecordFilter);
    setState(() {});
  }

  void _searchingFilter(String val) {
    if (val.isNotEmpty) {
      setState(() {
        listRecordFilter = List.from(listRecord
            .where((x) =>
                x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
                x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
                x.nameLogo!.toUpperCase().contains(val.toUpperCase()))
            .toList());
      });
    } else {
      setState(() {
        listRecordFilter = [...listRecord];
      });
    }
  }

  String getTotalCant(List<PlanificacionItem> list) {
    int total = 0;
    for (var item in list) {
      total += int.parse(item.cant ?? '0');
    }

    return total.toString();
  }

  List<String> familyList = [];
  depurarDepartment(List<PlanificacionItem> list) {
    List<Map<String, dynamic>> lista = [];

    for (var element in list) {
      lista.add({
        "id": element.id,
        "id_depart": element.department,
      });
    }

    Set<String> familySet = <String>{};

    for (Map<String, dynamic> item in lista) {
      familySet.add(item['id_depart']);
    }
    familyList = familySet.toList();

    // print(saboresList); // ["BLACK SWEET", "DIAMOND"]
  } // ["BLACK SWEET", "DIAMOND"]

  String chipName = '';
  int indexDuration = 0;
  String departChip = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          // Agregado un contenedor para ajustar el espacio
          margin: const EdgeInsets.only(top: 30, right: 16),
          child: const Text('Historial de Planificación'),
        ),
        leading: Container(
          // Agregado un contenedor para ajustar el espacio
          margin: const EdgeInsets.only(
              top: 25, left: 16), // Margen para ajustar la posición
          child: const BackButton(),
        ),
        actions: [
          Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(top: 30, right: 25),
            child: TextButton.icon(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listRecordFilter.isNotEmpty) {
                  final pdfFile = await PdfPlanificacion.generate(
                      listRecordFilter, _firstDate, _secondDate);
                  PdfApi.openFile(pdfFile);
                }
              },
              label: const Text(
                'IMPRIMIR',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(top: 25, right: 16),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                // Aquí puedes manejar la opción seleccionada
                // print('Opción seleccionada: $value');
                if (value.toUpperCase() == 'TERMINADO') {
                  setState(() {
                    listRecordFilter = List.from(listRecord
                        .where((x) => x.isDone!.toUpperCase().contains('T'))
                        .toList());
                  });
                } else {
                  setState(() {
                    listRecordFilter = List.from(listRecord
                        .where((x) => x.isDone!.toUpperCase().contains('F'))
                        .toList());
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Terminado',
                    child: Text('Terminado'),
                  ),
                  const PopupMenuItem(
                    value: 'Global',
                    child: Text('Global'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    _firstDate = dateee.toString();
                    // print(_firstDate);
                    setState(() {});
                  },
                  child: Text(_firstDate ?? 'N/A')),
              const SizedBox(width: 20),
              const Text(
                'Entre',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    _secondDate = dateee.toString();
                    listRecordFilter.clear();
                    setState(() {});
                    getRecord('t', _firstDate, _secondDate);
                  },
                  child: Text(_secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),

          SizedBox(
            width: 250,
            child: FadeIn(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
                width: 250,
                child: TextField(
                  onChanged: (val) => _searchingFilter(val),
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, top: 10),
                    suffixIcon: Tooltip(
                      message: 'Buscar',
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: familyList.map((depart) {
                  indexDuration += 30;

                  return BounceInDown(
                    delay: Duration(milliseconds: 50 + indexDuration),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 35,
                        color: departChip.toUpperCase() == depart.toUpperCase()
                            ? Colors.red
                            : Colors.blue,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  departChip = depart.toString();
                                  listRecordFilter = List.from(listRecord
                                      .where((x) =>
                                          x.department!.toUpperCase() ==
                                          departChip.toUpperCase())
                                      .toList());
                                  setState(() {});
                                },
                                child: Text(
                                  depart,
                                  style: const TextStyle(color: Colors.white),
                                )),
                            departChip.toUpperCase() == depart.toUpperCase()
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        departChip = '';
                                        listRecordFilter =
                                            List.from(listRecord);
                                      });
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.white))
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          listRecordFilter.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listRecordFilter,
                  ),
                )
              : const Center(child: Text('No hay datos')),
          // listRecordFilter.isNotEmpty
          //     ? Padding(
          //         padding: const EdgeInsets.only(bottom: 25),
          //         child: ElevatedButton.icon(
          //             icon: const Icon(Icons.print),
          //             onPressed: () async {
          //               final pdfFile =
          //                   await PdfReportOrdenItem.generate(listRecordFilter);
          //               PdfApi.openFile(pdfFile);
          //             },
          //             label: const Text('Imprimir')),
          //       )
          //     : const SizedBox(),
          listRecordFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 50),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('TOTAL ORDEN : '),
                                      const SizedBox(width: 15),
                                      Text('${listRecordFilter.length}',
                                          style: const TextStyle(
                                              color: Colors.brown,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 100),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('TOTAL PIEZA: '),
                                      const SizedBox(width: 15),
                                      Text(
                                          getNumFormated(int.parse(
                                              getTotalCant(listRecordFilter))),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class TableModifica extends StatelessWidget {
  const TableModifica({Key? key, this.current}) : super(key: key);
  final List<PlanificacionItem>? current;

  Color getColor(PlanificacionItem planificacion) {
    if (planificacion.statu == onProducion) {
      return Colors.cyan.shade100;
    }
    if (planificacion.statu == onEntregar) {
      return Colors.orangeAccent.shade100;
    }
    if (planificacion.statu == onParada) {
      return Colors.redAccent.shade200;
    }
    if (planificacion.statu == onProceso) {
      return Colors.teal.shade200;
    }
    if (planificacion.statu == onFallo) {
      return Colors.black54;
    }
    if (planificacion.statu == onDone) {
      return Colors.green.shade200;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
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
                outside: BorderSide(
                    color: Colors.grey.shade100, style: BorderStyle.none),
                inside: const BorderSide(
                    style: BorderStyle.solid, color: Colors.grey)),
            columns: const [
              DataColumn(label: Text('Departamento')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Num Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cant'), numeric: true),
              DataColumn(label: Text('Comentario')),
              DataColumn(label: Text('Fecha Entrega')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    selected: true,
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(Text(item.department ?? '')),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.statu ?? '',
                              title: 'STATU');
                        },
                        SizedBox(
                          width: 50,
                          child: Text(
                            item.statu ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(Text(item.numOrden ?? '')),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.ficha ?? '',
                              title: 'FICHA');
                        },
                        SizedBox(
                          width: 50,
                          child: Text(
                            item.ficha ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.nameLogo ?? '',
                              title: 'LOGO');
                        },
                        SizedBox(
                          width: 100,
                          child: Text(
                            item.nameLogo ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.tipoProduct ?? '',
                              title: 'TYPO TRABAJOS');
                        },
                        SizedBox(
                          width: 100,
                          child: Text(
                            item.tipoProduct ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(Text(item.cant ?? '')),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: GestureDetector(
                            onTap: () {
                              utilShowMesenger(context, item.comment ?? '');
                            },
                            child: Text(
                              item.comment ?? '',
                              style: const TextStyle(
                                  color: Colors.teal,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(item.fechaEnd ?? '')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
