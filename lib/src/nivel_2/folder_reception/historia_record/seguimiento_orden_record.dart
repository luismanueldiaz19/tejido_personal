import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_reception/print_reception/print_item_orden.dart';
import 'package:tejidos/src/nivel_2/folder_reception/screen_detalles_entregas.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

import '../../folder_planificacion/model_planificacion/planificacion_last.dart';

class SeguimientoOrdenRecord extends StatefulWidget {
  const SeguimientoOrdenRecord({super.key, required this.item});
  final PlanificacionLast item;

  @override
  State<SeguimientoOrdenRecord> createState() => _SeguimientoOrdenRecordState();
}

class _SeguimientoOrdenRecordState extends State<SeguimientoOrdenRecord> {
  List<PlanificacionItem> list = [];
  bool isEntrega = false;
  Future getSeguimiento() async {
    final res = await httpRequestDatabase(selectProductoPlanificacionLastIdKey,
        {'is_key_product': widget.item.isKeyUniqueProduct.toString()});
    // print(res.body);
    list = planificacionItemFromJson(res.body);

    setState(() {});
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    await httpRequestDatabase(deleteProductoPlanificacionLast, {'id': '$id'});
    // print(res.body);
    list.removeWhere((item) => item.id == id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSeguimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Historial De Seguimiento de Orden'),
          list.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                      current: list, delete: (id) => eliminarOrden(id)),
                )
              : const Expanded(
                  child: Center(
                    child: Text('No hay Datos'),
                  ),
                ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  list.isNotEmpty
                      ? ElevatedButton.icon(
                          icon: const Icon(Icons.print),
                          onPressed: () async {
                            final pdfFile =
                                await PdfReportOrdenItem.generate(list);

                            PdfApi.openFile(pdfFile);
                          },
                          label: const Text('Imprimir'))
                      : const SizedBox()
                ],
              ))
        ],
      ),
    );
  }
}

class TableModifica extends StatelessWidget {
  const TableModifica({Key? key, this.current, required this.delete})
      : super(key: key);
  final List<PlanificacionItem>? current;
  final Function delete;

  Color getColor(PlanificacionItem planificacion) {
    if (planificacion.isDone == 'f') {
      return comparaTime(DateTime.parse(planificacion.fechaEnd ?? ''))
          ? Colors.white
          : Colors.red.shade100;
    } else if (planificacion.isDone == 't') {
      return Colors.green.shade100;
    } else {
      // Si ninguna de las condiciones anteriores se cumple, se devuelve el color blanco como predeterminado.
      return Colors.white;
    }
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
                inside: const BorderSide(
                    style: BorderStyle.solid, color: Colors.grey)),
            columns: const [
              DataColumn(label: Text('Departamento')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Num Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cant')),
              DataColumn(label: Text('Comentario')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(Text(item.department ?? '')),
                      DataCell(Text(item.statu ?? '')),
                      DataCell(Row(
                        children: [
                          Text(item.numOrden ?? ''),
                          TextButton(
                            child: const Text(
                              'Ver',
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (conext) => DetallesEntrega(
                                    currentLocal: item,
                                  ),
                                ),
                              );
                            },
                          ),
                          currentUsers?.occupation == OptionAdmin.master.name ||
                                  currentUsers?.occupation ==
                                      OptionAdmin.admin.name
                              ? TextButton(
                                  onPressed: () => delete(item.id),
                                  child: const Text('Eliminar'))
                              : const SizedBox()
                        ],
                      )),
                      DataCell(Text(item.ficha ?? '')),
                      DataCell(Text(item.nameLogo ?? '')),
                      DataCell(Text(item.tipoProduct ?? '')),
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
                                  color: Colors.red,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),

                      // DataCell(Row(
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //         builder: (conext) =>
                      //         //             DetallesEntrega(currentLocal: item)));
                      //       },
                      //       child: Text(item.ficha ?? ''),
                      //     ),
                      //     item.ficha == 'Verificado'
                      //         ? const Text(
                      //             'Listo',
                      //             style: TextStyle(color: Colors.green),
                      //           )
                      //         : const SizedBox()
                      //   ],
                      // )),
                      // DataCell(Text(item.ficha ?? '')),
                      // DataCell(Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 150,
                      //       child: Tooltip(
                      //         message: item.nameLogo ?? '',
                      //         child: Text(
                      //           item.nameLogo ?? '',
                      //           overflow: TextOverflow.ellipsis,
                      //           maxLines: 1,
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     item.isEntregado == 't'
                      //         ? const Text(
                      //             // 'Entregado',

                      //             'Entregado',
                      //             style: TextStyle(color: Colors.green),
                      //           )
                      //         : const Text(
                      //             'Falta Entregar',
                      //             style: TextStyle(color: Colors.red),
                      //           ),
                      //     const SizedBox(width: 5),
                      //     item.isEntregado == 't'
                      //         ? const Icon(
                      //             Icons.shopping_cart_outlined,
                      //             color: Colors.green,
                      //             size: 15,
                      //           )
                      //         : const SizedBox()
                      //   ],
                      // )),
                      // DataCell(Text(item.cliente ?? '')),
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

// // Comparamos las fechas
  // if (time1.isAfter(soloFecha)) {
  //   print('Ya se cumplio la fecha');
  //   print(true);
  //   return true;
  // }
  // return false;
}
