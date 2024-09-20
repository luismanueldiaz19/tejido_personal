import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/model/cuentas_por_cobrar.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';

import '../../screen_print_pdf/apis/pdf_api.dart';

class PrintDetallesCuentasPorCobrar {
  PrintDetallesCuentasPorCobrar();

  static Future<File> generate(List<CuentaPorCobrar> listMaterial) async {
    final pdf = Document();
// Agregar la imagen al PDF
    // final Uint8List imageBytes = File(pathImagen).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics =
    //     pdfWidgets.MemoryImage(imageBytes);
    // // final image = pw.MemoryImage(File('images/boxes.png').readAsBytesSync());
    final imageLogo =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    final imageLogo2 =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    const style = TextStyle(fontSize: 7);
    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('Detalles de Pagos', imageLogo, imageLogo2),
        SizedBox(height: 1 * PdfPageFormat.cm / 4),
        Text(currentEmpresa.nombreEmpresa ?? ''),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentEmpresa.adressEmpressa ?? '',
                style: const TextStyle(fontSize: 9)),
            Row(
              children: [
                Text('TEL: ${currentEmpresa.telefonoEmpresa ?? ''}',
                    style: style),
                SizedBox(width: 5),
                Text('CEL: ${currentEmpresa.celularEmpresa ?? ''}',
                    style: style),
                SizedBox(width: 5),
                Text('OFICINA: ${currentEmpresa.oficinaEmpres ?? ''}',
                    style: style),
              ],
            ),
            Text('RNC : ${currentEmpresa.rncEmpresa ?? ''}', style: style),
            // Text('DESPACHADOR /A : ${currentUser?.fullName ?? ''}',
            //         style: style),
          ],
        ),
        Text('Fecha Impreso : ${DateTime.now().toString().substring(0, 19)}',
            style: const TextStyle(color: PdfColors.blue800, fontSize: 8)),
        SizedBox(height: 2 * PdfPageFormat.cm / 4),
        Text('REGISTROS DE PAGOS CORRESPONDIENTES',
            style: const TextStyle(color: PdfColors.black, fontSize: 7)),
        Divider(color: PdfColors.grey300, endIndent: 300),
        SizedBox(height: 1 * PdfPageFormat.cm / 4),
        tableMateriales(listMaterial),
        SizedBox(height: 2 * PdfPageFormat.cm / 2),
        Text('Balance Actual',
            style: const TextStyle(color: PdfColors.black, fontSize: 7)),
        Divider(color: PdfColors.grey300),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              // color: PdfColors.grey50,
              height: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total Pagos', style: style),
                  SizedBox(width: 10),
                  Text(listMaterial.length.toString(), style: style)
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Deuda', style: style),
                  SizedBox(width: 5),
                  Text(
                      getNumFormatedDouble(
                          CuentaPorCobrar.getTotalPendiente(listMaterial)),
                      style: style)
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pagado', style: style),
                  SizedBox(width: 5),
                  Text(
                      getNumFormatedDouble(
                          CuentaPorCobrar.getMontoPagadoItem(listMaterial)),
                      style: style.copyWith(color: PdfColors.green))
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Faltante', style: style),
                  SizedBox(width: 5),
                  Text(
                      '\$ ${getNumFormatedDouble(CuentaPorCobrar.getRestar(CuentaPorCobrar.getTotalPendiente(listMaterial), CuentaPorCobrar.getMontoPagadoItem(listMaterial)))}',
                      style: style.copyWith(color: PdfColors.red))
                ],
              ),
            ),
          ],
        ),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(
        name:
            'Detalles_Pagos_Cuentas_Por_Cobrar_${DateTime.now().toString().substring(0, 10)}.pdf',
        pdf: pdf);
  }

  static Widget tableMateriales(List<CuentaPorCobrar> list) {
    List<List<String>> data = list.map((material) {
      return [
        material.id ?? 'N/A',
        material.numOrden ?? 'N/A',
        '\$ ${getNumFormatedDouble(material.montoPagado ?? 'N/A')}',
        material.fechaPago ?? 'N/A',
        material.usuario ?? 'N/A'
      ];
    }).toList();
    // DataColumn(label: Text('#ID')),
    //                         DataColumn(label: Text('#ORDEN')),
    //                         DataColumn(label: Text('PAGADO')),
    //                         DataColumn(label: Text('FECHA PAGO')),
    //                         DataColumn(label: Text('REALIZADO POR')),
    return Table.fromTextArray(
        headers: [
          '#ID',
          'PAGADO',
          '#ORDEN',
          'FECHA PAGO',
          'REALIZADO POR',
        ],
        data: data,
        headerDecoration: BoxDecoration(color: PdfColors.grey100),
        border: const TableBorder(
            horizontalInside: BorderSide(color: PdfColors.brown100),
            verticalInside: BorderSide(color: PdfColors.brown100)),
        tableWidth: TableWidth.max,
        cellStyle: const TextStyle(fontSize: 7),
        headerStyle: const TextStyle(fontSize: 7),
        cellAlignment: Alignment.center,
        headerAlignment: Alignment.center
        // headerDecoration: const BoxDecoration(color: PdfColors.orange50),
        );
  }

  static Widget buildPaymentInfoRowImagen(String label, image, image2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Image(image2, height: 50, width: 50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    Text('Impreso por ${currentUsers?.fullName}',
                        style: const TextStyle(
                            color: PdfColors.grey, fontSize: 7)),
                  ])),
          Spacer(),
        ],
      ),
    );
  }

  static Widget buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
          ),
          Text(
            value,
            style: const TextStyle(
                // fontSize: 16.0,
                ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: PdfColors.grey),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('LuDeveloper', style: const TextStyle(fontSize: 8)),
          ])
        ],
      ));

  // static buildTextGet({required String title}) {
  //   return Container(
  //     width: double.infinity,
  //     child: Row(
  //       children: [
  //         Expanded(child: Text(title, style: const TextStyle(fontSize: 8))),
  //         // pw.SizedBox(),
  //       ],
  //     ),
  //   );
  // }
}
