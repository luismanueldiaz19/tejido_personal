import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/folder_record_sublima/card_sublimacion_historial.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/url_report_general/url_reportes_generales.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:lottie/lottie.dart';

class DetailsReport extends StatefulWidget {
  const DetailsReport(
      {Key? key,
      required this.current,
      required this.departCurrent,
      required this.date1,
      required this.date2})
      : super(key: key);
  final Sublima current;
  final Department departCurrent;
  final String? date1;
  final String? date2;
  @override
  State<DetailsReport> createState() => _DetailsReportState();
}

class _DetailsReportState extends State<DetailsReport>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Map<String, Sublima> resultado = {};

  List<Sublima> details = [];
  List<Sublima> detailsFilter = [];
  String totalTrabajo = '';
  int totalOrden = 0;
  int totalElaborado = 0;
  double percentRelation = 0.0;

  Future getDetailes() async {
// $date1 = $_POST['date1'];
//     $date2 = $_POST['date2'];
//     $type_work = $_POST['type_work'];
//     $code = $_POST['code'];
//     $id_depart = $_POST['id_depart'];
    final res = await httpRequestDatabase(selectSublimacionGeneralDetails, {
      'date1': widget.date1,
      'date2': widget.date2,
      'type_work': widget.current.typeWork,
      'code': widget.current.codeUser,
      'id_depart': widget.departCurrent.id,
    });
    // print('Detalles es ${res.body}');

    details = sublimaFromJson(res.body);
    detailsFilter = [...details];
    resultado = sumarCantidades(detailsFilter);
    takeTime(detailsFilter);
    tomarUsuarios(detailsFilter);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    getDetailes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration toTalDiferences = const Duration();
  takeTime(List<Sublima> listLocal) {
    toTalDiferences = const Duration();
    totalOrden = 0;
    totalElaborado = 0;
    // totalPkt = 0;
    // totaldFull = 0;
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

  void _searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      detailsFilter = List.from(details
          .where((x) => x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      takeTime(detailsFilter);
      setState(() {});
    } else {
      detailsFilter = [...details];
      // takeTime(listFilter);
      // tomarUsuarios(listFilter);
      takeTime(detailsFilter);
      setState(() {});
    }
  }

  List<String> numOrdenes = [];

  tomarUsuarios(List<Sublima> itemList) {
    numOrdenes.clear();

    List<Sublima> detallesProducts = [...itemList];

    List<String> uniqueOrdenes =
        detallesProducts.toSet().map((user) => user.numOrden ?? 'N/A').toList();

    // List<String> uniqueTypeWork =
    //     detallesProducts.toSet().map((user) => user.nameWork ?? 'N/A').toList();
    // // print(uniqueTypeWork);

    numOrdenes = uniqueOrdenes.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    var textSize = 10.0;
    var styleTitle = TextStyle(
        color: Colors.black, fontSize: textSize, fontFamily: fontBalooPaaji);
    final size = MediaQuery.of(context).size;
    // final spaceWith = (size.width * 0.05);

    // print(size);

    /////// de 0 a 600
    if (size.width > 0 && size.width <= 600) {
      textSize = size.width * 0.020;
    } else {
      textSize = size.width * 0.035;
    }

    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Detalles'),
          Expanded(
            child: Row(
              children: [
                detailsFilter.isEmpty
                    ? const Expanded(flex: 2, child: Text('Cargando data'))
                    : Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Pieza Orden', style: styleTitle),
                                      Text(
                                        totalOrden.toString(),
                                        style: const TextStyle(
                                          color: colorsPuppleOpaco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Pieza Elaborado',
                                          style: styleTitle),
                                      Text(
                                        totalElaborado.toString(),
                                        style: const TextStyle(
                                          color: colorsPuppleOpaco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Cantidad Trabajos',
                                          style: styleTitle),
                                      Text(
                                        detailsFilter.length.toString(),
                                        style: const TextStyle(
                                          color: colorsPuppleOpaco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: detailsFilter.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Sublima current = detailsFilter[index];
                                    return CardSublimacionHistorial(
                                      current: current,
                                      eliminarPress: (Sublima element) {},

                                      // pressFinishedSublic: () {},
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Lottie.asset('animation/details.json',
                            repeat: true, height: 200, width: 200),
                        FadeIn(
                          child: SizedBox(
                            width: 200,
                            child: Material(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(2.0),
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
                        const SizedBox(height: 15),
                        Text('Revisar tu reporte',
                            style: Theme.of(context).textTheme.headline6),
                        Text('Cant : Trabajos ${details.length}',
                            style: Theme.of(context).textTheme.caption),
                        Text('Ordenes que aparecen en la lista',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: colorsAd)),
                        const SizedBox(height: 10),
                        numOrdenes.isNotEmpty
                            ? Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: numOrdenes
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // usuario = e;
                                                _searchingFilter(e);
                                              },
                                              child: Chip(
                                                label: Text(e),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
