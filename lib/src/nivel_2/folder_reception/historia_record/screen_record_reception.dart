import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_reception/historia_record/seguimiento_orden_record.dart';
import 'package:tejidos/src/nivel_2/folder_reception/print_reception/print_reception_orden.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';
import '../../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../../folder_planificacion/url_planificacion/url_planificacion.dart';

class ScreenRecordReception extends StatefulWidget {
  const ScreenRecordReception({Key? key}) : super(key: key);

  @override
  State<ScreenRecordReception> createState() => _ScreenRecordReceptionState();
}

class _ScreenRecordReceptionState extends State<ScreenRecordReception> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getRecord('t', _firstDate, _secondDate);
  }

  List<PlanificacionLast> listRecord = [];
  List<PlanificacionLast> listRecordFilter = [];

  Future getRecord(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(selectPlanificacionLastRecordByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  Future getRecordByDelirery(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectPlanificacionLastRecordDeliveredByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  Future getRecordByDateCreated(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectPlanificacionLastRecordFechaStartByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  void _searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listRecordFilter = List.from(listRecord
          .where((x) =>
              x.cliente!.toUpperCase().contains(val.toUpperCase()) ||
              x.clienteTelefono!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.userEntregaOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.userRegistroOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
              x.ficha!.toUpperCase().contains(val.toUpperCase()))
          .toList());

      setState(() {});
    } else {
      listRecordFilter = [...listRecord];

      setState(() {});
    }
  }

///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    shomMjs(mjs) => utilShowMesenger(context, mjs);
    final res = await httpRequestDatabase(
        deleteProductoPlanificacionLastRecord, {'id': '$id'});
    // print(res.body);
    if (res.body.toString().contains('good')) {
      listRecordFilter.removeWhere((item) => item.id == id);
      setState(() {});
    } else {
      shomMjs('Tiene que eliminar los producto que existen de esta orden');
    }
  }

  bool isDelivered = false;
  bool isDateCreated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.only(top: 30, right: 16),
          child: const Text('Historial de Saquetas Entregadas'),
        ),
        leading: Container(
          margin: const EdgeInsets.only(top: 25, left: 16),
          child: const BackButton(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 25, right: 10),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listRecordFilter.isNotEmpty) {
                  final pdfFile = await PdfReceptionOrdenes.generate(
                      listRecordFilter, _firstDate, _secondDate, '0', '0');

                  PdfApi.openFile(pdfFile);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                    isDateCreated = false;
                    isDelivered = false;
                    getRecord('t', _firstDate, _secondDate);
                    setState(() {});
                  },
                  child: Text(_secondDate ?? 'N/A')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Entregada a la fecha'),
                  Checkbox(
                      value: isDelivered,
                      onChanged: (val) {
                        setState(() {
                          isDelivered = !isDelivered;
                          if (isDelivered) {
                            getRecordByDelirery('t', _firstDate, _secondDate);
                          } else {
                            getRecord('t', _firstDate, _secondDate);
                          }
                        });
                      })
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  const Text('Fecha Registradas'),
                  Checkbox(
                      value: isDateCreated,
                      onChanged: (val) {
                        setState(() {
                          isDateCreated = !isDateCreated;
                          if (isDateCreated) {
                            getRecordByDateCreated(
                                't', _firstDate, _secondDate);
                          }
                        });
                      })
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: FadeIn(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
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
          listRecordFilter.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listRecordFilter,
                    delete: (id) => eliminarOrden(id),
                  ),
                )
              : const Center(child: Text('No hay Datos')),
          listRecordFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
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
                                      const Text('TOTAL : '),
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
  const TableModifica({Key? key, this.current, required this.delete})
      : super(key: key);
  final List<PlanificacionLast>? current;
  final Function delete;

  // Color getColor(PlanificacionLast planificacion) {
  //   if (planificacion.isEntregado == 'f') {
  //     return comparaTime(DateTime.parse(planificacion.fechaEntrega ?? ''))
  //         ? Colors.white
  //         : Colors.red.shade100;
  //   } else if (planificacion.isEntregado == 't') {
  //     return Colors.green.shade100;
  //   } else {
  //     // Si ninguna de las condiciones anteriores se cumple, se devuelve el color blanco como predeterminado.
  //     return Colors.white;
  //   }
  // }

  Color getColor(PlanificacionLast planificacion) {
    if (planificacion.isEntregado == 't') {
      return Colors.green.shade100;
    } else {
      return comparaTime(DateTime.parse(planificacion.fechaEntrega ?? ''))
          ? Colors.white
          : Colors.red.shade100;
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
              DataColumn(label: Text('Created Orden')),
              DataColumn(label: Text('Numero Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Cliente Telefono')),
              DataColumn(label: Text('Fecha Creación')),
              DataColumn(label: Text('Fecha de entrega')),
              DataColumn(label: Text('Seguimiento')),
              DataColumn(label: Text('Entregador/a')),
              DataColumn(label: Text('Comment')),
              DataColumn(label: Text('Entrega Ficha')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(Text(item.userRegistroOrden ?? '')),
                      DataCell(Row(
                        children: [
                          Text(item.numOrden ?? ''),
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
                      DataCell(Text(item.cliente ?? '')),
                      DataCell(Text(item.clienteTelefono ?? '')),
                      DataCell(Text(item.fechaStart ?? '')),
                      DataCell(Text(item.fechaEntrega ?? '')),
                      DataCell(TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) =>
                                      SeguimientoOrdenRecord(item: item)));
                        },
                        child: const Text('CLICK!'),
                      )),
                      DataCell(Text(item.userEntregaOrden ?? '')),
                      DataCell(
                          SizedBox(
                            width: 100,
                            child: Text(
                              item.comment ?? '',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ), onTap: () {
                        utilShowMesenger(context, item.comment ?? '');
                      }),
                      DataCell(Text(item.dateDelivered ?? '')),
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

class MyDropdownMenu extends StatefulWidget {
  const MyDropdownMenu({super.key, required this.pressSearching});
  final Function pressSearching;

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String _selectedOption =
      'Pendientes y por Entregar'; // Opción seleccionada inicialmente

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue!;
          widget.pressSearching(_selectedOption);
        });
      },
      items: <String>[
        'Pendientes y por Entregar',
        'Entregadas',
        'Por Entregar',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
