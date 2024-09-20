import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/add_report_sublimacion.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/card_sublimacion.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_class/list_work.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

class SublimaListActuales extends StatefulWidget {
  const SublimaListActuales({
    Key? key,
    required this.current,
    required this.pressDelete,
    required this.pressFinisted,
  }) : super(key: key);

  final ListWork current;
  final Function pressDelete;
  final Function pressFinisted;

  @override
  State<SublimaListActuales> createState() => _SublimaListActualesState();
}

class _SublimaListActualesState extends State<SublimaListActuales> {
  List<Sublima>? listWorSublima;
  late TextEditingController? cant;
  late TextEditingController? pkt;
  late TextEditingController? full;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    listWorSublima = [];
    cant = TextEditingController();
    pkt = TextEditingController();

    full = TextEditingController();
    // print(widget.current.idKeyWork);
    // print('id_depart ${widget.current.idDepart}');
    getWorkByKey();
  }

  @override
  void dispose() {
    super.dispose();
    cant?.dispose();
    pkt?.dispose();
    full?.dispose();
  }

  Future deleteFromSublimacion(Sublima current) async {
    setState(() {
      isloading = true;
    });
    await httpRequestDatabase(deleteSublimacionWork, {'id': current.id});
    // print(res.body);
    getWorkByKey();
  }

  Future getWorkByKey() async {
    listWorSublima?.clear();

    final res = await httpRequestDatabase(selectListWorkSublimacionIdkeyWork, {
      'id_depart': widget.current.idDepart.toString(),
      'id_key_work': widget.current.idKeyWork.toString()
    });
    listWorSublima = sublimaFromJson(res.body);
    if (mounted) {
      setState(() {
        isloading = false;
      });
    }
  }

  Future updateSublimacion(Sublima current, String value) async {
    setState(() {
      isloading = true;
    });

    var data = {
      'id': current.id,
      'cant_pieza': value,
      'code_user': currentUsers?.code,
      'id_depart': current.idDepart,
      'num_orden': current.numOrden,
      'type_work': current.typeWork,
      'date_start': current.dateStart,
      'ficha': current.ficha,
      'cant_orden': current.cantOrden,
      'name_logo': current.nameLogo,
      'pkt': pkt?.text,
      'full': full?.text,
      'id_key_work': current.idKeyWork
    };
    await httpRequestDatabase(updateSublimacionWorkLast, data);
    // print('Res ${res.body}');
    getWorkByKey();
  }

  Future updateStartSublima(Sublima current) async {
    var data = {
      'date_start': DateTime.now().toString().substring(0, 19),
      'id': current.id,
    };
    await httpRequestDatabase(updateSublimacionWorkDateStart, data);
    getWorkByKey();
  }

  Future updateEndSublima(Sublima current) async {
    var data = {
      'date_end': DateTime.now().toString().substring(0, 19),
      'id': current.id,
    };
    await httpRequestDatabase(updateSublimacionWorkDateEnd, data);

    // print('DateSelected ${data} ${res.body}');
    getWorkByKey();
  }

  @override
  Widget build(BuildContext context) {
    var textSize = 10.0;
    final size = MediaQuery.of(context).size;
    // print(size);

    /////// de 0 a 600
    if (size.width > 0 && size.width <= 600) {
      textSize = size.width * 0.020;
    } else {
      textSize = 15;
    }

    return ZoomIn(
      duration: const Duration(milliseconds: 200),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.current.fullName.toString(),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Operario : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: textSize),
                      ),
                      Text(
                        "Trabajo Id : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: textSize),
                      ),
                      Text(
                        "Empezó : ",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: textSize),
                      ),
                    ],
                  ),
                  listWorSublima!.isEmpty
                      ? TextButton(
                          onPressed: () {
                            widget.pressFinisted();
                          },
                          child: const Text('Terminar'))
                      : const SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.current.fullName.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: textSize),
                      ),
                      Text(
                        widget.current.idKeyWork.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: textSize),
                      ),
                      Text(
                        widget.current.dateStart.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: textSize),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  listWorSublima!.isEmpty
                      ? currentUsers?.occupation == OptionAdmin.admin.name ||
                              currentUsers?.occupation ==
                                  OptionAdmin.master.name
                          ? TextButton.icon(
                              icon: const Icon(
                                Icons.delete,
                                color: colorsRed,
                              ),
                              onPressed: () {
                                widget.pressDelete();
                              },
                              label: const Text(
                                'Eliminar ',
                                style: TextStyle(color: colorsRed),
                              ))
                          : const SizedBox()
                      : const SizedBox(),
                  listWorSublima!.isNotEmpty
                      ? Text(
                          "Total Trabajos.: ${listWorSublima?.length}",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: textSize,
                                    color: colorsAd,
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      : const SizedBox(),
                ],
              ),
              isloading
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Cargando datos .... Espere!',
                        style: TextStyle(
                            color: colorsPuppleOpaco,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Column(
                      children: listWorSublima!
                          .map(
                            (currentSublim) => CardSublimacion(
                              current: currentSublim,
                              updateStart: () =>
                                  updateStartSublima(currentSublim),
                              updateEnd: () => updateEndSublima(currentSublim),
                              press: () async {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddReportSublimacion(
                                                    current: currentSublim)))
                                    .then((value) => {
                                          getWorkByKey(),
                                        });
                              },
                              pressDelete: () {
                                deleteFromSublimacion(currentSublim);
                              },
                            ),
                          )
                          .toList(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
