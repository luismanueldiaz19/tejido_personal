import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';

import '../../datebase/current_data.dart';

class PrintDetallesForPaid {
  PrintDetallesForPaid();

  static Future<File> generate(
      List<ForPaid> listPlani, String fecha, ForPaid item) async {
    final pdf = Document();
    final imageLogo2 = MemoryImage(
        (await rootBundle.load('assets/liquidez_de_la_empresa.jpg'))
            .buffer
            .asUint8List());
    const style = TextStyle(fontSize: 8);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('Detalles de cuenta', imageLogo2),
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
        Text('Imprimido Por : ${currentUsers?.fullName ?? ''}', style: style),
        SizedBox(height: 1 * PdfPageFormat.cm / 5),
        Text('FECHA : $fecha', style: style.copyWith(color: PdfColors.black)),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Divider(color: PdfColors.grey200),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${item.fNombre ?? ''}',
                style: const TextStyle(fontSize: 9)),
            Text('Doc-Orden : ${item.fDocumento ?? ''}', style: style),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Monto', style: style),
                Text('\$ ${item.fMonto ?? ''}',
                    style: const TextStyle(fontSize: 8)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance', style: style),
                Text('\$ ${item.fBalance ?? ''}',
                    style:
                        const TextStyle(color: PdfColors.green, fontSize: 8)),
                Text('Pagado', style: style),
                Text('\$ ${ForPaid.restaItem(item)}',
                    style: const TextStyle(color: PdfColors.red, fontSize: 8))
              ],
            ),
          ],
        ),
        Divider(color: PdfColors.grey200),
        SizedBox(height: 1 * PdfPageFormat.cm / 3),
        Text('DETALLES', style: style.copyWith(color: PdfColors.black)),
        SizedBox(height: 1 * PdfPageFormat.cm / 5),
        tableProducts(listPlani, item),
        SizedBox(height: 1 * PdfPageFormat.cm / 5),
        // Divider(),
        SizedBox(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: 25,
                  child: Center(
                      child: Text('Seguimiento : ${listPlani.length}',
                          style: style))),
            ],
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        buildPaymentInfoRow('APROBADO POR', ''),
        Divider(height: 1, endIndent: 250),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        buildPaymentInfoRow('SUPEVISOR', ''),
        Divider(height: 1, endIndent: 250),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('COMENTARIO',
                  style: style..copyWith(color: PdfColors.black))),
        ]),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(
        name: 'Docs_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Row(children: [Text('LuDeveloper')])
        ],
      );

  static Widget tableProducts(List<ForPaid> listProduct, ForPaid item) {
    final headers = [
      '# ORDEN',
      'NOTA',
      'FECHA',
      'REGISTRADO',
    ];

    final data = listProduct
        .map((producto) => [
              item.fDocumento.toString(),
              producto.interComent.toString(),
              producto.interHora.toString(),
              producto.interRegited.toString(),
            ])
        .toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown100),
      ),
      tableWidth: TableWidth.max,
      cellStyle: const TextStyle(fontSize: 5),
      headerStyle: const TextStyle(fontSize: 7),
      cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      columnWidths: {
        1: const FixedColumnWidth(150),
        // 5: const FixedColumnWidth(100),
      },
      headerDecoration: const BoxDecoration(color: PdfColors.grey100),
    );
  }

  static Widget buildPaymentInfoRowImagen(String label, image) {
    const style = TextStyle(fontSize: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(color: PdfColors.black, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Image(image, height: 150, width: 150),
      ]),
    );
  }

  static Widget buildPaymentInfoRow(String label, String value) {
    const style = TextStyle(fontSize: 8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: style),
        ],
      ),
    );
  }
}
