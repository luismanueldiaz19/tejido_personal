import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_almacen/add_almacen_orden.dart';
import 'package:tejidos/src/nivel_2/folder_almacen/model_data/almacen_data.dart';
import 'package:tejidos/src/nivel_2/folder_almacen/show_details_dialog.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

//// agregar el un nombre cliente
//// Busqueda por ficha , orden,
///// code de usuario
////  busqueda
///  suma de costo
/// //// poner incidencia a trabajo de almacen
/// agregar uncidencia normales

class ScreenAlmacen extends StatefulWidget {
  const ScreenAlmacen({Key? key, required this.current}) : super(key: key);
  final Department current;

  @override
  State<ScreenAlmacen> createState() => _ScreenAlmacenState();
}

class _ScreenAlmacenState extends State<ScreenAlmacen> {
  String? _secondDate = '';
  String? _firstDate = '';
  List<AlmacenData> list = [];

  List<AlmacenData> listFilter = [];
  int totalCant = 0;
  int totalPrice = 0;
  bool isInsidencia = false;
  Future getDataAlmacen(date1, date2) async {
    String selectAlmacenByDate1 =
        "http://$ipLocal/settingmat/admin/select/select_almacen_item_get.php";
    // setState(() {});
    final res = await httpRequestDatabase(selectAlmacenByDate1, {
      'date1': date1,
      'date2': date2,
    });
    print(res.body);
    list = almacenDataFromJson(res.body);
    listFilter = [...list];
    calcularCostsPrice(listFilter);
    setState(() {});
  }

  Future getDataAlmacenPorIncidencia(date1, date2, isInsidencia) async {
    String selectAlmacenByDate1 =
        "http://$ipLocal/settingmat/admin/select/select_almacen_item_get_is_incidencia.php";
    // setState(() {});
    final res = await httpRequestDatabase(selectAlmacenByDate1, {
      'date1': date1,
      'date2': date2,
      'is_incidencia': isInsidencia.toString().substring(0, 1),
    });
    // print(res.body);
    list = almacenDataFromJson(res.body);
    listFilter = [...list];
    calcularCostsPrice(listFilter);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate =
        DateTime.now().add(const Duration(days: 1)).toString().substring(0, 10);
    getDataAlmacen(_firstDate, _secondDate);
  }

  // Future deleteFromAlmacen(AlmacenData current) async {
  //   await httpRequestDatabase(deleteAlmacen, {'id': current.id});

  //   await httpRequestDatabase(deleteAlmacenItem, {'id': current.idKeyItem});

  //   getDataAlmacen(_firstDate, _secondDate);
  // }

  calcularCostsPrice(List<AlmacenData> list) {
    totalCant = 0;
    totalPrice = 0;
    for (var element in list) {
      totalCant += int.parse(element.cant ?? '0');
      totalPrice += int.parse(element.resultado ?? '0');
    }
  }

  List<AlmacenData> listFilterExample = [];
  List<DataRow> buildRowsSabor(List<AlmacenData> list) {
    Map<String, int> sumBySabor = {};

    for (var item in list) {
      if (sumBySabor.containsKey(item.idKeyItem)) {
        sumBySabor[item.idKeyItem ?? 'N/A'] =
            sumBySabor[item.idKeyItem]! + int.parse(item.resultado ?? '0');
        // var localItem = listFilterExample
        //     .where((element) => element.idKeyItem == item.idKeyItem);
        // print(localItem.);
      } else {
        sumBySabor[item.idKeyItem ?? 'N/A'] = int.parse(item.resultado ?? '0');
        listFilterExample.add(AlmacenData(
            fullName: item.fullName,
            isIncidencia: item.isIncidencia,
            dateCurrent: item.dateCurrent,
            idKeyItem: item.idKeyItem,
            ficha: item.ficha,
            numOrden: item.numOrden,
            cliente: item.cliente,
            cant: item.cant,
            price: item.price,
            resultado: item.resultado));
      }
    }
    // {"code":"199512","full_name":"LUDEVELOPER",
    //"is_incidencia":"f",
    //"date_current":"2023-07-23 17:49:32",
    //"id_key_item":"589370022","ficha":"125",
    //"num_orden":"859","cliente":"Facebookk","cant":"30","price":"125","resultado":"3750"}

    return sumBySabor.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(getNumFormated(int.parse(entry.value.toString())))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 20, left: 16),
          child: const BackButton(),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 20, right: 16),
          child: const Text('Almacen'),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 25, right: 25),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddAlmacenOrden(current: widget.current)))
                    .then((value) {
                  getDataAlmacen(_firstDate, _secondDate);
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
                    list.clear();
                    if (isInsidencia) {
                      getDataAlmacenPorIncidencia(
                          _firstDate, _secondDate, isInsidencia);
                    } else {
                      getDataAlmacen(_firstDate, _secondDate);
                    }
                    setState(() {});
                  },
                  child: Text(_secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              'Reportado Por Incidencias',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(width: 15),
            Checkbox(
                value: isInsidencia,
                onChanged: (val) {
                  setState(() {
                    isInsidencia = !isInsidencia;
                  });
                  if (isInsidencia) {
                    getDataAlmacenPorIncidencia(
                        _firstDate, _secondDate, isInsidencia);
                  } else {
                    getDataAlmacen(_firstDate, _secondDate);
                  }
                })
          ]),
          BounceInDown(
            child: Container(
              color: Colors.white,
              width: 250,
              child: TextField(
                onChanged: (val) => searchingFilter(val),
                decoration: const InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 10),
                  suffixIcon: Tooltip(
                    message: 'Buscar por Client/Telefono/Orden/Logo',
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          /////tabla de los datos
          listFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dataRowMaxHeight: 20,
                            dataRowMinHeight: 10,
                            columnSpacing: 25,
                            border: TableBorder.symmetric(
                                outside: BorderSide(
                                    color: Colors.grey.shade100,
                                    style: BorderStyle.none),
                                inside: const BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.black38)),
                            columns: const [
                              DataColumn(label: Text('ID SGMTO')),
                              DataColumn(label: Text('FICHA/ORDEN')),
                              DataColumn(label: Text('PRODUCTO')),
                              DataColumn(label: Text('CLIENTES')),
                              DataColumn(label: Text('PCS TOTAL')),
                              DataColumn(label: Text('TOTAL')),
                              DataColumn(label: Text('FECHA')),
                              DataColumn(label: Text('ACTION')),
                              DataColumn(label: Text('EMPLEADO')),
                            ],
                            rows: listFilter
                                .map((item) => DataRow(cells: [
                                      DataCell(Text(item.idKeyItem ?? '')),
                                      DataCell(Row(
                                        children: [
                                          Text(item.ficha ?? '',
                                              style: const TextStyle(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold)),
                                          const Text(' -- '),
                                          Text(item.numOrden ?? '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )),

                                      DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            item.nameProducto!.toUpperCase(),
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        onTap: () {
                                          utilShowMesenger(context,
                                              item.nameProducto!.toUpperCase());
                                        },
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            item.cliente!.toUpperCase(),
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        onTap: () {
                                          utilShowMesenger(context,
                                              item.cliente!.toUpperCase());
                                        },
                                      ),
                                      DataCell(Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item.cant ?? ''),
                                          TextButton(
                                            onPressed: () => showDetails(item),
                                            child: const Text('Detalles',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          )
                                        ],
                                      )),
                                      // DataCell(Text(item.price ?? '')),
                                      DataCell(Text(
                                        '\$ ${item.resultado ?? ''}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(Text(item.dateCurrent ?? '',
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500))),
                                      DataCell(TextButton(
                                        child: const Text(
                                          'Incidencia',
                                          style: TextStyle(color: colorsAd),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AddIncidenciaSublimacion(
                                                current: Sublima(
                                                    numOrden: item.numOrden,
                                                    ficha: item.ficha,
                                                    nameDepartment: widget
                                                        .current
                                                        .nameDepartment),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                      DataCell(Text(item.fullName ?? '')),
                                    ]))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                  child: Text('No hay Data'),
                )),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  height: 30,
                  width: 200,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'TOTAL PIEZAS : ${getNumFormated(int.parse('$totalCant'))}',
                            style: style.bodyMedium)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  height: 30,
                  width: 200,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'TOTAL COSTO : ${getNumFormated(int.parse('$totalPrice'))}',
                          style: style.bodyMedium),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  showDetails(AlmacenData item) async {
    showDialog(
      context: context,
      builder: (_) {
        return ShowDetailsDialog(item: item);
      },
    );
  }

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listFilter = List.from(list
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.cliente!.toUpperCase().contains(val.toUpperCase()) ||
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      calcularCostsPrice(listFilter);

      setState(() {});
    } else {
      listFilter = [...list];
      calcularCostsPrice(listFilter);
      setState(() {});
    }
  }
}

// class CardAlmacen extends StatefulWidget {
//   const CardAlmacen(
//       {Key? key,
//       required this.current,
//       required this.pressDelete,
//       required this.calcularTotal})
//       : super(key: key);
//   final AlmacenData current;
//   final Function pressDelete;
//   final Function calcularTotal;
//   @override
//   State<CardAlmacen> createState() => _CardAlmacenState();
// }

// class _CardAlmacenState extends State<CardAlmacen> {
//   List<AlmacenItem> listItem = [];
//   int totalUnits = 0;
//   int totalCosts = 0;

//   calcular() {
//     totalUnits = 0;
//     totalCosts = 0;
//     int multiplo = 0;
//     for (var element in listItem) {
//       multiplo =
//           int.parse(element.cant ?? '0') * int.parse(element.price ?? '0');
//       totalCosts += multiplo;
//       totalUnits += int.parse(element.cant ?? '0');
//     }
//     // Map data = {
//     //   'totalUnits': totalUnits.toString(),
//     //   'totalUnits': totalCosts.toString(),
//     // };
//     widget.calcularTotal(totalUnits, totalCosts);
//   }

//   Future getDataAlmacen() async {
//     final res = await httpRequestDatabase(selectAlmacenItem,
//         {'id_key_item': widget.current.idKeyItem.toString()});
//     // print('product : ${res.body}');
//     listItem = almacenItemFromJson(res.body);
//     calcular();
//     if (listItem.isNotEmpty) {
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getDataAlmacen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var textSize = 10.0;
//     final size = MediaQuery.of(context).size;
//     double sizeObtenido = getSize(size.width);
//     double sideText = sizeObtenido * 0.030;
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.75,
//         child: Material(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.current.fullName.toString(),
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall!
//                               .copyWith(fontSize: sideText),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'Client:  ',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(fontSize: sideText),
//                             ),
//                             Text(
//                               widget.current.cliente.toString(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(
//                                       color: colorsPuppleOpaco,
//                                       fontSize: sideText),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "Orden : ${widget.current.numOrden.toString()}",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall!
//                               .copyWith(fontSize: sideText),
//                         ),
//                         Text(
//                           "Ficha : ${widget.current.ficha.toString()}",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall!
//                               .copyWith(fontSize: sideText),
//                         ),
//                         Text(
//                           'Total Units : $totalUnits',
//                           style: TextStyle(
//                               fontSize: sideText,
//                               fontWeight: FontWeight.bold,
//                               color: colorsPuppleOpaco),
//                         ),
//                         Text(
//                           'Total Costs : $totalCosts',
//                           style: TextStyle(
//                               fontSize: sideText + 2,
//                               fontWeight: FontWeight.bold,
//                               color: colorsGreenLevel),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'Fecha : ',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(fontSize: sideText),
//                             ),
//                             Text(
//                               widget.current.dateCurrent.toString(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(
//                                       color: Colors.blueAccent,
//                                       fontSize: sideText),
//                             ),
//                           ],
//                         ),
//                         TextButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => AddIncidenciaSublimacion(
//                                     current: Sublima(
//                                         numOrden: widget.current.numOrden,
//                                         ficha: widget.current.ficha,
//                                         nameDepartment:
//                                             widget.current.nameDepartment),
//                                   ),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.warning,
//                                 color: colorsRedVinoHard),
//                             label: const Text('Incidencia'))
//                       ],
//                     ),
//                   ),

//                   //   AlmacenItem item = listItem[index];
//                   listItem.isEmpty
//                       ? const Text('Cargando ..')
//                       : Expanded(
//                           flex: 3,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: SingleChildScrollView(
//                               physics: const BouncingScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               child: SingleChildScrollView(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.vertical,
//                                 child: DataTable(
//                                   columns: [
//                                     DataColumn(
//                                       label: Text('Productos',
//                                           style: TextStyle(fontSize: sideText)),
//                                     ),
//                                     DataColumn(
//                                       label: Text('Cant / Costs',
//                                           style: TextStyle(fontSize: sideText)),
//                                     ),
//                                     DataColumn(
//                                       label: Text('Total',
//                                           style: TextStyle(fontSize: sideText)),
//                                     ),
//                                   ],
//                                   rows: listItem
//                                       .map((e) => DataRow(cells: [
//                                             DataCell(
//                                               Text(e.nameProducto ?? 'Product ',
//                                                   style: TextStyle(
//                                                       fontSize: sideText)),
//                                             ),
//                                             DataCell(
//                                               Row(
//                                                 children: [
//                                                   Text(e.cant ?? 'Product',
//                                                       style: TextStyle(
//                                                           fontSize: sideText)),
//                                                   const SizedBox(width: 10),
//                                                   Text('\$ ${e.price ?? 'N/A'}',
//                                                       style: TextStyle(
//                                                           fontSize: sideText)),
//                                                 ],
//                                               ),
//                                             ),
//                                             DataCell(
//                                               Text(
//                                                   '${int.parse(e.cant ?? '0') * int.parse(e.price ?? '0')}',
//                                                   style: TextStyle(
//                                                       fontSize: sideText,
//                                                       color: colorsGreenLevel,
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                             )
//                                           ]))
//                                       .toList(),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         currentUsers?.occupation.toString() ==
//                                     OptionAdmin.admin.name ||
//                                 currentUsers?.occupation.toString() ==
//                                     OptionAdmin.master.name
//                             ? TextButton(
//                                 onPressed: () => widget.pressDelete(),
//                                 child: const Text('Eliminar'),
//                               )
//                             : const SizedBox(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Expanded(
//   child: Row(
//     children: [
//       Expanded(
//         flex: 3,
//         child: Column(
//           children: [
//             listFilter.isEmpty
//                 ? const SizedBox(
//                     child: Text('No hay Reportes'),
//                   )
//                 : Expanded(
//                     child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40.0),
//                         child: SingleChildScrollView(
//                           physics: const BouncingScrollPhysics(),
//                           child: Column(
//                             children: listFilter
//                                 .map((current) => CardAlmacen(
//                                       calcularTotal: (int totalUnits,
//                                           int totalCosts) {
//                                         // totalUnitsLocal +=
//                                         //     totalUnits;
//                                         // totalCostsLocal +=
//                                         //     totalCosts;
//                                         // setState(() {});
//                                       },
//                                       current: current,
//                                       pressDelete: () =>
//                                           deleteFromAlmacen(current),
//                                     ))
//                                 .toList(),
//                           ),
//                         )),
//                   ),
//           ],
//         ),
//       ),
//       // Expanded(
//       //   flex: 1,
//       //   child: Padding(
//       //     padding: const EdgeInsets.symmetric(horizontal: 25),
//       //     child: Column(
//       //       children: [
//       //         ClipRRect(
//       //           borderRadius: BorderRadius.circular(20.0),
//       //           child: SizedBox(
//       //             height: size.height * 0.30,
//       //             width: size.height * 0.30,
//       //             child: Image.asset(
//       //               'assets/almacen.jpg',
//       //               fit: BoxFit.cover,
//       //             ),
//       //           ),
//       //         ),
//       //         Text('Center',
//       //             style:
//       //                 Theme.of(context).textTheme.titleLarge),
//       //         Row(
//       //           mainAxisAlignment:
//       //               MainAxisAlignment.spaceAround,
//       //           children: [
//       //             Text('Total Pieza',
//       //                 style: Theme.of(context)
//       //                     .textTheme
//       //                     .titleMedium),
//       //             const SizedBox(width: 10),
//       //             Text(getNumFormated(totalUnitsLocal),
//       //                 style: Theme.of(context)
//       //                     .textTheme
//       //                     .titleMedium
//       //                     ?.copyWith(color: colorsPuppleOpaco)),
//       //           ],
//       //         ),
//       //         Row(
//       //           mainAxisAlignment:
//       //               MainAxisAlignment.spaceAround,
//       //           children: [
//       //             Text('Total Cost',
//       //                 style: Theme.of(context)
//       //                     .textTheme
//       //                     .titleMedium),
//       //             const SizedBox(width: 10),
//       //             Text('\$ ${getNumFormated(totalCostsLocal)}',
//       //                 style: Theme.of(context)
//       //                     .textTheme
//       //                     .titleMedium
//       //                     ?.copyWith(color: colorsPuppleOpaco)),
//       //           ],
//       //         ),
//       //         const SizedBox(height: 10),
//       //         SizedBox(
//       //           width: 150,
//       //           child: ElevatedButton(
//       //             onPressed: () {},
//       //             child: const Text('Print'),
//       //           ),
//       //         )
//       //       ],
//       //     ),
//       //   ),
//       // )
//     ],
//   ),
// )
