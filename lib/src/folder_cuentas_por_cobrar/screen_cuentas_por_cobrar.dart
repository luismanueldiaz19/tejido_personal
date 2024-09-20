import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/add_cuenta_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/detalles_cuenta_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/historial_screen_cuentas_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/print_cuentas/print_cuentas_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/provider/provider_cuentas_por_cobrar.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/loading.dart';
import 'package:tejidos/src/widgets/mensaje_scaford.dart';

import '../widgets/drop_down_menu_estado.dart';
import '../widgets/widget_comentario.dart';
import 'model/cuentas_por_cobrar.dart';

class ScreenCuentasPorCobrar extends StatefulWidget {
  const ScreenCuentasPorCobrar({super.key});

  @override
  State<ScreenCuentasPorCobrar> createState() => _ScreenCuentasPorCobrarState();
}

class _ScreenCuentasPorCobrarState extends State<ScreenCuentasPorCobrar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
          .getCuentasPorCobrar();
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
    // update_estado_cuentas_por_cobrar
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: DropDownMenuEstado(
            isAdd: !CuentaPorCobrar.getValidaBalance(item),
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
              child: const Text('Actualizar'),
              onPressed: () async {
                print('Data : ${item.toJson()}');
                await Provider.of<ProviderCuentasPorCobrar>(context,
                        listen: false)
                    .updateEstadoCuentasPorCobrar(item.toJson());
                if (!mounted) {
                  return;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future notaUpdate(CuentaPorCobrar item) async {
    if (validatorUser()) {
      String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return const AddComentario(
            text: 'Poner Nota',
            textInputType: TextInputType.text,
            textFielName: 'Escribir nota',
          );
        },
      );

      if (valueCant != null) {
        if (item.nota == 'N/A') {
          item.nota = '';
        }
        item.nota =
            '${item.nota} ${valueCant.toString()} (${DateTime.now().toString().substring(0, 19)} Por ${currentUsers?.fullName}). ';
        if (!mounted) {
          return;
        }
        final mjs =
            await Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
                .updateEstadoCuentasPorCobrar(item.toJson());
        if (!mounted) {
          return;
        }
        scaffoldMensaje(context: context, background: Colors.brown, mjs: mjs);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    print(size.width);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas Por Cobrar'),
        actions: [
          size.width > 600
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Provider.of<ProviderCuentasPorCobrar>(context,
                                  listen: false)
                              .normalizarList();
                        },
                        icon: const Icon(Icons.filter_alt_off_outlined),
                      ),
                    ),
                    !validatorUser()
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (conext) =>
                                          const AddCuentaPorCobrar(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add)),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HistorialScreenCuentasPorCobrar()),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () async {
                          if (Provider.of<ProviderCuentasPorCobrar>(context,
                                  listen: false)
                              .listCuentaPorPagarFilter
                              .isNotEmpty) {
                            final docs = await PrintCuentasPorCobrar.generate(
                              Provider.of<ProviderCuentasPorCobrar>(context,
                                      listen: false)
                                  .listCuentaPorPagarFilter,
                            );
                            await PdfApi.openFile(docs);
                          }
                        },
                        icon: const Icon(Icons.print),
                      ),
                    ),
                  ],
                )
              : PopupMenuButton<int>(
                  onSelected: (int index) async {
                    switch (index) {
                      case 1:
                        Provider.of<ProviderCuentasPorCobrar>(context,
                                listen: false)
                            .normalizarList();
                        break;
                      case 2:
                        !validatorUser()
                            ? null
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddCuentaPorCobrar(),
                                ),
                              );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HistorialScreenCuentasPorCobrar(),
                          ),
                        );
                        break;
                      case 4:
                        if (Provider.of<ProviderCuentasPorCobrar>(context,
                                listen: false)
                            .listCuentaPorPagarFilter
                            .isNotEmpty) {
                          final docs = await PrintCuentasPorCobrar.generate(
                            Provider.of<ProviderCuentasPorCobrar>(context,
                                    listen: false)
                                .listCuentaPorPagarFilter,
                          );
                          await PdfApi.openFile(docs);
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.filter_alt_off_outlined),
                        title: Text('Normalizar List'),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: ListTile(
                        leading: const Icon(Icons.add),
                        title: !validatorUser()
                            ? const Text('Not Soport')
                            : const Text('Add Cuenta Por Cobrar'),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Icons.calendar_month),
                        title: Text('Historial'),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 4,
                      child: ListTile(
                        leading: Icon(Icons.print),
                        title: Text('Print'),
                      ),
                    ),
                  ],
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
                BounceInDown(
                    child: SizedBox(
                        height: 50, width: 50, child: Image.asset(logoApp))),
                const SizedBox(width: 15),
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
                      child: Text(nameApp.toUpperCase(),
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
          Container(
            color: Colors.white54,
            width: 250,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) =>
                  Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
                      .seachingCuentas(val),
              decoration: InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  hintStyle: style.labelSmall,
                  contentPadding: const EdgeInsets.only(bottom: 7),
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Icon(Icons.search, size: 16),
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<ProviderCuentasPorCobrar>(
            builder: (context, provider, child) {
              if (provider.listCuentaPorPagarFilter.isEmpty) {
                return const Center(
                    child: Loading(text: 'No Hay Cuentas por Cobrar'));
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
                        DataColumn(label: Text('PENDIENTE')),
                        DataColumn(label: Text('PAGADO')),
                        DataColumn(label: Text('FALTANTES')),
                        DataColumn(label: Text('FECHA VENCIMIENTO')),
                        DataColumn(label: Text('PAGO')),
                        DataColumn(label: Text('DETALLES')),
                        DataColumn(label: Text('NOTA')),
                      ],
                      rows: provider.listCuentaPorPagarFilter
                          .map(
                            (item) => DataRow(
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
                                  provider.seachingItem(
                                      item.nombre ?? 'Activo', true);
                                }),
                                DataCell(Text(item.numOrden ?? 'N/A')),
                                DataCell(Text(item.estado ?? 'N/A'), onTap: () {
                                  validarContable()
                                      ? updateEstado(item)
                                      : () {};
                                }, onLongPress: () {
                                  provider.seachingItem(
                                      item.estado ?? 'Activo', false);
                                }),
                                DataCell(Text(
                                  '\$ ${getNumFormatedDouble(item.montoPendiente ?? 'N/A')}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )),
                                DataCell(Text(
                                  '\$ ${getNumFormatedDouble(item.totalMontoPagado ?? '0')}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                )),
                                DataCell(
                                  Text(
                                    '\$ ${getNumFormatedDouble(CuentaPorCobrar.getRestante(item))}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataCell(Text(item.fechaVencimiento ?? 'N/A')),
                                DataCell(
                                  const Text(
                                    'Pagar',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    validarContable()
                                        ? realizarPago(item)
                                        : () {};
                                  },
                                ),
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
                                            DetallesCuentaPorCobrar(
                                                item: item)),
                                  );
                                }),
                                DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: Text(item.nota ?? 'N/A',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ), onLongPress: () {
                                  notaUpdate(item);
                                }, onTap: () {
                                  getMensajeWidget(context, item.nota ?? 'N/A',
                                      text: 'Nota');
                                }),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          SizedBox(
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
                                      .listCuentaPorPagarFilter
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
                                              .listCuentaPorPagarFilter)),
                                  style: style.bodySmall?.copyWith(
                                      color: Colors.black,
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
                                              .listCuentaPorPagarFilter)),
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
                                              .listCuentaPorPagarFilter),
                                      CuentaPorCobrar.getTotalPagado(
                                          Provider.of<ProviderCuentasPorCobrar>(
                                                  context,
                                                  listen: true)
                                              .listCuentaPorPagarFilter))),
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
