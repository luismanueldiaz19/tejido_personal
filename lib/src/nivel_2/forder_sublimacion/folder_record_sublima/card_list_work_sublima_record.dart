import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/folder_record_sublima/card_sublimacion_historial.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_class/list_work.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/font_style.dart';

class CardListWorkSublimaRecord extends StatefulWidget {
  const CardListWorkSublimaRecord({
    Key? key,
    required this.current,
    required this.pressDelete,
  }) : super(key: key);

  final ListWork current;
  final Function pressDelete;

  @override
  State<CardListWorkSublimaRecord> createState() =>
      _CardListWorkSublimaRecordState();
}

class _CardListWorkSublimaRecordState extends State<CardListWorkSublimaRecord> {
  List<Sublima>? listWorSublimaRecord;
  late TextEditingController? cant;
  late TextEditingController? pkt;
  late TextEditingController? full;

  @override
  void initState() {
    super.initState();
    listWorSublimaRecord = [];
    cant = TextEditingController();
    pkt = TextEditingController();
    full = TextEditingController();
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
    await httpRequestDatabase(deleteSublimacionWork, {'id': current.id});
    // print(res.body);
    getWorkByKey();
  }

  Future getWorkByKey() async {
    listWorSublimaRecord?.clear();

    final res =
        await httpRequestDatabase(selectListWorkSublimacionIdkeyWorkRecord, {
      'id_depart': widget.current.idDepart.toString(),
      'id_key_work': widget.current.idKeyWork.toString()
    });
    listWorSublimaRecord = sublimaFromJson(res.body);
    // print('los trabajo son por key :  ${res.body}');
    setState(() {});
  }

  Future<String?> changeValueOutPut() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Introduzca Cant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0)),
                child: TextField(
                  controller: cant,
                  textInputAction: TextInputAction.none,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Cantidad'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Impresiones',
                    style: TextStyle(fontFamily: fontBalooPaaji),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: TextField(
                            controller: pkt,
                            textInputAction: TextInputAction.none,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'PKT'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: TextField(
                            controller: full,
                            textInputAction: TextInputAction.none,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                border: InputBorder.none,
                                hintText: 'FULL'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // print(current);
                  Navigator.pop(context);
                },
                child: const Text('Cerrar')),
            ElevatedButton(
                onPressed: submitOutput, child: const Text('Confirmar'))
          ],
        ),
      );
  void submitOutput() {
    Navigator.of(context).pop(cant!.text);
    // cant!.clear();
    // pkt!.clear();
    // full!.clear();
  }

  Future updateStartSublima(Sublima current) async {
    var data = {
      'date_start': DateTime.now().toString().substring(0, 19),
      'id': current.id,
    };
    await httpRequestDatabase(updateSublimacionWorkDateStart, data);
    // print('DateSelected ${data} ${res.body}');
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

  Future deleteFromSublima(id) async {
    await httpRequestDatabase(deleteSublimacionWorkFinished, {'id': id});
    getWorkByKey();
  }

  String getTime(start, end) {
    DateTime date1 = DateTime.parse(start.toString().substring(0, 19));
    DateTime date2 = DateTime.parse(end.toString().substring(0, 19));
    var diferences = date2.difference(date1);

    return diferences.toString();
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
        color: colorsGreyWhite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.current.fullName.toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Trabajo Id : ",
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .subtitle1!
                        //       .copyWith(fontSize: textSize),
                        // ),
                        Text(
                          "Trabajo empezó : ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize),
                        ),
                        Text(
                          "Trabajo terminó : ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize),
                        ),
                        Text(
                          "Tiempo estimado : ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.current.dateStart.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  fontSize: textSize, color: colorsGreenLevel),
                        ),
                        Text(
                          widget.current.dateEnd.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize, color: colorsRed),
                        ),
                        Text(
                          getTime(widget.current.dateStart.toString(),
                                  widget.current.dateEnd.toString())
                              .substring(0, 8),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize),
                        ),
                      ],
                    )
                  ],
                ),
                listWorSublimaRecord!.isEmpty
                    ? currentUsers?.occupation == OptionAdmin.admin.name ||
                            currentUsers?.occupation == OptionAdmin.master.name
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
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                listWorSublimaRecord!.isNotEmpty
                    ? Text(
                        "Total Trabajos.: ${listWorSublimaRecord?.length}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontSize: textSize,
                              color: colorsAd,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : const SizedBox(),
                Column(
                  children: listWorSublimaRecord!
                      .map(
                        (currentSublim) => CardSublimacionHistorial(
                          current: currentSublim,
                          eliminarPress: (Sublima element) {
                            deleteFromSublima(element.id);
                          },
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
