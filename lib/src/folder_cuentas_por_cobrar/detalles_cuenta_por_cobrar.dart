import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/add_cuenta_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/print_cuentas/print_detalles_cuentas_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/provider/provider_cuentas_por_cobrar.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/widgets/loading.dart';

import '../screen_print_pdf/apis/pdf_api.dart';
import 'model/cuentas_por_cobrar.dart';

class DetallesCuentaPorCobrar extends StatefulWidget {
  const DetallesCuentaPorCobrar({super.key, required this.item});
  final CuentaPorCobrar item;
  @override
  State<DetallesCuentaPorCobrar> createState() =>
      _DetallesCuentaPorCobrarState();
}

class _DetallesCuentaPorCobrarState extends State<DetallesCuentaPorCobrar> {
  List<CuentaPorCobrar> listCuentaPorPagarFilter = [];

  Future getDetallesOrdenPagos() async {
    debugPrint('Get Detalles de la orden ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_detalles_pagos.php";
    var data = {
      'token': token,
      'cuenta_por_cobrar_id': widget.item.id,
    };
    final res = await httpRequestDatabase(url, data);
    // print(res.body);
    setState(() {
      listCuentaPorPagarFilter = cuentaPorCobrarFromJson(res.body);
    });
  }

  @override
  void initState() {
    getDetallesOrdenPagos();
    super.initState();
  }

  Future<void> deletePagos(CuentaPorCobrar item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌ Esta seguro de eliminar este Pagos? ❌',
          titulo: 'Alerta',
          onConfirmar: () async {
            Navigator.of(context).pop();
            String url =
                "http://$ipLocal/settingmat/admin/delete/delete_pagos_cuenta_por_cobrar.php";
            var data = {'id': item.id};
            await httpRequestDatabase(url, data);
            if (!mounted) {
              return;
            }
            // scaffoldMensaje(
            //     context: context, background: Colors.red, mjs: mjs.body);
            await Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
                .getCuentasPorCobrar();
            getDetallesOrdenPagos();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: () async {
                  if (listCuentaPorPagarFilter.isNotEmpty) {
                    final docs = await PrintDetallesCuentasPorCobrar.generate(
                        listCuentaPorPagarFilter);
                    await PdfApi.openFile(docs);
                  }
                },
                icon: const Icon(Icons.print)),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BounceInDown(
                //     child: SizedBox(
                //         height: 50, width: 50, child: Image.asset(logoApp))),
                // const SizedBox(width: 15),
                Column(
                  children: [
                    Bounce(
                      child: Text('Hello ! ${currentUsers?.fullName}',
                          style: style.labelSmall?.copyWith(
                              letterSpacing: 1,
                              fontSize: 10,
                              color: Colors.grey)),
                    ),
                    SlideInRight(
                      child: Text('Detalles de pagos'.toUpperCase(),
                          style: style.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.black45)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          listCuentaPorPagarFilter.isNotEmpty
              ? Text(
                  '${listCuentaPorPagarFilter.first.nombre} ${listCuentaPorPagarFilter.first.apellido}',
                  style: style.labelSmall
                      ?.copyWith(letterSpacing: 1, color: Colors.black45))
              : const SizedBox(),
          listCuentaPorPagarFilter.isEmpty
              ? const Expanded(
                  child: Center(child: Loading(text: 'No hay Pagos')))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 20,
                          dataRowMinHeight: 10,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          dataTextStyle: style.bodySmall,
                          headingTextStyle: style.labelSmall,
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none)),
                          columns: const [
                            DataColumn(label: Text('#ID')),
                            DataColumn(label: Text('#ORDEN')),
                            DataColumn(label: Text('PAGADO')),
                            DataColumn(label: Text('FECHA PAGO')),
                            DataColumn(label: Text('REALIZADO POR')),
                            DataColumn(label: Text('ELIMINAR')),
                          ],
                          rows: listCuentaPorPagarFilter
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item.id ?? 'N/A')),
                                    DataCell(Text(item.numOrden ?? 'N/A')),
                                    DataCell(Text(
                                        '\$ ${getNumFormatedDouble(item.montoPagado ?? '0')}',
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600))),
                                    DataCell(Text(item.fechaPago ?? 'N/A')),
                                    DataCell(Text(item.usuario ?? 'N/A')),
                                    DataCell(
                                        Text(
                                            validarContable()
                                                ? 'Eliminar'
                                                : 'Not Suport',
                                            style: const TextStyle(
                                                color: Colors.red)), onTap: () {
                                      validarContable()
                                          ? deletePagos(item)
                                          : () {};
                                    }),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          listCuentaPorPagarFilter.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Pagos : ',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        listCuentaPorPagarFilter.length
                                            .toString(),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pendientes : ',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        getNumFormatedDouble(
                                            CuentaPorCobrar.getTotalPendiente(
                                                listCuentaPorPagarFilter)),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pagados  : ', style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        getNumFormatedDouble(
                                            CuentaPorCobrar.getMontoPagadoItem(
                                                listCuentaPorPagarFilter)),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Faltantes : ',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        getNumFormatedDouble(
                                            CuentaPorCobrar.getRestar(
                                                CuentaPorCobrar.getTotalPendiente(
                                                    listCuentaPorPagarFilter),
                                                CuentaPorCobrar.getMontoPagadoItem(
                                                    listCuentaPorPagarFilter))),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          identy(context)
        ],
      ),
    );
  }
}
