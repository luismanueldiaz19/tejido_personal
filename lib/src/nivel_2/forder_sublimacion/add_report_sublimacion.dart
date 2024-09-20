import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import '../../datebase/methond.dart';

class AddReportSublimacion extends StatefulWidget {
  const AddReportSublimacion({super.key, this.current});
  final Sublima? current;
  @override
  State<AddReportSublimacion> createState() => _AddReportSublimacionState();
}

class _AddReportSublimacionState extends State<AddReportSublimacion> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();

  ////////////////controller para los reportes ////////
  TextEditingController? controllerPieza = TextEditingController();
  TextEditingController? controllerPKt = TextEditingController();
  int pktColors = 0;
  TextEditingController? controllerFull = TextEditingController();
  int fullColors = 0;

  bool isFull = false;
  bool isPkt = false;
  bool isLoading = false;
  Sublima? currentLocal;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    currentLocal = widget.current;
  }

  @override
  void dispose() {
    super.dispose();
    controllerOrden.dispose();
    controllerCantOrden.dispose();
    controllerFicha.dispose();
    controllerLogo.dispose();
  }

  createReport() {
    if (controllerPieza!.text.isEmpty) {
      return utilShowMesenger(context, 'Error Cantidad de Piezas');
    }

    if (isFull || isPkt) {
      if (controllerFull!.text.isEmpty || controllerPKt!.text.isEmpty) {
        return utilShowMesenger(context, 'Cantidad de Pieza Full / PKt');
      }

      if (pktColors > 0 && int.parse(controllerPKt?.text ?? '0') <= 0) {
        return utilShowMesenger(context, 'Error Pieza PKT');
      }

      if (int.parse(controllerPieza!.text) <=
          int.parse(currentLocal!.cantOrden.toString())) {
        setState(() {
          isLoading = true;
        });
        updateSublimacion(controllerPieza!.text);
      } else {
        return utilShowMesenger(context,
            'La cantidad de la Pieza Realizada es Mayor a la Pieza de la Orden');
      }
    }
  }

  Future updateSublimacion(String value) async {
    // list.clear();
    // setState(() {});

    var data = {
      'id': widget.current?.id,
      'cant_pieza': value,
      'code_user': currentUsers?.code,
      'id_depart': widget.current?.idDepart,
      'num_orden': currentLocal?.numOrden,
      'type_work': widget.current?.typeWork,
      'date_start': widget.current?.dateStart,
      'ficha': currentLocal?.ficha,
      'cant_orden': currentLocal?.cantOrden,
      'name_logo': currentLocal?.nameLogo,
      'pkt': controllerPKt!.text.isEmpty ? '0' : controllerPKt?.text,
      'full': controllerFull!.text.isEmpty ? '0' : controllerFull?.text,
      'id_key_work': widget.current?.idKeyWork
    };
    // print(data);
    final res = await httpRequestDatabase(updateSublimacionWorkLast, data);
    // print('Res ${res.body}');

    if (res.body.toString().contains('good')) {
      if (mounted) Navigator.pop(context, true);
    }
  }

  updateCalida() async {
    var data = {'statu': 'f', 'id': currentLocal!.id};
    final res = await httpRequestDatabase(updateSublimacionWorkStatu, data);
    if (res.body.toString().contains('good')) {
      currentLocal!.statu = 'f';
      setState(() {});
    }
  }

  createReportOther() {
    // print('Otro reporte');

    if (controllerPieza!.text.isNotEmpty) {
      if (int.parse(controllerPieza!.text) <=
          int.parse(currentLocal!.cantOrden.toString())) {
        setState(() {
          isLoading = true;
        });
        updateSublimacion(controllerPieza!.text);
        // print('Correcto');
      } else {
        return utilShowMesenger(context,
            'La cantidad de la Pieza Realizada es Mayor a la Pieza de la Orden');
      }
    } else {
      return utilShowMesenger(context, 'Campo vacio');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPktReport = true;
    if (widget.current?.nameWork?.toUpperCase().trim() == 'EMPAQUE' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'CALANDRA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'PLANCHA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'HORNO' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'SELLOS') {
      isPktReport = false;
    }
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Realizar el Reporte')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Hero(
                              tag: widget.current!.id.toString(),
                              child: CircleAvatar(
                                backgroundColor: ktejidoBlueOcuro,
                                child: Text(
                                    widget.current!.nameLogo
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: style.labelLarge
                                        ?.copyWith(color: Colors.white)),
                              ),
                            ),
                            title: Text(currentLocal?.nameLogo ?? ''),
                          ),
                          Container(
                            height: 35,
                            color: ktejidogrey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Numero de ficha',
                                    style: style.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    widget.current?.ficha ?? '0',
                                    style: style.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Orden : ${currentLocal?.numOrden ?? ''}'),
                                        Text(
                                            'Ficha : ${currentLocal?.ficha ?? ''}'),
                                        Text(
                                            'Cant Orden : ${currentLocal?.cantOrden ?? ''}'),
                                        Text(
                                            'Cant Elaborada : ${currentLocal?.cantPieza ?? ''}'),
                                        Text(
                                            'Logo : ${currentLocal?.nameLogo ?? ''}'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  isPktReport
                                      ? Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Impresiones',
                                                style: TextStyle(
                                                    color: colorsPuppleOpaco),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Full : ${widget.current?.dFull ?? ''}'),
                                                  Checkbox(
                                                      value: isFull,
                                                      onChanged: (val) {
                                                        isFull = !isFull;
                                                        setState(() {});
                                                      })
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'PKT : ${currentLocal?.pkt ?? ''}'),
                                                  Checkbox(
                                                      value: isPkt,
                                                      onChanged: (val) {
                                                        isPkt = !isPkt;
                                                        setState(() {});
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              width: size.width * 0.40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: TextField(
                                                controller: controllerPieza,
                                                textInputAction:
                                                    TextInputAction.none,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: 'Cantidad'),
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                              const SizedBox(height: 10),
                              currentLocal?.statu == 't'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.close,
                                            color: colorsRed),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Calidad no verificada',
                                          style: TextStyle(
                                              color: colorsRed,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: fontTenali),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check,
                                            color: colorsGreenLevel),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Calidad Verificada',
                                          style: TextStyle(
                                              color: colorsGreenLevel,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: fontTenali),
                                        ),
                                      ],
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.update, color: colorsGreenLevel),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            isUpdate = !isUpdate;
                            controllerOrden.text =
                                currentLocal!.numOrden.toString();
                            controllerCantOrden.text =
                                currentLocal!.cantOrden.toString();
                            controllerFicha.text =
                                currentLocal!.ficha.toString();
                            controllerLogo.text =
                                currentLocal!.nameLogo.toString();
                          });
                        },
                        label: Text(
                          'Actualizar',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    isPktReport
                        ? const SizedBox()
                        : isLoading
                            ? const Text('Reportando ... Espere')
                            : SizedBox(
                                width: 250,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.report,
                                      color: colorsRedVino),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white),
                                  ),
                                  onPressed: () {
                                    if (currentLocal?.statu == 't') {
                                      utilShowMesenger(
                                          context, 'Calidad no verificada');
                                    } else {
                                      createReportOther();
                                    }
                                  },
                                  label: const Text(
                                    'Reportar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                    currentLocal!.statu == 'f'
                        ? const SizedBox()
                        : SizedBox(
                            width: 250,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.remove_red_eye_outlined,
                                  color: colorsBlueDeepHigh),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.white),
                              ),
                              onPressed: () {
                                updateCalida();
                              },
                              label: const Text('Calidad',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                    const SizedBox(height: 20),
                    isFull || isPkt
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: size.width * 0.40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: TextField(
                                  controller: controllerPieza,
                                  textInputAction: TextInputAction.none,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: InputBorder.none,
                                      hintText: 'Cantidad'),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: TextField(
                                        controller: controllerFull,
                                        textInputAction: TextInputAction.none,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
                                            border: InputBorder.none,
                                            hintText: 'FULL'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange[50],
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: TextField(
                                        controller: controllerPKt,
                                        textInputAction: TextInputAction.none,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
                                            border: InputBorder.none,
                                            hintText: 'PKT'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              isLoading
                                  ? const Text('Reportando ... Espere')
                                  : SizedBox(
                                      width: 250,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.report,
                                            color: colorsRedVino),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Colors.white),
                                        ),
                                        onPressed: () {
                                          if (currentLocal?.statu == 't') {
                                            utilShowMesenger(context,
                                                'Calidad no verificada');
                                          } else {
                                            createReport();
                                          }
                                        },
                                        label: Text(
                                          'Reportar',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 30),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
