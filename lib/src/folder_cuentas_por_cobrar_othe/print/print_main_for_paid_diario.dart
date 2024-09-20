import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';

import '../../datebase/current_data.dart';

class PrintMainForPaidDiario {
  PrintMainForPaidDiario();

  static Future<File> generate(List<ForPaid> listPlani, String fecha) async {
    final pdf = Document();
    final imageLogo2 = MemoryImage(
        (await rootBundle.load('assets/liquidez_de_la_empresa.jpg'))
            .buffer
            .asUint8List());
    const style = TextStyle(fontSize: 8);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('Lista de seguimientos', imageLogo2),
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

        SizedBox(height: 1 * PdfPageFormat.cm / 3),
        Text('DETALLES', style: style.copyWith(color: PdfColors.black)),
        SizedBox(height: 1 * PdfPageFormat.cm / 5),
        tableProducts(listPlani),
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
                      child:
                          Text('Total : ${listPlani.length}', style: style))),
              SizedBox(width: 10),
              Container(
                  height: 25,
                  child: Center(
                      child: Text(
                          'Monto : ${getNumFormatedDouble(ForPaid.getTotalMonto(listPlani))}',
                          style: style))),
              SizedBox(width: 10),
              Container(
                  height: 25,
                  child: Center(
                      child: Text(
                          'Pagado : ${getNumFormatedDouble(ForPaid.getTotalRestate(listPlani))}',
                          style: style))),
              SizedBox(width: 10),
              Container(
                  height: 25,
                  child: Center(
                      child: Text(
                          'Balance : ${getNumFormatedDouble(ForPaid.getTotalBalance(listPlani))}',
                          style: style))),
            ],
          ),
        ),
        Divider(color: PdfColors.grey),
        SizedBox(height: 5 * PdfPageFormat.cm / 2),
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

  static Widget tableProducts(List<ForPaid> listProduct) {
    final headers = [
      '#ORDEN',
      'CLIENTES',
      'MONTO',
      'PAGADO',
      'BALANCE',
      'NOTA',
      'REGISTED'
    ];

    final data = listProduct
        .map((producto) => [
              producto.fDocumento.toString(),
              producto.fNombre.toString(),
              '\$ ${getNumFormatedDouble(producto.fMonto ?? 'N/A')}',
              '\$ ${ForPaid.restaItem(producto)}',
              '\$ ${getNumFormatedDouble(producto.fBalance ?? '0')}',
              producto.interComent.toString(),
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
        2: const FixedColumnWidth(50),
        5: const FixedColumnWidth(100),
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
