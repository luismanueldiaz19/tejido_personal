import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_printer/details_printer_ordenes.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/main_work_printer.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

class ScreenDesperdicios extends StatefulWidget {
  const ScreenDesperdicios({super.key});

  @override
  State<ScreenDesperdicios> createState() => _ScreenDesperdiciosState();
}

class _ScreenDesperdiciosState extends State<ScreenDesperdicios> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<MainWorkPrint> listMainWork = [];
  List<MainWorkPrint> listMainWorkFilter = [];

  @override
  void initState() {
    super.initState();
    getMainWork();
  }

  int totalPapel = 0;
  int totalPapelWaste = 0;
  List<String> machineChip = [];

  Future getMainWork() async {
    //select_printer_work_main_by_date
    String selectPrinterWorkMainByDate =
        "http://$ipLocal/settingmat/admin/select/select_printer_work_main_by_date.php";
    // select_atencion_cliente_diseno_by_date
    final res = await httpRequestDatabase(selectPrinterWorkMainByDate,
        {'date1': firstDate, 'date2': secondDate, 'is_finished': 't'});
    listMainWork = mainWorkPrintFromJson(res.body);
    listMainWorkFilter = [...listMainWork];
    calcular(listMainWorkFilter);
    depurarTipoTrabajos(listMainWork);
    print(res.body);
    // listAtencionFilter = [...listAtencion];
    setState(() {});
  }

  String numberMachineChip = '';
////aplicacion de filtro para sacar chip y presentarlo en la pantalla
  depurarTipoTrabajos(List<MainWorkPrint> list) {
    List<Map<String, dynamic>> machine = [];

    for (var element in list) {
      machine.add({"machine": element.numberMachine, "id": element.id});
    }

    Set<String> familySet = <String>{};

    for (Map<String, dynamic> item in machine) {
      familySet.add(item['machine']);
    }

    machineChip = familySet.toList();

    setState(() {});
    // print(saboresList); // ["BLACK SWEET", "DIAMOND"]
  } // ["BLACK SWEET", "DIAMOND"]

  void calcular(List<MainWorkPrint> list) {
    totalPapel = 0;
    totalPapelWaste = 0;
    for (var element in list) {
      totalPapel += int.parse(element.dimensionCm ?? '0');
      totalPapelWaste += int.parse(element.wasteDimensionCm ?? '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Historial Desperdicios'),
          Hero(
            tag: 'Despedicios',
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red.shade500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'Historial',
                      style: TextStyle(
                          color: Colors.white, fontFamily: fontBalooPaaji),
                    ),
                  ),
                  const Icon(Icons.border_bottom, color: Colors.white),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'Despedicios',
                      style: TextStyle(
                          color: Colors.white, fontFamily: fontBalooPaaji),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    firstDate = dateee.toString();
                    // print(_firstDate);
                    setState(() {});
                  },
                  child: Text(firstDate ?? 'N/A')),
              const SizedBox(width: 20),
              const Text('Entre', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    secondDate = dateee.toString();
                    getMainWork();
                    setState(() {});
                  },
                  child: Text(secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),
          listMainWorkFilter.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listMainWorkFilter,
                    pressDelete: (id) => {},
                    agregarTrabajo: (MainWorkPrint item) {},
                    terminarWork: (item) => {},
                  ),
                )
              : const Center(child: Text('No hay datos')),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Papel : $totalPapel'),
                const SizedBox(width: 25),
                Text('Total Desperdicios : $totalPapelWaste')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Wrap(
              children: machineChip
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          numberMachineChip = e;
                          listMainWorkFilter = List.from(listMainWork
                              .where((x) => x.numberMachine!
                                  .toUpperCase()
                                  .contains(numberMachineChip.toUpperCase()))
                              .toList());
                          calcular(listMainWorkFilter);
                          setState(() {});
                        },
                        child: Chip(
                          deleteIcon:
                              const Icon(Icons.close, color: Colors.red),
                          onDeleted: numberMachineChip == e
                              ? () {
                                  numberMachineChip = '';
                                  listMainWorkFilter = List.from(listMainWork);
                                  calcular(listMainWorkFilter);
                                  setState(() {});
                                }
                              : null,
                          label: Text(
                            e,
                            style: numberMachineChip == e
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
          ),
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
      required this.agregarTrabajo,
      required this.terminarWork})
      : super(key: key);
  final List<MainWorkPrint>? current;
  final Function pressDelete;
  final Function agregarTrabajo;
  final Function terminarWork;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(overflow: TextOverflow.ellipsis);
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
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Printer')),
              DataColumn(label: Text('Detalles')),
              DataColumn(label: Text('Papel Cm')),
              DataColumn(label: Text('Desperdicios Cm')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    selected: true,
                    color: MaterialStateProperty.resolveWith(
                        (states) => Colors.white),
                    cells: [
                      DataCell(Text(item.idWorkPrinter ?? '')),
                      DataCell(Text(item.numberMachine ?? '')),
                      DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                                '${item.fabricante} - ${item.modelo} - ${item.tipo}',
                                style: style),
                          ), onTap: () {
                        utilShowMesenger(context,
                            '${item.fabricante} - ${item.modelo} - ${item.tipo}',
                            title: 'Detalles');
                      }),
                      DataCell(Text('${item.dimensionCm ?? ''} cm')),
                      DataCell(Text(item.wasteDimensionCm ?? '')),
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
