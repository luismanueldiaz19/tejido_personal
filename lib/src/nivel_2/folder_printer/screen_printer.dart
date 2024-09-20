import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import 'package:tejidos/src/nivel_2/folder_printer/add_main_printer_work.dart';
import 'package:tejidos/src/nivel_2/folder_printer/add_work_printer.dart';
import 'package:tejidos/src/nivel_2/folder_printer/details_printer_ordenes.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/main_work_printer.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/model_tipe_work.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/add_thing.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'model_printer/printer_machine.dart';

class ScreenPrinter extends StatefulWidget {
  const ScreenPrinter({Key? key}) : super(key: key);

  @override
  State<ScreenPrinter> createState() => _ScreenPrinterState();
}

class _ScreenPrinterState extends State<ScreenPrinter> {
  List<MachinePrinter> listMachine = [];
  List<TypeWorkPrinter> listTypeWork = [];
  List<MainWorkPrint> listMainWork = [];
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  // List<MachinePrint> listLocal = MachinePrint().listMachine;

  Future getMachinePrint() async {
    // select_printer_machine
    String selectPrinterMachine =
        "http://$ipLocal/settingmat/admin/select/select_printer_machine.php";
    final res =
        await httpRequestDatabase(selectPrinterMachine, {'view': 'view'});
    listMachine = machinePrinterFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMachinePrint();
    getselectPrinterWorkMain();
    getPrinterTypeWork();
    // getRecord(firstDate, secondDate);
  }

  Future ontapProducion(MachinePrinter machine) async {
    // print('Hola ${machine.idPrinterMachine}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMainPrinterWork(idMachinePrinter: machine);
      },
    ).then((value) => {getselectPrinterWorkMain()});
  }

  Future deleteFrom(idWorkPrinter) async {
    // print('deleteFrom id : $id');
    String deletePrinterWorkMain =
        "http://$ipLocal/settingmat/admin/delete/delete_printer_work_main.php";
    // delete_printer_work_main
    await httpRequestDatabase(
        deletePrinterWorkMain, {'id_work_printer': idWorkPrinter});
    getselectPrinterWorkMain();
    // getRecord(firstDate, secondDate);
  }
//select_printer_type_work

  Future getPrinterTypeWork() async {
    setState(() {});
    String selectPrinterTypeWork =
        "http://$ipLocal/settingmat/admin/select/select_printer_type_work.php";
    final res =
        await httpRequestDatabase(selectPrinterTypeWork, {'view': 'view'});

    listTypeWork = typeWorkPrinterFromJson(res.body);
    // print(res.body);
  }

  Future getselectPrinterWorkMain() async {
    setState(() {});
    String selectPrinterWorkMain =
        "http://$ipLocal/settingmat/admin/select/select_printer_work_main.php";
    final res =
        await httpRequestDatabase(selectPrinterWorkMain, {'view': 'view'});

    listMainWork = mainWorkPrintFromJson(res.body);
    setState(() {});
  }

  Future agregarTrabajo(MainWorkPrint item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWorkPrinter(listTypeWork: listTypeWork, mainWork: item);
      },
    );
    getselectPrinterWorkMain();
  }

  Future updateWaste(id) async {
    final res = await showDialog(
        context: context,
        builder: (context) {
          return const AddThing(
            hintText: 'Cantidad',
            title: 'Reportar Desperdicios',
          );
        });
    if (res != null) {
      await httpRequestDatabase(updatePrinterWorkMainWaste, {
        'id': id,
        'waste': res.toString(),
      });
      getselectPrinterWorkMain();
    }
  }

  Future terminarWorked(item) async {
    // print(item);
    // update_printer_work_main_finished
    String updatePrinterWorkMainFinished =
        "http://$ipLocal/settingmat/admin/update/update_printer_work_main_finished.php";
    final res = await httpRequestDatabase(updatePrinterWorkMainFinished, {
      'id': item,
      'is_finished': 't',
      'second_date': DateTime.now().toString().substring(0, 19)
    });
    print(res.body);

    getselectPrinterWorkMain();

    // getRecord(firstDate, secondDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Trabajos Actuales'),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 50),
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Hero(
                    tag: 'printer',
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month,
                              size: 30, color: Colors.white),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              'Add Trabajos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: fontBalooPaaji),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: listMachine
                            .map(
                              (machine) => ZoomIn(
                                child: CardMachine(
                                  machine: machine,
                                  ontap: () => ontapProducion(machine),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          listMainWork.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listMainWork,
                    onPressDesperdicios: (id) => updateWaste(id),
                    pressDelete: (idWorkPrinter) => deleteFrom(idWorkPrinter),
                    agregarTrabajo: (MainWorkPrint item) =>
                        agregarTrabajo(item),
                    terminarWork: (item) => terminarWorked(item),
                  ),
                )
              : const Center(child: Text('No hay datos')),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 30),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       // ElevatedButton(
          //       //     onPressed: () {}, child: const Text('Agregar Trabajos')),
          //       ElevatedButton(onPressed: () {}, child: const Text('Imprimir')),
          //     ],
          //   ),
          // ),
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
      required this.terminarWork,
      required this.onPressDesperdicios})
      : super(key: key);
  final List<MainWorkPrint>? current;
  final Function pressDelete;
  final Function agregarTrabajo;
  final Function terminarWork;
  final Function onPressDesperdicios;

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
              DataColumn(label: Text('Action')),
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
                      DataCell(TextButton(
                          onPressed: () => onPressDesperdicios(item.id),
                          child: Text('${item.wasteDimensionCm ?? ''} cm'))),
                      DataCell(
                        Row(
                          children: [
                            TextButton(
                              child: const Text('Ver'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (conext) =>
                                            DetailsPrinterOrdenes(item: item)));
                              },
                            ),
                            TextButton(
                              child: const Text('Agregar'),
                              onPressed: () => agregarTrabajo(item),
                            ),
                            TextButton(
                              child: const Text('Terminar',
                                  style: TextStyle(color: Colors.teal)),
                              onPressed: () => terminarWork(item.id),
                            ),
                            currentUsers?.occupation ==
                                        OptionAdmin.admin.name ||
                                    currentUsers?.occupation ==
                                        OptionAdmin.master.name
                                ? TextButton(
                                    child: const Text('Eliminar',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () =>
                                        pressDelete(item.idWorkPrinter),
                                  )
                                : const SizedBox()
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

class CardMachine extends StatelessWidget {
  const CardMachine({Key? key, this.machine, required this.ontap})
      : super(key: key);
  final MachinePrinter? machine;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: const Color.fromARGB(255, 74, 54, 46),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            machine!.numberMachine ?? 'N/A',
            style: TextStyle(color: Colors.white, fontFamily: fontBalooPaaji),
          ),
          GestureDetector(
            onTap: () => ontap(),
            child: const Icon(Icons.print_rounded, color: Colors.white),
          ),
          Text(
            machine!.fabricante ?? 'N/A',
            style: TextStyle(color: Colors.white, fontFamily: fontBalooPaaji),
          ),
        ],
      ),
    );
  }
}
