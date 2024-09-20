import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_bordado/bordado_orden_main/dialog_insert_tirada.dart';
import 'package:tejidos/src/nivel_2/folder_bordado/model/bordoda_tirada.dart';
import 'package:tejidos/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_printer/add_comment_dialog.dart';
import 'package:tejidos/src/nivel_2/folder_printer/dialog_updated.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/detail_print_orden.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/main_work_printer.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

import '../../datebase/methond.dart';
import '../../util/get_time_relation.dart';
import '../folder_planificacion/model_planificacion/item_planificacion.dart';

class DetailsPrinterOrdenes extends StatefulWidget {
  const DetailsPrinterOrdenes({super.key, required this.item});
  final MainWorkPrint item;

  @override
  State<DetailsPrinterOrdenes> createState() => _DetailsPrinterOrdenesState();
}

class _DetailsPrinterOrdenesState extends State<DetailsPrinterOrdenes> {
  List<DetailPrinterOrden> listDetails = [];
  bool isEntrega = false;
  late TextEditingController comment;
  late TextEditingController canMala;
  int totalElaborated = 0;
  int totalCantBad = 0;

  Future getTirada() async {
    //select_printer_work
    String selectPrinterWork =
        "http://$ipLocal/settingmat/admin/select/select_printer_work.php";
    final res = await httpRequestDatabase(selectPrinterWork,
        {'id_work_printer': widget.item.idWorkPrinter.toString()});
    // print('Segumiento the Printer ${res.body}');
    listDetails = detailPrinterOrdenFromJson(res.body);
    setState(() {});
  }

  Future updateFromComment(id, comment) async {
    await httpRequestDatabase(
        updateBordadoReportedComment, {'id': id, 'comment': comment});
    // print(res.body);
  }

  Future deleteFrom(id) async {
    // delete_printer_work
    String deletePrinterWork =
        "http://$ipLocal/settingmat/admin/delete/delete_printer_work.php";
    // delete_printer_work_main
    await httpRequestDatabase(deletePrinterWork, {'id': id});
    listDetails.remove(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    canMala = TextEditingController();
    getTirada();
  }

  bool isLoading = false;

  // Future sendTirada(data) async {
  //   await httpRequestDatabase(insertBordadoTirada, data);
  //   getTirada();
  // }

  Future updateDatedEnd(BordadoTirada item) async {
    var commment =
        '${item.comment} :  Modificado Por ${currentUsers?.fullName}';
    await httpRequestDatabase(updatedBordadoEndDate, {
      'id': item.id,
      'fecha_end': DateTime.now().toString().substring(0, 19),
      'comment': commment,
    });
    // print(res.body);
    getTirada();
  }

  Future updateCanUpdate(id, cantElaborado, cantBad) async {
    await httpRequestDatabase(updateCantElaboredCanElabored, {
      'id': '$id',
      'cant_elabored': '$cantElaborado',
      'cant_bad': '$cantBad'
    });
    // print('Comment  Reponse:  ${res.body}');
  }

  void updateCandBad(id) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return const AddTiradaDialog();
      },
    );

    if (result != null) {
      var cantElabored = result['cant_elabored'];
      var cantBad = result['cant_bad'];

      int totalOrdenCan = totalElaborated + int.parse(cantElabored);

      if (totalOrdenCan <= int.parse(widget.item.idWorkPrinter ?? '0')) {
        await httpRequestDatabase(updateBordadoReportedCanBad, {
          'id': '$id',
          'cant_bad': '$cantBad',
          'cant_elabored': '$cantElabored'
        });
        getTirada();
      } else {
        if (mounted) {
          utilShowMesenger(context, 'Sobre pasa la cantidad de la orden ',
              title: 'Aviso');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Seguimientos de Impreciones'),
          Expanded(
            child: TableModifica(
              current: listDetails,
              pressDelete: (id) {
                deleteFrom(id);
                getTirada();
              },
              updateTirada: () {
                // print('Actualizar Tiradas');
                getTirada();
              },
            ),
          ),
        ],
      ),
    );
  }

  void validadListaTerminada(List<PlanificacionItem> listLocal) {
    bool allItemsAreDone = listLocal.every((item) => item.isDone == 't');
    if (allItemsAreDone) {
      // Todos los elementos están marcados como "hecho" (isDone = 't')
      //    print('Todos los elementos están hechos.');
      setState(() {
        isEntrega = true;
      });
    } else {
      // Al menos un elemento no está marcado como "hecho" (isDone = 'f')
      //    print('Al menos un elemento no está hecho.');
      setState(() {
        isEntrega = false;
      });
    }
  }

  Future terminarWorkedGeneral() async {
    // print(widget.item.comment);
    String comentLocal = widget.item.idWorkPrinter.toString();
    if (comentLocal == 'N/A') {
      comentLocal =
          'Se Terminó A la ( ${DateTime.now().toString().substring(0, 19)} )';
    } else {
      comentLocal =
          '${widget.item.idWorkPrinter}, Se Terminó A la ( ${DateTime.now().toString().substring(0, 19)} )';
    }
    var dataSend = {
      'fecha_general_end': DateTime.now().toString().substring(0, 19),
      'is_finished': 't',
      'is_pause': 'f',
      'comment': comentLocal,
      'id': widget.item.id,
    };

    await httpRequestDatabase(updateBordadoReportedTerminar, dataSend);
    // print('terminar ${res.body}');
    if (mounted) {
      Navigator.pop(context);
    }
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOTirada(id) async {
    await httpRequestDatabase(deleteBordadoTirada, {'id': '$id'});

    listDetails.removeWhere((item) => item.id == id);
    getTirada();
  }
}

Future statuMethond(PlanificacionItem? current, {required String statu}) async {
  var data = {
    'id': current?.isKeyUniqueProduct,
    'statu': statu,
  };
  final res = await httpRequestDatabase(updatePlanificacionLastStatu, data);
  // print(res.body);
  if (res.body.toString() == 'good') {}
}

class TableModifica extends StatelessWidget {
  const TableModifica(
      {Key? key,
      this.current,
      required this.pressDelete,
      required this.updateTirada})
      : super(key: key);
  final List<DetailPrinterOrden>? current;
  final Function pressDelete;
  final Function updateTirada;

  Color getColor(DetailPrinterOrden tirada) {
    if (tirada.id == onProducion) {
      return Colors.cyan.shade100;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(overflow: TextOverflow.ellipsis);
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 1),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
              DataColumn(label: Text('Registro')),
              DataColumn(label: Text('Num.Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Cant Impr.')),
              DataColumn(label: Text('Full')),
              DataColumn(label: Text('PKT')),
              DataColumn(label: Text('Trabajo')),
              DataColumn(label: Text('Started')),
              DataColumn(label: Text('End')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Comment')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(
                        SizedBox(
                            width: 100,
                            child:
                                Text(item.userRegisted ?? 'N/A', style: style)),
                        onTap: () {
                          utilShowMesenger(context, item.userRegisted ?? 'N/A',
                              title: 'Registrado por:');
                        },
                      ),
                      DataCell(Row(
                        children: [
                          Text(item.numOrden ?? ''),
                          IconButton(
                              onPressed: () {
                                pressDelete(item.id);
                              },
                              icon: const Icon(Icons.close,
                                  color: Colors.red, size: 15))
                        ],
                      )),
                      DataCell(Text(item.ficha ?? '')),
                      DataCell(
                        SizedBox(
                            width: 100,
                            child: Text(item.logo ?? 'N/A', style: style)),
                        onTap: () {
                          utilShowMesenger(context, item.logo ?? 'N/A',
                              title: 'LOGO');
                        },
                      ),
                      DataCell(
                        TextButton(
                          child: Text(item.cantImpr ?? ''),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogUpdateDetails(item: item);
                              },
                            ).then((value) => {updateTirada()});
                          },
                        ),
                      ),
                      DataCell(Text(item.pFull ?? '')),
                      DataCell(Text(item.pkt ?? '')),
                      DataCell(
                        SizedBox(
                            width: 100,
                            child: Text(item.tipeWorkPrinter ?? 'N/A',
                                style: style)),
                        onTap: () {
                          utilShowMesenger(
                              context, item.tipeWorkPrinter ?? 'N/A',
                              title: 'Tipo de trabajo');
                        },
                      ),
                      DataCell(
                        Text(
                          item.dateStart ?? '',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          item.dateEnd ?? '',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          getTimeRelation(
                              item.dateStart ?? 'N/A', item.dateEnd ?? 'N/A'),
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            SizedBox(
                                width: 100,
                                child: TextButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AddComentDialog(item: item);
                                        },
                                      ).then((value) => {updateTirada()});
                                    },
                                    child: Text(item.comment ?? 'N/A',
                                        style: style))),
                            TextButton(
                                onPressed: () {
                                  utilShowMesenger(
                                      context, item.comment ?? 'N/A',
                                      title: 'Comentario');
                                },
                                child: const Text('Ver')),
                          ],
                        ),
                      ),
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
