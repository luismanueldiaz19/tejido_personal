import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import '../../../../util/get_day_writed.dart';
import '../../../../util/get_time_relation.dart';
import '../../../folder_confecion/model/confecion.dart';

class ShowGraficsPromedioMonth extends StatefulWidget {
  final List<Confeccion> data;

  const ShowGraficsPromedioMonth({super.key, required this.data});

  @override
  State<ShowGraficsPromedioMonth> createState() =>
      _ShowGraficsPromedioMonthState();
}

class _ShowGraficsPromedioMonthState extends State<ShowGraficsPromedioMonth> {
  ScreenshotController screenshotController1 = ScreenshotController();
  //  ScreenshotController screenshotController = ScreenshotController();

  void captureAndSaveScreens(BuildContext context) async {
    try {
      String? path1Local;
      // Capturar la primera pantalla
      screenshotController1.capture().then((Uint8List? image1) {
        if (image1 != null) {
          saveScreenshotToLocalFile(image1, nameFile: '1').then((path1) {});
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.of(context).size;
    return Screenshot(
      controller: screenshotController1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          color: Colors.white54,
          width: sized.width < 600 ? sized.width : sized.width * 0.40,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(),
            title: ChartTitle(
                text: 'Producción Mensual',
                textStyle:
                    style.labelSmall?.copyWith(color: colorsBlueDeepHigh)),
            series: <CartesianSeries>[
              LineSeries<Confeccion, String>(
                  color: Colors.black,
                  dataSource: widget.data,
                  xValueMapper: (Confeccion sales, _) => obtenerNombreMes(
                      sales.semana.toString().substring(0, 10)),
                  yValueMapper: (Confeccion sales, _) => int.parse(
                      double.parse(sales.cantPieza ?? '0').toStringAsFixed(0))),
              ColumnSeries<Confeccion, String>(
                width: 0.1,
                pointColorMapper: (Confeccion trampa, _) => ktejidogrey,
                dataSource: widget.data,
                xValueMapper: (Confeccion trampa, _) =>
                    obtenerNombreMes(trampa.semana.toString().substring(0, 10)),
                yValueMapper: (Confeccion trampa, _) =>
                    double.parse(trampa.cantPieza ?? '0'),
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.auto,
                    textStyle: style.labelSmall!),
                dataLabelMapper: (trampa, index) {
                  return trampa.cantPieza.toString();
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Column(
    //   children: [
    //    const Divider(),
    //     ElevatedButton.icon(
    //         icon: const Icon(Icons.print, color: Colors.white),
    //         style: ButtonStyle(
    //           backgroundColor:
    //               MaterialStateProperty.resolveWith((states) => ktejidoblue),
    //           shape: MaterialStateProperty.resolveWith((states) =>
    //               RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(3))),
    //         ),
    //         onPressed: () => captureAndSaveScreens(context),
    //         label:
    //             const Text('Imprimir', style: TextStyle(color: Colors.white))),
    //   ],
    // );
  }
}
