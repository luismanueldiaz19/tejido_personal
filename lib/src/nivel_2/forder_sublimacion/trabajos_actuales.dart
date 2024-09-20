import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_class/list_work.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima_list_actuales.dart';

import 'package:tejidos/src/nivel_2/forder_sublimacion/sublima_record.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import 'package:tejidos/src/widgets/custom_app_bar.dart';

class TrabajosActuales extends StatefulWidget {
  const TrabajosActuales({Key? key, required this.current}) : super(key: key);
  final Department current;

  @override
  State<TrabajosActuales> createState() => _TrabajosActualesState();
}

class _TrabajosActualesState extends State<TrabajosActuales> {
  List<ListWork> listWork = [];
  List<ListWork> listWorkFilter = [];

  @override
  void initState() {
    super.initState();

    getListWork();
  }

  Future deleteFromListSublimacion(ListWork current) async {
    await httpRequestDatabase(deleteListWorkSublimacion, {'id': current.id});
    // print(res.body);
    getListWork();
  }

  final Map<String, List<ListWork>> groupedItems = {};

  Future getListWork() async {
    final res =
        await httpRequestDatabase(selectListWorkSublimacion, {'view': 'view'});

    // print(res.body);
    listWork = listWorkFromJson(res.body);
    listWorkFilter = [...listWork];
    setState(() {});
    for (final jsonData in listWork) {
      final idKey = jsonData.idKeyWork as String;
      final item = ListWork(
        id: jsonData.id as String,
        cantOrden: jsonData.cantOrden as String,
        cantPieza: jsonData.cantPieza as String,
        code: jsonData.code as String,
        dateEnd: jsonData.dateEnd as String,
        dateStart: jsonData.dateStart as String,
        ficha: jsonData.ficha as String,
        fullName: jsonData.fullName as String,
        idDepart: jsonData.idDepart as String,
        idKeyWork: jsonData.idKeyWork as String,
        nameDepartment: jsonData.nameDepartment as String,
        nivel: jsonData.nivel as String,
        nameLogo: jsonData.nameLogo as String,
        occupation: jsonData.occupation as String,
        ordenend: jsonData.ordenend as String,
        ordenstarted: jsonData.ordenstarted as String,
        statu: jsonData.statu as String,
        typeWork: jsonData.typeWork as String,
        numOrden: jsonData.numOrden as String,
        comment: jsonData.comment as String,
        nameWork: jsonData.nameWork as String,
      );
      groupedItems.putIfAbsent(idKey, () => <ListWork>[]);
      groupedItems[idKey]!.add(item);
    }
    groupedItems.entries.map((entry) {
      final idKey = entry.key;
      final items = entry.value;
      String ordenstarted = items[0].ordenstarted.toString();
      String dateEndOrden = items[0].ordenend.toString();

      final numeroFactura = idKey; // Número de factura basado en "id_key"

      return ListSimplificarWork(
        numeroFactura: numeroFactura,
        dateStartedOrden: ordenstarted,
        dateEndOrden: dateEndOrden,
        items: items,
      );
    }).toList();

    print(groupedItems);
    // listWorkFilter = List.from(listWork
    //     .where((x) => x.code!
    //         .toUpperCase()
    //         .contains(currentUsers?.code.toString().toUpperCase() ?? ''))
    //     .toList());

    // if (currentUsers?.occupation == OptionAdmin.master.name ||
    //     currentUsers?.occupation == OptionAdmin.supervisor.name ||
    //     currentUsers?.occupation == OptionAdmin.admin.name) {
    //   listWorkFilter = [...listWork];
    // }
    setState(() {});
  }

  Future updateListWorkFinished(ListWork current) async {
    await httpRequestDatabase(insertlistWorkSublimacionFinished, {
      'id_depart': current.idDepart,
      'code': current.code,
      'date_start': current.dateStart,
      'id_key_work': current.idKeyWork,
      'date_end': DateTime.now().toString().substring(0, 19),
      'id': current.id,
    });
    getListWork();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Lista Trabajos Actuales'),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 25),
            child: IconButton(
                icon: const Icon(FontAwesomeIcons.calendarCheck),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SublimacionRecord(
                        current: widget.current,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Expanded(
            child: SizedBox(
              width: 450,
              child: ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final idKey = groupedItems.keys.elementAt(index);
                  final items = groupedItems[idKey]!;

                  // Crear el DataTable para los elementos de la factura
                  final dataTable = SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 25),
                    child: DataTable(
                      dataTextStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      headingTextStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      dataRowMaxHeight: 15,
                      dataRowMinHeight: 10,
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text('TRABAJOS')),
                        DataColumn(label: Text('ORDEN/FICHA')),
                        DataColumn(label: Text('LOGO')),
                        DataColumn(label: Text('CANT-ORDEN')),
                        DataColumn(label: Text('CANT')),
                        DataColumn(label: Text('START')),
                        DataColumn(label: Text('END')),
                      ],
                      rows: items.map((item) {
                        return DataRow(cells: [
                          DataCell(Text('${item.nameWork}')),
                          DataCell(Text('${item.numOrden}- ${item.ficha}')),
                          DataCell(Text('${item.nameLogo}')),
                          DataCell(Text('${item.cantOrden}')),
                          DataCell(Text('${item.cantPieza}')),
                          DataCell(Text('${item.dateStart}')),
                          DataCell(Text('${item.dateEnd}')),
                        ]);
                      }).toList(),
                    ),
                  );

                  return Container(
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('ID-TRABAJO : ${items[0].idKeyWork}',
                            style: style.titleMedium),
                        Text('Empleado : ${items[0].fullName}',
                            style:
                                style.bodySmall?.copyWith(color: Colors.brown)),
                        dataTable,
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL PCS : ',
                                style: style.bodyMedium?.copyWith(),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'CANT PIEZAS',
                                style: style.bodyMedium?.copyWith(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          listWorkFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const BouncingScrollPhysics(),
                      itemCount: listWorkFilter.length,
                      itemBuilder: (context, index) {
                        ListWork current = listWorkFilter[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SublimaListActuales(
                            current: current,
                            pressDelete: () =>
                                deleteFromListSublimacion(current),
                            pressFinisted: () =>
                                updateListWorkFinished(current),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox(
                  child: Text('No hay Trabajo actuales'),
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Container(
              width: 150,
              height: 32,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                'TOTAL : ${listWorkFilter.length}',
                style: const TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListSimplificarWork {
  final String numeroFactura;
  final String dateStartedOrden;
  final String dateEndOrden;
  final List<ListWork> items;

  ListSimplificarWork({
    required this.numeroFactura,
    required this.dateStartedOrden,
    required this.dateEndOrden,
    required this.items,
  });
}
