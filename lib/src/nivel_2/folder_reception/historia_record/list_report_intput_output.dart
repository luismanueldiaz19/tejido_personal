import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_reception/historia_record/register.dart';
import 'package:tejidos/src/widgets/loading.dart';

import '../../../widgets/pick_range_date.dart';

class ListReportInputOutPut extends StatefulWidget {
  const ListReportInputOutPut({super.key});

  @override
  State<ListReportInputOutPut> createState() => _ListReportInputOutPutState();
}

class _ListReportInputOutPutState extends State<ListReportInputOutPut> {
  List<Register> listRecord = [];
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ResumeRegister> listResumen = [];
  @override
  void initState() {
    super.initState();
    getRecord();
  }

  Future getRecord() async {
    setState(() {
      listRecord.clear();
      listResumen.clear();
    });
    final res = await httpRequestDatabase(
        selectReportEntradaSalidaReceptionByDate,
        {'date1': firstDate, 'date2': secondDate});
    setState(() {
      listRecord = registerFromJson(res.body);
      getResume();
    });
  }

  depurarTipoTrabajos(List<Register> list) {
    Set<String> objectoSet =
        list.map((element) => element.userRegister!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  getResume() {
    var listEmpleado = depurarTipoTrabajos(listRecord);
    String entrada = 'Entradas';
    String salida = 'Salidas';

    for (var empleado in listEmpleado) {
      var totalRegisted = listRecord
          .where((element) =>
              element.userRegister == empleado &&
              element.statu?.toUpperCase() == entrada.toUpperCase())
          .toList();
      var totalDelivery = listRecord
          .where((element) =>
              element.userRegister == empleado &&
              element.statu?.toUpperCase() == salida.toUpperCase())
          .toList();

      print(
          'Empleado :  $empleado - Regitrado : ${totalRegisted.length} - Entregado : ${totalDelivery.length}');

      listResumen.add(ResumeRegister(
        empleado: empleado,
        entradas: '${totalRegisted.length}',
        salidas: '${totalDelivery.length}',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas y Salidas Ordenes'),
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                firstDate = date1;
                secondDate = date2;
              });
              getRecord();
            },
          ),
          const SizedBox(height: 25),
          listResumen.isEmpty
              ? const Expanded(child: Loading(text: 'Cargando ...'))
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        border: TableBorder.symmetric(
                            outside: BorderSide(
                                color: Colors.grey.shade100,
                                style: BorderStyle.none),
                            inside: const BorderSide(
                                style: BorderStyle.solid, color: Colors.grey)),
                        columns: const [
                          DataColumn(
                              label: SizedBox(
                                  width: 150, child: Text('Empleado'))),
                          DataColumn(label: Text('Registradas')),
                          DataColumn(label: Text('Entregada a Clientes')),
                        ],
                        rows: listResumen
                            .map((item) => DataRow(cells: [
                                  DataCell(Text(item.empleado ?? 'N/A')),
                                  DataCell(Center(
                                      child: Text(item.entradas ?? 'N/A'))),
                                  DataCell(Center(
                                      child: Text(item.salidas ?? 'N/A'))),
                                ]))
                            .toList(),
                      ),
                    ),
                  ),
                ),
          listResumen.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  child: SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BounceInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                  'Empleado : ${depurarTipoTrabajos(listRecord).length}',
                                  style: style.bodySmall),
                            ),
                          ),
                          BounceInDown(
                            duration: const Duration(milliseconds: 700),
                            child: Container(
                                height: 35,
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                child: Text(
                                    'Registradas :  ${ResumeRegister().getTotalEntradas(listResumen)}',
                                    style: style.bodySmall)),
                          ),
                          // var cantPuntada = BordadoResumen.calcularTotalPuntada(items);
                          BounceInDown(
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                  'Entregado :  ${ResumeRegister().getTotalSalidas(listResumen)}',
                                  style: style.bodySmall),
                            ),
                          ),
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
