import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import '../../util/commo_pallete.dart';
import '../forder_sublimacion/model_nivel/sublima.dart';
import 'provider/provider_serigrafia.dart';

class AddMakeReportSerigrafia extends StatefulWidget {
  const AddMakeReportSerigrafia({super.key, required this.current});
  final Sublima? current;

  @override
  State<AddMakeReportSerigrafia> createState() =>
      _AddMakeReportSerigrafiaState();
}

class _AddMakeReportSerigrafiaState extends State<AddMakeReportSerigrafia> {
  ////////////////controller para los reportes ////////
  TextEditingController? controllerPieza = TextEditingController();
  TextEditingController? controllerPKt = TextEditingController();
  TextEditingController? controllerFull = TextEditingController();
  double _sliderpktColors = 1;
  double _sliderfullColors = 1;
  bool isSending = false;
  bool isComplete = false;

  @override
  void dispose() {
    super.dispose();
    controllerPieza?.dispose();
    controllerPKt?.dispose();
    controllerFull?.dispose();
  }

  //  updateItem(controllerPieza!.text);
  Future reportFormatoTwo(context) async {
    if (controllerPieza!.text.isEmpty ||
        controllerFull!.text.isEmpty ||
        controllerPKt!.text.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error Cantidad de Piezas / Full / PKt'),
          backgroundColor: Colors.red));
    }
    if (Sublima.validaQtyOrden(widget.current!, controllerPieza!.text)) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.warning, color: Colors.white),
              ),
              Text('La Cantidad supera la orden solicitad')
            ],
          ),
          backgroundColor: Colors.orange));
    }
    setState(() {
      isSending = true;
    });

    widget.current!.cantPieza = controllerPieza!.text;
    widget.current!.dFull = controllerFull!.text;
    widget.current!.colorfull = controllerFull!.text == '0'
        ? '0'
        : _sliderfullColors.toStringAsFixed(0);
    widget.current!.pkt = controllerPKt!.text;
    widget.current!.colorpkt =
        controllerPKt!.text == '0' ? '0' : _sliderpktColors.toStringAsFixed(0);
    widget.current!.dateEnd = DateTime.now().toString().substring(0, 19);
    print(widget.current!.toJson());
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_work_serigrafia.php";
    final res = await httpRequestDatabase(url, widget.current!.toJson());
    await Provider.of<ProviderSerigrafia>(context, listen: false)
        .getWork(widget.current?.idDepart);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res.body.toString()), backgroundColor: Colors.green));
    setState(() {
      isComplete = true;
    });
  }

  Color calculateThumbColor(double value) {
    if (value <= 2) {
      return Colors.red;
    } else if (value <= 4) {
      return Colors.blue;
    } else {
      return Colors.brown;
    }
  }

  ////reporte para un formato 1 ////
  Future reportFormatoOne(context) async {
    if (controllerPieza!.text.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error Cantidad de Piezas'),
          backgroundColor: Colors.red));
    }
    if (Sublima.validaQtyOrden(widget.current!, controllerPieza!.text)) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.warning, color: Colors.white),
              ),
              Text('La Cantidad supera la orden solicitad')
            ],
          ),
          backgroundColor: Colors.orange));
    }
    setState(() {
      isSending = true;
    });
    print(widget.current?.toJson()); //
    //insert_work_serigrafia
    widget.current!.cantPieza = controllerPieza!.text;
    widget.current!.dateEnd = DateTime.now().toString().substring(0, 19);
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_work_serigrafia.php";
    final res = await httpRequestDatabase(url, widget.current!.toJson());
    await Provider.of<ProviderSerigrafia>(context, listen: false)
        .getWork(widget.current?.idDepart);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res.body.toString()), backgroundColor: Colors.green));
    setState(() {
      isComplete = true;
    });
  }

  bool validateInput(String input) {
    return input != '0';
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    bool isPktReport = true;
    if (widget.current?.nameWork?.toUpperCase().trim() == 'EMPAQUE' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'CALANDRA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'PLANCHA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'HORNO' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'SELLOS') {
      isPktReport = false;
      print('report solamante de publicar QTY Pcs');
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Realizar reporte')),
      body: size.width > 650
          ? const Center(child: Text('Pantalla no disponibles'))
          : Column(
              children: [
                const SizedBox(width: double.infinity),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
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
                            title: Text(widget.current?.nameLogo ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Orden : ${widget.current?.numOrden ?? ''}',
                                    style: style.bodySmall),
                                Text(
                                    'Cant Orden : ${widget.current?.cantOrden ?? ''}',
                                    style: style.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 35,
                          color: ktejidogrey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Numero de ficha',
                                    style: style.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                isPktReport
                    ? isComplete
                        ? SizedBox(
                            height: size.height * 0.25,
                            width: size.height * 0.25,
                            child: Lottie.asset('animation/done.json',
                                repeat: false, fit: BoxFit.cover),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(1.0)),
                                    width: 250,
                                    child: TextField(
                                      enabled: !isSending,
                                      onChanged: (value) {
                                        if (!validateInput(value)) {
                                          controllerPieza!.clear();
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: controllerPieza,
                                      decoration: const InputDecoration(
                                        hintText: 'Cantidad',
                                        label: Text('Qty'),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(1.0)),
                                    width: 250,
                                    child: TextField(
                                      enabled: !isSending,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: controllerFull,
                                      decoration: const InputDecoration(
                                        hintText: 'FULL',
                                        label: Text('FULL'),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(1.0)),
                                    width: 250,
                                    child: TextField(
                                      enabled: !isSending,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: controllerPKt,
                                      decoration: const InputDecoration(
                                        hintText: 'PKT',
                                        label: Text('PKT'),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            '¿Cuántos colores tiene FULL?'),
                                        Slider(
                                          activeColor: calculateThumbColor(
                                              _sliderfullColors),
                                          thumbColor: Colors.white,
                                          label: _sliderfullColors
                                              .toStringAsFixed(0),
                                          value: _sliderfullColors,
                                          min: 1,
                                          max: 6,
                                          divisions: 5,
                                          onChanged: (value) {
                                            setState(() {
                                              _sliderfullColors = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            '¿Cuántos colores tiene PKT?'),
                                        Slider(
                                          activeColor: calculateThumbColor(
                                              _sliderpktColors),
                                          value: _sliderpktColors,
                                          min: 1,
                                          max: 6,
                                          label: _sliderpktColors
                                              .toStringAsFixed(0),
                                          divisions: 5,
                                          onChanged: (value) {
                                            setState(() {
                                              _sliderpktColors = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  isSending
                                      ? SizedBox(
                                          width: 250,
                                          child: Column(
                                            children: [
                                              const LinearProgressIndicator(
                                                  backgroundColor:
                                                      ktejidoBlueOcuro,
                                                  color: Colors.white),
                                              Text('Reportando',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              ktejidoBlueOcuro)),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          width: 250,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                reportFormatoTwo(context),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            colorsBlueDeepHigh)),
                                            child: const Text('Reportar',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                    : const SizedBox(),
                !isPktReport
                    ? isComplete
                        ? SizedBox(
                            height: size.height * 0.25,
                            width: size.height * 0.25,
                            child: Lottie.asset('animation/done.json',
                                repeat: false, fit: BoxFit.cover),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(1.0)),
                                      width: 250,
                                      alignment: Alignment.center,
                                      child: Text(
                                          widget.current?.nameWork ?? 'N/A')),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(1.0)),
                                    width: 250,
                                    child: TextField(
                                      enabled: !isSending,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (!validateInput(value)) {
                                          controllerPieza!.clear();
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: controllerPieza,
                                      decoration: const InputDecoration(
                                        hintText: 'Cantidad',
                                        label: Text('Qty'),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  isSending
                                      ? SizedBox(
                                          width: 250,
                                          child: Column(
                                            children: [
                                              const LinearProgressIndicator(
                                                  backgroundColor:
                                                      ktejidoBlueOcuro,
                                                  color: Colors.white),
                                              Text('Reportando',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              ktejidoBlueOcuro)),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          width: 250,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                reportFormatoOne(context),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            colorsBlueDeepHigh)),
                                            child: const Text('Reportar',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                    : const SizedBox()
              ],
            ),
    );
  }
}
