import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';

import 'package:tejidos/src/nivel_2/folder_printer/model_printer/detail_print_orden.dart';
import 'package:tejidos/src/util/get_time_relation.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

class ScreenRecordPrinter extends StatefulWidget {
  const ScreenRecordPrinter({super.key});

  @override
  State<ScreenRecordPrinter> createState() => _ScreenRecordPrinterState();
}

class _ScreenRecordPrinterState extends State<ScreenRecordPrinter> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);

  List<DetailPrinterOrden> listDetails = [];
  List<DetailPrinterOrden> listDetailsFilter = [];

  Future getRecord(date1, date2) async {
    String selectPrinterWorkByDate =
        "http://$ipLocal/settingmat/admin/select/select_printer_work_by_date.php";
    final res = await httpRequestDatabase(
        selectPrinterWorkByDate, {'date1': date1, 'date2': date2});
    listDetails = detailPrinterOrdenFromJson(res.body);
    listDetailsFilter = [...listDetails];

    depurarTipoTrabajos(listDetailsFilter);
    calcularTotalPc(listDetailsFilter);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRecord(_firstDate, _secondDate);
  }

  var impresiones = 0;
  var dFull = 0;
  var dPKT = 0;
  calcularTotalPc(List<DetailPrinterOrden> list) {
    impresiones = 0;
    dFull = 0;
    dPKT = 0;
    for (var element in list) {
      impresiones += int.parse(element.cantImpr ?? '0');
      dFull += int.parse(element.pFull ?? '0');
      dPKT += int.parse(element.pkt ?? '0');
    }
  }

  List<String> tipoTrabajos = [];
  List<String> maquinaDepurado = [];
  List<String> empleadoDepurado = [];
  String chipTipoTrabajo = '';
  String chipMaquina = '';
  String chipEmpleado = '';
  ////aplicacion de filtro para sacar chip y presentarlo en la pantalla
  depurarTipoTrabajos(List<DetailPrinterOrden> list) {
    List<Map<String, dynamic>> lista = [];
    List<Map<String, dynamic>> listaMaquina = [];
    List<Map<String, dynamic>> listaEmpleado = [];

    for (var element in list) {
      lista.add({"tipo": element.tipeWorkPrinter, "id": element.id});
      listaMaquina
          .add({"number_machine": element.numberMachine, "id": element.id});
      listaEmpleado.add({"fullname": element.userRegisted, "id": element.id});
    }

    Set<String> familySet = <String>{};
    Set<String> familySetMachine = <String>{};
    Set<String> familySetEmpleado = <String>{};

    for (Map<String, dynamic> item in lista) {
      familySet.add(item['tipo']);
    }

    for (Map<String, dynamic> item in listaMaquina) {
      familySetMachine.add(item['number_machine']);
    }
    for (Map<String, dynamic> item in listaEmpleado) {
      familySetEmpleado.add(item['fullname']);
    }

    tipoTrabajos = familySet.toList();
    maquinaDepurado = familySetMachine.toList();
    empleadoDepurado = familySetEmpleado.toList();

    setState(() {});
  }

  List<DataRow> _buildRows(List<DetailPrinterOrden> list) {
    Map<String, double> sumByMachine = {};

    for (var item in list) {
      if (sumByMachine.containsKey(item.numberMachine)) {
        sumByMachine[item.numberMachine ?? ''] =
            sumByMachine[item.numberMachine]! +
                double.parse(item.cantImpr ?? '');
      } else {
        sumByMachine[item.numberMachine ?? ''] =
            double.parse(item.cantImpr ?? '');
      }
    }

    return sumByMachine.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(entry.value.toString())),
        // DataCell(Text(calcularBonche(entry.value.toString()))),
        // calcularBonche(String value)
      ]);
    }).toList();
  }

  List<DataRow> _buildEmpleadoImpresiones(List<DetailPrinterOrden> list) {
    Map<String, double> sumByMachine = {};

    for (var item in list) {
      if (sumByMachine.containsKey(item.userRegisted)) {
        sumByMachine[item.userRegisted ?? ''] =
            sumByMachine[item.userRegisted]! +
                double.parse(item.cantImpr ?? '');
      } else {
        sumByMachine[item.userRegisted ?? ''] =
            double.parse(item.cantImpr ?? '');
      }
    }

    return sumByMachine.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(entry.value.toString())),
        // DataCell(Text(calcularBonche(entry.value.toString()))),
        // calcularBonche(String value)
      ]);
    }).toList();
  }

  List<DataRow> _buildRowsFull(List<DetailPrinterOrden> list) {
    Map<String, double> sumByMachine = {};

    for (var item in list) {
      if (sumByMachine.containsKey(item.numberMachine)) {
        sumByMachine[item.numberMachine ?? ''] =
            sumByMachine[item.numberMachine]! + double.parse(item.pFull ?? '');
      } else {
        sumByMachine[item.numberMachine ?? ''] = double.parse(item.pFull ?? '');
      }
    }

    return sumByMachine.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(entry.value.toString())),
        // DataCell(Text(calcularBonche(entry.value.toString()))),
        // calcularBonche(String value)
      ]);
    }).toList();
  }

  List<DataRow> _buildRowsPKT(List<DetailPrinterOrden> list) {
    Map<String, double> sumByMachine = {};

    for (var item in list) {
      if (sumByMachine.containsKey(item.numberMachine)) {
        sumByMachine[item.numberMachine ?? ''] =
            sumByMachine[item.numberMachine]! + double.parse(item.pkt ?? '');
      } else {
        sumByMachine[item.numberMachine ?? ''] = double.parse(item.pkt ?? '');
      }
    }

    return sumByMachine.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(entry.value.toString())),
        // DataCell(Text(calcularBonche(entry.value.toString()))),
        // calcularBonche(String value)
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Historial Printer'),
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
                    setState(() {});
                    getRecord(_firstDate, _secondDate);
                  },
                  child: Text(_secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),
          Expanded(
            child: TableModifica(
              current: listDetailsFilter,
              pressDelete: () {
                // getTirada();
              },
              updateTirada: () {
                // getTirada();
              },
            ),
          ),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dataRowMaxHeight: 25,
                            dataRowMinHeight: 15,
                            headingRowHeight: 25,
                            dataTextStyle: const TextStyle(color: Colors.brown),
                            border: TableBorder.all(
                              style: BorderStyle.none,
                              borderRadius: BorderRadius.circular(1.0),
                              color: Colors.grey,
                            ),
                            columns: const [
                              DataColumn(label: Text('Máquina')),
                              DataColumn(label: Text('Cant Impr.')),
                            ],
                            rows: _buildRows(listDetailsFilter),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 300,
                      child: SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: DataTable(
                              dataRowMaxHeight: 25,
                              dataRowMinHeight: 15,
                              headingRowHeight: 25,
                              dataTextStyle:
                                  const TextStyle(color: Colors.brown),
                              border: TableBorder.all(
                                style: BorderStyle.none,
                                borderRadius: BorderRadius.circular(1.0),
                                color: Colors.grey,
                              ),
                              columns: const [
                                DataColumn(label: Text('Empleados')),
                                DataColumn(label: Text('Cant Impr.')),
                              ],
                              rows:
                                  _buildEmpleadoImpresiones(listDetailsFilter),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dataRowMaxHeight: 25,
                            dataRowMinHeight: 15,
                            headingRowHeight: 25,
                            dataTextStyle: const TextStyle(color: Colors.brown),
                            border: TableBorder.all(
                              style: BorderStyle.none,
                              borderRadius: BorderRadius.circular(1.0),
                              color: Colors.grey,
                            ),
                            columns: const [
                              DataColumn(label: Text('Máquina')),
                              DataColumn(label: Text('FUll')),
                            ],
                            rows: _buildRowsFull(listDetailsFilter),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dataRowMaxHeight: 25,
                            dataRowMinHeight: 15,
                            headingRowHeight: 25,
                            dataTextStyle: const TextStyle(color: Colors.brown),
                            border: TableBorder.all(
                              style: BorderStyle.none,
                              borderRadius: BorderRadius.circular(1.0),
                              color: Colors.grey,
                            ),
                            columns: const [
                              DataColumn(label: Text('Máquina')),
                              DataColumn(label: Text('PKT')),
                            ],
                            rows: _buildRowsPKT(listDetailsFilter),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 75,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    children: tipoTrabajos
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                chipTipoTrabajo = e;
                                listDetailsFilter = List.from(listDetails
                                    .where((x) => x.tipeWorkPrinter!
                                        .toUpperCase()
                                        .contains(
                                            chipTipoTrabajo.toUpperCase()))
                                    .toList());
                                calcularTotalPc(listDetailsFilter);
                                setState(() {});
                              },
                              child: Chip(
                                deleteIcon:
                                    const Icon(Icons.close, color: Colors.red),
                                onDeleted: chipTipoTrabajo == e
                                    ? () {
                                        chipTipoTrabajo = '';
                                        listDetailsFilter =
                                            List.from(listDetails);
                                        calcularTotalPc(listDetailsFilter);
                                        setState(() {});
                                      }
                                    : null,
                                label: Text(
                                  e,
                                  style: chipTipoTrabajo == e
                                      ? const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Wrap(
                    children: maquinaDepurado
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                chipMaquina = e;
                                listDetailsFilter = List.from(listDetails
                                    .where((x) => x.numberMachine!
                                        .toUpperCase()
                                        .contains(chipMaquina.toUpperCase()))
                                    .toList());
                                calcularTotalPc(listDetailsFilter);
                                setState(() {});
                                // searchingChip(e);
                              },
                              child: Chip(
                                deleteIcon:
                                    const Icon(Icons.close, color: Colors.red),
                                onDeleted: chipMaquina == e
                                    ? () {
                                        chipMaquina = '';
                                        listDetailsFilter =
                                            List.from(listDetails);
                                        calcularTotalPc(listDetailsFilter);
                                        setState(() {});
                                      }
                                    : null,
                                label: Text(
                                  e,
                                  style: chipMaquina == e
                                      ? const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Wrap(
                    children: empleadoDepurado
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                chipEmpleado = e;
                                listDetailsFilter = List.from(listDetails
                                    .where((x) => x.userRegisted!
                                        .toUpperCase()
                                        .contains(chipEmpleado.toUpperCase()))
                                    .toList());
                                calcularTotalPc(listDetailsFilter);
                                setState(() {});
                                // searchingChip(e);
                              },
                              child: Chip(
                                deleteIcon:
                                    const Icon(Icons.close, color: Colors.red),
                                onDeleted: chipEmpleado == e
                                    ? () {
                                        chipEmpleado = '';
                                        listDetailsFilter =
                                            List.from(listDetails);
                                        calcularTotalPc(listDetailsFilter);
                                        setState(() {});
                                      }
                                    : null,
                                label: Text(
                                  e,
                                  style: chipEmpleado == e
                                      ? const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total Impresiones : $impresiones'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Total Full : $dFull',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    'Total PKT : $dPKT',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
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
              DataColumn(label: Text('Maquina')),
              DataColumn(label: Text('Registro')),
              DataColumn(label: Text('Num.Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Papel Cm')),
              DataColumn(label: Text('Desperdicios Cm')),
              DataColumn(label: Text('Cant Impr.')),
              DataColumn(label: Text('Full')),
              DataColumn(label: Text('PKT')),
              DataColumn(label: Text('Trabajo')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Comment')),
              DataColumn(label: Text('Fecha')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(Text(item.numberMachine ?? '')),
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

                      DataCell(Text(item.numOrden ?? '')),
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
                      DataCell(Text(item.dimensionCm ?? '')),
                      DataCell(Text(item.wasteDimensionCm ?? '')),
                      DataCell(
                        TextButton(
                          child: Text(item.cantImpr ?? ''),
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return DialogUpdateDetails(item: item);
                            //   },
                            // ).then((value) => {updateTirada()});
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
                      // DataCell(
                      //   Text(
                      //     item.dateStart ?? '',
                      //     style: const TextStyle(
                      //       color: Colors.green,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      // DataCell(
                      //   Text(
                      //     item.dateEnd ?? '',
                      //     style: const TextStyle(
                      //       color: Colors.red,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
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
                                child:
                                    Text(item.comment ?? 'N/A', style: style)),
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
                      DataCell(Text(item.date ?? '')),
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
