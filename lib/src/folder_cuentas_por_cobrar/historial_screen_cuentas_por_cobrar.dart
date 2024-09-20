import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/detalles_cuenta_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/provider/provider_cuentas_por_cobrar.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/loading.dart';
import 'package:tejidos/src/widgets/mensaje_scaford.dart';

import '../widgets/drop_down_menu_estado.dart';
import '../widgets/widget_comentario.dart';
import 'model/cuentas_por_cobrar.dart';

class HistorialScreenCuentasPorCobrar extends StatefulWidget {
  const HistorialScreenCuentasPorCobrar({super.key});

  @override
  State<HistorialScreenCuentasPorCobrar> createState() =>
      _HistorialScreenCuentasPorCobrarState();
}

class _HistorialScreenCuentasPorCobrarState
    extends State<HistorialScreenCuentasPorCobrar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
          .getStoryCuentasPorCobrar();
    });

    super.initState();
  }

  Future<void> realizarPago(CuentaPorCobrar item) async {
    // print(item)
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return AddComentario(
            text: 'Monto a Pagar',
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            textFielName: 'Monto',
          );
        });

    if (valueCant != null) {
      item.cuentaPorCobrarId = item.id;
      item.fechaPago = DateTime.now().toString().substring(0, 10);
      item.usuario = currentUsers?.fullName.toString();
      item.montoPagado = valueCant.toString();
      item.totalMontoPagado = '0.0';

      if (!mounted) {
        return;
      }
      final mjs =
          await Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
              .addPagosCuentasPorCobrar(item.toJson());
      if (!mounted) {
        return;
      }
      scaffoldMensaje(context: context, background: Colors.orange, mjs: mjs);
    }

    //
  }

  void getInfor(CuentaPorCobrar item) {
    getMensajeWidget(context,
        "${item.nombre ?? 'N/A'} ${item.apellido ?? 'N/A'} -${item.telefono ?? 'N/A'} ${item.correoElectronico ?? 'N/A'}-${item.direccion ?? 'N/A'}",
        text: 'Información Cliente');
  }

  Future updateEstado(CuentaPorCobrar item) async {
    // print(item.toJson());
    item.totalMontoPagado = '0';
    item.cuentaPorCobrarId = '0';
    item.fechaPago = '0';
    item.montoPagado = '0';
    item.usuario = currentUsers!.fullName;
    // update_estado_cuentas_por_cobrar
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: DropDownMenuEstado(
            onPressed: (valuel) {
              item.estado = valuel;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () async {
                // print('Ahora');
                // print(item.toJson());
                Navigator.of(context).pop();
                await Provider.of<ProviderCuentasPorCobrar>(context,
                        listen: false)
                    .updateEstadoCuentasPorCobrar(item.toJson());
                if (!mounted) {
                  return;
                }
                await Provider.of<ProviderCuentasPorCobrar>(context,
                        listen: false)
                    .getStoryCuentasPorCobrar();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Cuentas Por Cobrar'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
                    .normalizarListStory();
              },
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.print),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Consumer<ProviderCuentasPorCobrar>(
              builder: (context, provider, child) {
            if (provider.storyListCuentaPorPagarFilter.isEmpty) {
              return const Center(
                  child: Loading(text: 'Cargando Cuentas por Cobrar'));
            }
            return Padding(
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
                      DataColumn(label: Text('CLIENTES')),
                      DataColumn(label: Text('#ORDEN')),
                      DataColumn(label: Text('ESTADO')),
                      DataColumn(label: Text('MONTO')),
                      DataColumn(label: Text('PAGADO')),
                      DataColumn(label: Text('FECHA VENCIMIENTO')),
                      DataColumn(label: Text('DETALLES')),
                    ],
                    rows: provider.storyListCuentaPorPagarFilter
                        .map((item) => DataRow(
                                color: MaterialStateProperty.resolveWith(
                                    (states) =>
                                        CuentaPorCobrar.getColorFromStatus(
                                            item.estado ?? 'Activo')),
                                cells: [
                                  DataCell(Text(item.id ?? 'N/A')),
                                  DataCell(
                                      Text(
                                          '${item.nombre ?? 'N/A'} ${item.apellido ?? 'N/A'}'),
                                      onTap: () {
                                    getInfor(item);
                                  }, onLongPress: () {
                                    provider.seachingItemStory(
                                        item.nombre ?? 'Activo');
                                  }),
                                  DataCell(Text(item.numOrden ?? 'N/A')),
                                  DataCell(Text(item.estado ?? 'N/A'),
                                      onTap: () {
                                    validarContable()
                                        ? updateEstado(item)
                                        : () {};
                                  }),
                                  DataCell(Text(
                                    getNumFormatedDouble(
                                        item.montoPendiente ?? 'N/A'),
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600),
                                  )),
                                  DataCell(Text(
                                    getNumFormatedDouble(
                                        item.totalMontoPagado ?? '0'),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  )),
                                  DataCell(
                                      Text(item.fechaVencimiento ?? 'N/A')),
                                  DataCell(
                                      const Text('Detalles',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w600)),
                                      onTap: () {
                                    // deleteFromTrabajo(item);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetallesCuentaPorCobrar(item: item),
                                      ),
                                    );
                                  }),
                                ]))
                        .toList(),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            height: 35,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 35,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Total Cuentas : ', style: style.bodySmall),
                            const SizedBox(width: 10),
                            Text(
                                Provider.of<ProviderCuentasPorCobrar>(context,
                                        listen: true)
                                    .storyListCuentaPorPagarFilter
                                    .length
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
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Pendientes : ', style: style.bodySmall),
                            const SizedBox(width: 10),
                            Text(
                                getNumFormatedDouble(
                                    CuentaPorCobrar.getTotalPendiente(
                                        Provider.of<ProviderCuentasPorCobrar>(
                                                context,
                                                listen: true)
                                            .storyListCuentaPorPagarFilter)),
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
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Pagados  : ', style: style.bodySmall),
                            const SizedBox(width: 10),
                            Text(
                                getNumFormatedDouble(
                                    CuentaPorCobrar.getTotalPagado(
                                        Provider.of<ProviderCuentasPorCobrar>(
                                                context,
                                                listen: true)
                                            .storyListCuentaPorPagarFilter)),
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
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Faltantes : ', style: style.bodySmall),
                            const SizedBox(width: 10),
                            Text(
                                getNumFormatedDouble(CuentaPorCobrar.getRestar(
                                    CuentaPorCobrar.getTotalPendiente(
                                        Provider.of<ProviderCuentasPorCobrar>(
                                                context,
                                                listen: true)
                                            .storyListCuentaPorPagarFilter),
                                    CuentaPorCobrar.getTotalPagado(
                                        Provider.of<ProviderCuentasPorCobrar>(
                                                context,
                                                listen: true)
                                            .storyListCuentaPorPagarFilter))),
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
          identy(context)
        ],
      ),
    );
  }
}
