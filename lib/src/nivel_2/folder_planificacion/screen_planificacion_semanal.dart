import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/folder_print_planificacion/print_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/screen_detalles_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/tabla_indentifiacion_action/indentificacion_action.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';
import '../../widgets/pick_range_date.dart';
import 'record_planificacion/screen_record_planificacion.dart';

// import '../tabla_indentifiacion_action/indentificacion_action.dart';
// import 'record_planificacion/screen_record_planificacion.dart';

class ScreenPlanificacionSemanal extends StatefulWidget {
  const ScreenPlanificacionSemanal({Key? key}) : super(key: key);

  @override
  State<ScreenPlanificacionSemanal> createState() =>
      _ScreenPlanificacionSemanalState();
}

class _ScreenPlanificacionSemanalState
    extends State<ScreenPlanificacionSemanal> {
  List<Department> listDepart = []; //// lista de todo los department
  // lista de department disponible por el usuarios
  List<Department> listDepartAvailble = [];
////list de producto acuerdo al usuario acesso alos departmentes
  List<PlanificacionItem> listItems = [];

  ///lista de planificacion
  List<PlanificacionItem> listItemsFilter = [];
  String? _firstDate = DateTime.now()
      .subtract(const Duration(days: 30))
      .toString()
      .substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();
    getDepartmentNiveles();
    filterFechaBetween(_firstDate, _secondDate);
  }

  Future getDepartmentNiveles() async {
    final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    // debugPrint('departamentos:  ${res.body}');
    listDepart = departmentFromJson(res.body);
    departmentFilter = listDepart[0].toString();
    statu = onProceso;
    confirmacionDepartm();
  }

  Future filterFechaBetween(date1, date2) async {
    final res = await httpRequestDatabase(
        selectProductoPlanificacionLastItemAllByDate,
        {'modo': 'DESC', 'date1': date1, 'date2': date2});

    List<PlanificacionItem> listItemsLocal =
        planificacionItemFromJson(res.body);
    if (listItemsLocal.isNotEmpty) {
      fillList(listItemsLocal);
      setState(() {});
    }
  }

  String departmentFilter = '';
  String statu = onProceso;
  //------/  new Function /-------------

  String departChip = '';

  String getTotalCant(List<PlanificacionItem> list) {
    int total = 0;
    for (var item in list) {
      total += int.parse(item.cant ?? '0');
    }

    return total.toString();
  }

  int indexDuration = 0;

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Planificación Semanal'),
        actions: [
          Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(top: 10, right: 10),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listItemsFilter.isNotEmpty) {
                  final pdfFile = await PdfPlanificacion.generate(
                      listItemsFilter, _firstDate, _secondDate);

                  PdfApi.openFile(pdfFile);
                }
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ScreenRecordPlanificacion()));
                  },
                  icon: const Icon(Icons.calendar_month, color: Colors.black))),
          Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(top: 10, right: 16),
            child: PopupMenuButton<TablaIdentity>(
              color: Colors.white,
              icon: Icon(Icons.adaptive.more, color: Colors.black),
              onSelected: (TablaIdentity value) {
                setState(() {
                  if (departChip.isNotEmpty) {
                    listItemsFilter = List.from(listItems
                        .where((x) =>
                            x.department!.toUpperCase() ==
                                departChip.toUpperCase() &&
                            x.statu!.toUpperCase() ==
                                value.action.toUpperCase())
                        .toList());
                  } else {
                    listItemsFilter = List.from(listItems
                        .where((x) => x.statu!
                            .toUpperCase()
                            .contains(value.action.toUpperCase()))
                        .toList());
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return list.map<PopupMenuItem<TablaIdentity>>(
                  (TablaIdentity item) {
                    return PopupMenuItem<TablaIdentity>(
                      value: item,
                      child: Text(item.action,
                          style: TextStyle(color: item.color)),
                    );
                  },
                ).toList();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                departChip = '';
                listItems.clear();
                listItemsFilter.clear();
                _firstDate = date1.toString();
                _secondDate = date2.toString();

                filterFechaBetween(_firstDate, _secondDate);
              });
              listItems.clear();
              listItemsFilter.clear();
            },
          ),
          SizedBox(
            width: 233,
            child: FadeIn(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
                child: TextField(
                  onChanged: (val) async {
                    searchingOrden(val);
                  },
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
                children: listDepartAvailble.map((depart) {
                  indexDuration += 30;

                  return BounceInDown(
                    delay: Duration(milliseconds: 50 + indexDuration),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 35,
                        color: departChip.toUpperCase() ==
                                depart.nameDepartment?.toUpperCase()
                            ? Colors.red
                            : Colors.blue,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  departChip = depart.nameDepartment.toString();
                                  listItemsFilter = List.from(listItems
                                      .where((x) => x.department!
                                          .toUpperCase()
                                          .contains(departChip.toUpperCase()))
                                      .toList());
                                  setState(() {});
                                },
                                child: Text(
                                  depart.nameDepartment ?? 'N/A',
                                  style: const TextStyle(color: Colors.white),
                                )),
                            departChip.toUpperCase() ==
                                    depart.nameDepartment?.toUpperCase()
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        departChip = '';
                                        listItemsFilter = List.from(listItems);
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
          const SizedBox(height: 15),
          listItemsFilter.isNotEmpty
              ? Expanded(
                  child: SizedBox(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        dataRowMaxHeight: 30,
                        dataRowMinHeight: 20,
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
                                color: Colors.grey.shade100,
                                style: BorderStyle.none),
                            inside: const BorderSide(
                                style: BorderStyle.solid, color: Colors.grey)),
                        columns: [
                          const DataColumn(label: Text('Departamento')),
                          const DataColumn(label: Text('Estado')),
                          const DataColumn(label: Text('Num Orden')),
                          DataColumn(
                              label: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort((a, b) =>
                                          a.ficha!.compareTo(b.ficha!));
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_up,
                                      color: Colors.green)),
                              const Text('Fichas'),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort((a, b) =>
                                          b.ficha!.compareTo(a.ficha!));
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.red))
                            ],
                          )),
                          const DataColumn(label: Text('Logo')),
                          const DataColumn(label: Text('Producto')),
                          DataColumn(
                              label: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort(
                                          (a, b) => a.cant!.compareTo(b.cant!));
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_up,
                                      color: Colors.green)),
                              const Text('Cant'),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort(
                                          (a, b) => b.cant!.compareTo(a.cant!));
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.red))
                            ],
                          )),
                          const DataColumn(label: Text('Comentario')),
                          DataColumn(
                              label: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort((a, b) =>
                                          a.fechaEnd!.compareTo(b.fechaEnd!));
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_up,
                                      color: Colors.green)),
                              const Text('Fecha Entrega'),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listItemsFilter.sort((a, b) =>
                                          b.fechaEnd!.compareTo(a.fechaEnd!));
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.red))
                            ],
                          )),
                        ],
                        rows: listItemsFilter
                            .map(
                              (item) => DataRow(
                                selected: true,
                                color: MaterialStateProperty.resolveWith(
                                    (states) => getColor(item)),
                                cells: [
                                  DataCell(Text(item.department ?? '')),
                                  DataCell(
                                      SizedBox(
                                          width: 70,
                                          child: Text(
                                            item.statu ?? '',
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )), onTap: () {
                                    utilShowMesenger(context, item.statu ?? '',
                                        title: 'Estado');
                                  }),
                                  DataCell(
                                    Row(
                                      children: [
                                        Text(
                                          item.numOrden ?? '',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        currentUsers?.occupation ==
                                                    OptionAdmin.admin.name ||
                                                currentUsers?.occupation ==
                                                    OptionAdmin.master.name ||
                                                currentUsers?.occupation ==
                                                    OptionAdmin.boss.name
                                            ? TextButton(
                                                child: const Text(
                                                  'Eliminar',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () =>
                                                    eliminarOrden(item.id))
                                            : const SizedBox(),
                                      ],
                                    ),
                                    placeholder: true,
                                    // showEditIcon: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (conext) =>
                                              DetallesPlanificacion(
                                            currentLocal: item,
                                          ),
                                        ),
                                      ).then((value) => {
                                            filterFechaBetween(
                                                _firstDate, _secondDate),
                                          });
                                    },
                                  ),
                                  DataCell(
                                      SizedBox(
                                        width: 75,
                                        child: Text(item.ficha ?? '',
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ), onTap: () {
                                    getMensajeWidget(
                                        context, item.ficha ?? 'N/A');
                                  }),
                                  DataCell(
                                      Text(item.nameLogo ?? '', maxLines: 1),
                                      onTap: () {
                                    utilShowMesenger(
                                        context, item.nameLogo ?? '',
                                        title: 'LOGO');
                                  }),
                                  DataCell(
                                      SizedBox(
                                          width: 70,
                                          child: Text(item.tipoProduct ?? '',
                                              maxLines: 1)), onTap: () {
                                    utilShowMesenger(
                                        context, item.tipoProduct ?? '',
                                        title: 'Detalles Producto');
                                  }),
                                  DataCell(Text(item.cant ?? '')),
                                  DataCell(
                                    SizedBox(
                                      width: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          utilShowMesenger(
                                              context, item.comment ?? '');
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
                                  DataCell(
                                    item.isDone == 'f'
                                        ? Text(
                                            item.fechaEnd ?? '',
                                            style: TextStyle(
                                                color: comparaTime(
                                                        DateTime.parse(
                                                            item.fechaEnd ??
                                                                ''))
                                                    ? Colors.black
                                                    : Colors.red,
                                                fontWeight: comparaTime(
                                                        DateTime.parse(
                                                            item.fechaEnd ??
                                                                ''))
                                                    ? FontWeight.normal
                                                    : FontWeight.bold),
                                          )
                                        : Text(item.fechaEnd ?? ''),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ))
              : const Center(child: Text('No hay datos')),
          listItemsFilter.isNotEmpty
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
                                      Text('${listItemsFilter.length}',
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
                                              getTotalCant(listItemsFilter))),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ////   -------------------------------///
                          // ZoomIn(
                          //   delay: const Duration(milliseconds: 400),
                          //   child: Container(
                          //     height: 70,
                          //     decoration: const BoxDecoration(color: Colors.white),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 20),
                          //       child: Center(
                          //         child: Row(
                          //           children: [
                          //             const Text('ONZA: '),
                          //             const SizedBox(width: 15),
                          //             Text('${onza.toStringAsFixed(6)} AVG',
                          //                 style: const TextStyle(
                          //                     color: Colors.red,
                          //                     fontWeight: FontWeight.bold)),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // ZoomIn(
                          //   delay: const Duration(milliseconds: 500),
                          //   child: Container(
                          //     height: 70,
                          //     decoration: const BoxDecoration(color: Colors.white),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 20),
                          //       child: Center(
                          //         child: Row(
                          //           children: [
                          //             const Text('HUMEDAD: '),
                          //             const SizedBox(width: 15),
                          //             Text('${humedad.toStringAsFixed(2)} AVG',
                          //                 style: const TextStyle(
                          //                     color: Colors.green,
                          //                     fontWeight: FontWeight.bold)),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(width: 15),

                          // ZoomIn(
                          //   delay: const Duration(milliseconds: 600),
                          //   child: Container(
                          //     height: 70,
                          //     decoration: const BoxDecoration(color: Colors.white),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 20),
                          //       child: Center(
                          //         child: Row(
                          //           children: [
                          //             const Text('PESO/HUMEDAD: '),
                          //             const SizedBox(width: 15),
                          //             Text('${pesoHumeda.toStringAsFixed(2)} AVG',
                          //                 style: const TextStyle(
                          //                     color: Colors.red,
                          //                     fontWeight: FontWeight.bold)),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // const SizedBox(width: 15),

                          // ZoomIn(
                          //   delay: const Duration(milliseconds: 700),
                          //   child: Container(
                          //     height: 70,
                          //     decoration: const BoxDecoration(color: Colors.white),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 20),
                          //       child: Center(
                          //         child: Row(
                          //           children: [
                          //             const Text('SUPLIDOR/PROCESSING'),
                          //             const SizedBox(width: 15),
                          //             Text(
                          //                 '${suplidorProcesing.toStringAsFixed(2)} AVG',
                          //                 style: const TextStyle(
                          //                     color: Colors.brown,
                          //                     fontWeight: FontWeight.bold)),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

  Future searchingFilterDepartment() async {
    if (departmentFilter.isNotEmpty) {
      listItemsFilter = List.from(listItems
          .where((x) => x.department!
              .toUpperCase()
              .contains(departmentFilter.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      listItemsFilter = List.from(listItems);
      setState(() {});
    }
  }

  Future searchingFilterDepartmentWithTable() async {
    // print('departmentFilter es :  $departmentFilter');
    // print('statu es : $statu');
    if (departmentFilter.isNotEmpty) {
      listItemsFilter = List.from(listItems
          .where((x) => x.department!
              .toUpperCase()
              .contains(departmentFilter.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      listItemsFilter = List.from(listItems);
      setState(() {});
    }
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta seguro de eliminar esto?❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              Navigator.of(context).pop();
              // print('Eliminado');
              await httpRequestDatabase(
                  deleteProductoPlanificacionLast, {'id': '$id'});
              filterFechaBetween(_firstDate, _secondDate);
            },
          );
        });
  }

  confirmacionDepartm() {
    for (var depart in listDepart) {
      currentUsers!.type.toString().contains(depart.type ?? '0'.toString()) ||
              currentUsers!.type.toString().contains('t')
          ? listDepartAvailble.add(depart)
          : null;
    }
    setState(() {});
  }

  void fillList(List<PlanificacionItem> list) {
    listItems.clear();
    listItemsFilter.clear();
    for (var item in listDepartAvailble) {
      for (var producto in list) {
        producto.department == item.nameDepartment
            ? listItems.add(producto)
            : null;
      }
    }
    listItemsFilter = [...listItems];
    listItemsFilter.sort((a, b) => a.fechaEnd!.compareTo(b.fechaEnd!));
    if (departChip.isNotEmpty) {
      listItemsFilter = List.from(listItems
          .where((x) =>
              x.department!.toUpperCase().contains(departChip.toUpperCase()))
          .toList());
    }

    setState(() {});
  }

  Future searchingOrden(String val) async {
    if (departChip.isEmpty) {
      if (val.isNotEmpty) {
        // print(_planificacionListFilter.length);
        setState(() {
          listItemsFilter = List.from(listItems
              .where((x) =>
                  x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
                  x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
                  x.nameLogo!.toUpperCase().contains(val.toUpperCase()))
              .toList());
        });
      } else {
        setState(() {
          listItemsFilter = [...listItems];
        });
      }
    } else {
      if (val.isNotEmpty) {
        // print(_planificacionListFilter.length);
        listItemsFilter = List.from(listItems
            .where((x) =>
                x.department!.toUpperCase() == departChip.toUpperCase() &&
                    x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
                x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
                x.ficha!.toUpperCase().contains(val.toUpperCase()))
            .toList());
        setState(() {});
      } else {
        listItemsFilter = List.from(listItems
            .where(
                (x) => x.department!.toUpperCase() == departChip.toUpperCase())
            .toList());
        setState(() {});
      }
    }
    // print('Listo');
  }
}

Color getColor(PlanificacionItem planificacion) {
  if (planificacion.statu == onProducion) {
    return Colors.cyan.shade100;
  }
  if (planificacion.statu == onEntregar) {
    return Colors.orangeAccent.shade100;
  }
  if (planificacion.statu == onParada) {
    return Colors.redAccent.shade100;
  }
  if (planificacion.statu == onProceso) {
    return Colors.teal.shade100;
  }
  if (planificacion.statu == onFallo) {
    return Colors.black54;
  }
  if (planificacion.statu == onDone) {
    return Colors.green.shade200;
  }
  return Colors.white;
}

bool comparaTime(DateTime time1) {
  // Creamos las dos fechas a comparar
  // DateTime fecha1 = DateTime(2022, 5, 1);
  DateTime fecha2 = DateTime.now();
  DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
  // debugPrint('Fecha de Entrega es : $soloFecha comparar con $fecha2');
  // print('La fecha soloFecha $soloFecha');
  if (soloFecha.isBefore(time1)) {
    // print(true);
    return true;
  } else {
    // print(false);
    return false;
  }
}
