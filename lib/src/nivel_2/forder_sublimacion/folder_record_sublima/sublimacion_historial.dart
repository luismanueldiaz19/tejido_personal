import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/folder_record_sublima/card_list_work_sublima_record.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_class/list_work.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

class SublimacionHistorial extends StatefulWidget {
  const SublimacionHistorial({Key? key, required this.current})
      : super(key: key);
  final Department current;

  @override
  State<SublimacionHistorial> createState() => _SublimacionHistorialState();
}

class _SublimacionHistorialState extends State<SublimacionHistorial> {
  String? _secondDate = '';
  String? _firstDate = '';
  List<ListWork> listRecord = [];
  List<ListWork> listRecordFilter = [];
  List<Sublima> listFilter = [];
  List<Sublima> list = [];

  String totalTrabajo = '';
  int totalOrden = 0;
  int totalElaborado = 0;
  int totalPkt = 0;
  int totaldFull = 0;
  double percentRelation = 0.0;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getListRecord(_firstDate, _secondDate);
  }

  Future getWork(date1, date2) async {
    listFilter.clear();
    list.clear;
    setState(() {});
    final res = await httpRequestDatabase(selectSublimacionWorkFinishedbydate, {
      'id_depart': widget.current.id,
      'date1': date1,
      'date2': date2,
    });
    // print('Filter es ');
    list = sublimaFromJson(res.body);
    listFilter = [...list];
    takeTime(listFilter);
    // print(res.body);
    if (listFilter.isNotEmpty) {
      setState(() {});
    }
  }

  Duration toTalDiferences = const Duration();
  //  Duration diferencesTimeWork = const Duration();
  //    Duration total = const Duration();
  void _searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listRecordFilter = List.from(listRecord
          .where((x) =>
              x.code!.toUpperCase().contains(val.toUpperCase()) ||
              x.fullName!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      // Duration duration1 = Duration(hours: 2);
      // Duration duration2 = Duration(minutes: 30);
      // Duration totalDuration = duration1 + duration2;
      // print(totalDuration);
      // takeTime(listFilter);
      setState(() {});
    } else {
      listRecordFilter = [...listRecord];
      // takeTime(listFilter);
      setState(() {});
    }
  }

  takeTime(List<Sublima> listLocal) {
    toTalDiferences = const Duration();
    totalOrden = 0;
    totalElaborado = 0;
    totalPkt = 0;
    totaldFull = 0;
    for (var element in listLocal) {
      // print(element.numOrden);
      Duration? diferences;
      DateTime date1 =
          DateTime.parse(element.dateStart.toString().substring(0, 19));
      DateTime date2 =
          DateTime.parse(element.dateEnd.toString().substring(0, 19));
      diferences = date2.difference(date1);
      toTalDiferences = toTalDiferences += diferences;
      totalOrden = totalOrden += int.parse(element.cantOrden.toString());
      totalElaborado =
          totalElaborado += int.parse(element.cantPieza.toString());
      // totalPkt = totalPkt += int.parse(element.pkt.toString());
      // totaldFull = totaldFull += int.parse(element.dFull.toString());
      // totalElaborado =
      // percentRelation += int.parse(element.cantPieza.toString());
      // print('La diferencia obtenida Sumada $toTalDiferences');
    }

    percentRelation = (totalElaborado / totalOrden) * 100;
    // print(percentRelation);
  }

  // Future deleteFromSublima(id) async {
  //   await httpRequestDatabase(deleteSublimacionWorkFinished, {'id': id});
  //   getWork(_firstDate, _secondDate);
  // }

  Future getListRecord(date1, date2) async {
    final res =
        await httpRequestDatabase(selectListWorkSublimacionFinishedDate, {
      'date1': date1,
      'date2': date2,
    });
    // print(res);
    // print('List record ${res.body}');

    listRecord = listWorkFromJson(res.body);

    if (listRecord.isNotEmpty) {
      listRecordFilter = [...listRecord];
      setState(() {});
    }
  }

  Future deleteMethondListWorkSublimacionFinished(ListWork current) async {
    await httpRequestDatabase(
        deleteListWorkSublimacionFinished, {'id': current.id});
    // print('El delete es  ${res.body}');
    getListRecord(_firstDate, _secondDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'List trabajos'),
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
                    getWork(_firstDate, _secondDate);
                  },
                  child: Text(_secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeIn(
                child: SizedBox(
                  width: 200,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextField(
                      // controller: controllerSearching,
                      onChanged: (val) => _searchingFilter(val),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15.0),
                          hintText: 'Buscar',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              listFilter.isNotEmpty
                  ? const SizedBox(width: 10)
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 15),
          listRecordFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const BouncingScrollPhysics(),
                      itemCount: listRecordFilter.length,
                      itemBuilder: (context, index) {
                        ListWork current = listRecordFilter[index];
                        // print('Key Work es ${current.idKeyWork}');
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CardListWorkSublimaRecord(
                              current: current,
                              pressDelete: () =>
                                  deleteMethondListWorkSublimacionFinished(
                                      current)),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox(
                  child: Text('No hay Trabajo actuales'),
                )
        ],
      ),
    );
  }
}
