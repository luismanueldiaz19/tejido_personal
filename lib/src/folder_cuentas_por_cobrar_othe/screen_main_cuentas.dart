import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/provider/provider_cuentas_por_cobrar.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/detalles_intervenciones.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/list_por_days.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import 'package:tejidos/src/util/get_time_relation.dart';
import 'package:tejidos/src/widgets/widget_comentario.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/dialog_confimarcion.dart';
import '../util/get_formatted_number.dart';
import '../util/show_mesenger.dart';
import '../widgets/loading.dart';
import '../widgets/picked_date_widget.dart';
import 'add_cuenta_por_cobrar.dart';
import 'print/print_main_for_paid.dart';

class ScreenMainCuentas extends StatefulWidget {
  const ScreenMainCuentas({super.key});

  @override
  State<ScreenMainCuentas> createState() => _ScreenMainCuentasState();
}

class _ScreenMainCuentasState extends State<ScreenMainCuentas> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
          .getPorCobrar(getStartAndEndOfMonth()[0], getStartAndEndOfMonth()[1]);
    });

    super.initState();
  }

  void getInfor(ForPaid item) {
    getMensajeWidget(context,
        "Numero de Orden : ${item.fDocumento ?? 'N/A'}, Para el cliente :  ${item.fNombre ?? 'N/A'} , Tel: ${item.fTelefono ?? 'N/A'} ,   con un balance : \$ ${item.fBalance ?? 'N/A'}.",
        text: 'Información Cliente');
  }

  void changeStatu(ForPaid item) {
    if (validarContable()) {
      if (item.statuPaid == 'f') {
        item.statuPaid = 't';
      } else {
        item.statuPaid = 'f';
      }
      if (!mounted) {
        return;
      }
      Provider.of<ProviderCuentasPorCobrar>(context, listen: false).updateFrom(
          item, getStartAndEndOfMonth()[0], getStartAndEndOfMonth()[1]);
    }
  }

  void addSeguimiento(ForPaid item) async {
    if (validarContable()) {
      String? valueCant = await showDialog<String>(
          context: context,
          builder: (context) {
            return const AddComentario(
                text: 'Seguimiento',
                textInputType: TextInputType.text,
                textFielName: 'Escribir Nota');
          });

      if (valueCant != null) {
        // print(valueCant);
        item.interComent = valueCant.toUpperCase();
        item.interRegited = currentUsers?.fullName?.toUpperCase();
        item.interHora = DateTime.now().toString().substring(0, 19);
        if (!mounted) {
          return;
        }
        final res = Provider.of<ProviderCuentasPorCobrar>(context,
                listen: false)
            .insertSegumiento(
                item, getStartAndEndOfMonth()[0], getStartAndEndOfMonth()[1]);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res.toString())));
      }
    }
  }

  void addAproveds(ForPaid item) async {
    if (validarContable()) {
      String? valueCant = await showDialog<String>(
          context: context,
          builder: (context) {
            return const AddComentario(
              text: 'Aprobador por',
              textInputType: TextInputType.text,
              textFielName: 'Nombre',
            );
          });

      if (valueCant != null) {
        item.aproved = valueCant.toUpperCase();
        if (!mounted) {
          return;
        }
        Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
            .updateFrom(
                item, getStartAndEndOfMonth()[0], getStartAndEndOfMonth()[1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final providerLocal =
        Provider.of<ProviderCuentasPorCobrar>(context, listen: true)
            .listForPaidFilter;
    final listAproved =
        Provider.of<ProviderCuentasPorCobrar>(context, listen: true)
            .listForPaid;

    return ScaffoldMessenger(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas Por Cobrar'),
        actions: [
          size.width > 600
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () async {
                            final date =
                                await showDatePickerCustom(context: context);
                            if (date != null) {
                              if (!mounted) {
                                return;
                              }
                              Provider.of<ProviderCuentasPorCobrar>(context,
                                      listen: false)
                                  .getPorCobrar(
                                      getStartParser(DateTime.parse(date))[0],
                                      getStartParser(DateTime.parse(date))[1]);
                            }
                          },
                          icon: const Icon(Icons.edit_calendar_outlined)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<ProviderCuentasPorCobrar>(context,
                                listen: false)
                            .normalizarFoPaid();
                      },
                      onDoubleTap: () {
                        Provider.of<ProviderCuentasPorCobrar>(context,
                                listen: false)
                            .serachingPagado();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: Text('Ver Pagados')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // listAproved.isNotEmpty
                    //     ? const SizedBox()
                    //     :

                    validarContable()
                        ? Padding(
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
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListPorDays()),
                          );
                        },
                        icon: const Icon(Icons.list),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () async {
                          if (providerLocal.isNotEmpty) {
                            final docs = await PrintMainForPaid.generate(
                                providerLocal,
                                DateTime.now().toString().substring(0, 19));
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
                        break;
                      case 2:
                        listAproved.isNotEmpty
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
                              builder: (context) => const ListPorDays()),
                        );
                        break;
                      case 4:
                        if (providerLocal.isNotEmpty) {
                          final docs = await PrintMainForPaid.generate(
                              providerLocal,
                              DateTime.now().toString().substring(0, 19));
                          await PdfApi.openFile(docs);
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    // const PopupMenuItem<int>(
                    //   value: 1,
                    //   child: ListTile(
                    //     leading: Icon(Icons.filter_alt_off_outlined),
                    //     title: Text('Normalizar List'),
                    //   ),
                    // ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Add Cuenta Por Cobrar'),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Icons.list),
                        title: Text('Seguimientos'),
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
          Container(
            color: Colors.white54,
            width: 250,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) =>
                  Provider.of<ProviderCuentasPorCobrar>(context, listen: false)
                      .serachingList(val),
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
          Expanded(
            child: Consumer<ProviderCuentasPorCobrar>(
              builder: (context, provider, child) {
                if (provider.listForPaidFilter.isEmpty) {
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
                        headingRowHeight: 20,
                        headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue.shade100),
                        // dataRowColor: MaterialStateProperty.resolveWith(
                        //     (states) => Colors.red),
                        border: TableBorder.symmetric(
                            outside: BorderSide(
                                color: Colors.grey.shade100,
                                style: BorderStyle.none)),
                        columns: const [
                          DataColumn(label: Text('#ORDEN')),
                          DataColumn(label: Text('CLIENTES')),
                          DataColumn(label: Text('MONTO')),
                          DataColumn(label: Text('PAGADO')),
                          DataColumn(label: Text('BALANCE')),
                          DataColumn(label: Text('SEGUIMIENTOS')),
                          DataColumn(label: Text('DIAS')),
                          DataColumn(label: Text('CREADO EN')),
                          DataColumn(label: Text('FECHA VENCIMIENTO')),
                          DataColumn(label: Text('REPORTAR PAGO')),
                          DataColumn(label: Text('AGREGAR SEGUIMIENTO')),
                          DataColumn(label: Text('APROBADOR POR')),
                          DataColumn(label: Text('ELIMINAR')),
                        ],
                        rows: provider.listForPaidFilter
                            .map(
                              (item) => DataRow(
                                color: MaterialStateProperty.resolveWith(
                                    (states) =>
                                        ForPaid.getColorFromStatus(item)),
                                cells: [
                                  DataCell(Text(item.fDocumento ?? 'N/A')),
                                  DataCell(
                                      SizedBox(
                                        width: 150,
                                        child: Text(item.fNombre ?? 'N/A',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ), onTap: () {
                                    getInfor(item);
                                  }, onDoubleTap: () {
                                    Provider.of<ProviderCuentasPorCobrar>(
                                            context,
                                            listen: false)
                                        .serachingListByClient(item.fNombre
                                            .toString()
                                            .toUpperCase());
                                  }, onLongPress: () {
                                    Provider.of<ProviderCuentasPorCobrar>(
                                            context,
                                            listen: false)
                                        .normalizarFoPaid();
                                  }),
                                  DataCell(Text(
                                    '\$ ${getNumFormatedDouble(item.fMonto!.replaceAll(RegExp(r'[a-zA-Z]'), '') // Reemplazar todas las letras por un String vacío
                                        .replaceAll('\$', '') // Eliminar el signo de dólar
                                        .replaceAll('-', '0'))}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )),
                                  DataCell(Text(
                                      '\$ ${item.statuPaid == 't' ? '0' : ForPaid.restaItem(item)}',
                                      style: TextStyle(
                                          color: Colors.green.shade600,
                                          fontWeight: FontWeight.w600))),
                                  DataCell(Text(
                                    '\$ ${getNumFormatedDouble(item.statuPaid == 't' ? item.fMonto!.replaceAll(RegExp(r'[a-zA-Z]'), '') // Reemplazar todas las letras por un String vacío
                                        .replaceAll('\$', '') // Eliminar el signo de dólar
                                        .replaceAll('-', '0') : item.fBalance!.replaceAll(RegExp(r'[a-zA-Z]'), '') // Reemplazar todas las letras por un String vacío
                                        .replaceAll('\$', '') // Eliminar el signo de dólar
                                        .replaceAll('-', '0'))}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )),
                                  DataCell(
                                      Center(
                                          child: Text(item.numInter ?? 'N/A')),
                                      onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetallesIntervenciones(
                                                  item: item)),
                                    );
                                  }, onLongPress: () {
                                    // provider.seachingItem(
                                    //     item.estado ?? 'Activo', false);
                                  }),
                                  DataCell(
                                      Center(child: Text(item.dias ?? 'N/A'))),
                                  DataCell(Text(item.fFecha ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      item.fFechaVencimiento ?? 'N/A',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.statuPaid == 't'
                                          ? 'Pagado'
                                          : 'Reportar Pagado',
                                      style: TextStyle(
                                          color: item.statuPaid == 't'
                                              ? Colors.teal
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onDoubleTap: () => changeStatu(item),
                                  ),
                                  DataCell(
                                      const Center(
                                          child: Text('AGREGAR',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      onTap: () => addSeguimiento(item)),
                                  DataCell(Text(item.aproved ?? 'N/A'),
                                      onDoubleTap: () => addAproveds(item)),
                                  DataCell(const Text('Eliminar'),
                                      onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmacionDialog(
                                          mensaje:
                                              '❌❌Esta Seguro de Eliminar❌❌',
                                          titulo: 'Aviso',
                                          onConfirmar: () async {
                                            Provider.of<ProviderCuentasPorCobrar>(
                                                    context,
                                                    listen: false)
                                                .deleteFrom(
                                                    item.idPorPagar,
                                                    getStartAndEndOfMonth()[0],
                                                    getStartAndEndOfMonth()[1]);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
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
          ),
          const SizedBox(height: 10),
          providerLocal.isEmpty
              ? const SizedBox()
              : SizedBox(
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
                                  Text('Total : ', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(providerLocal.length.toString(),
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
                          decoration: BoxDecoration(color: Colors.red.shade300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Vencidos :',
                                      style: style.bodySmall
                                          ?.copyWith(color: Colors.white)),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          ForPaid.getTotalVencidos(
                                              providerLocal)),
                                      style: style.bodySmall?.copyWith(
                                          color: Colors.white,
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
                                  Text('Percent :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      '${ForPaid.getPercent(ForPaid.getTotalVencidos(providerLocal), providerLocal.length.toString())} %',
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
                                  Text('Monto :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          ForPaid.getTotalMonto(providerLocal)),
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
                                  Text('Pagado : ', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  //ForPaid.getPercent
                                  Text(
                                    getNumFormatedDouble(
                                        providerLocal.first.statuPaid == 't'
                                            ? '0'
                                            : ForPaid.getTotalRestate(
                                                providerLocal)),
                                    style: style.bodySmall?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                  Text('RD\$ Pagado :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      '${ForPaid.getPercent(providerLocal.first.statuPaid == 't' ? '0' : ForPaid.getTotalRestate(providerLocal), ForPaid.getTotalMonto(providerLocal))} %',
                                      style: style.bodySmall),
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
                                  Text('Balance :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(providerLocal
                                                  .first.statuPaid ==
                                              't'
                                          ? ForPaid.getTotalMonto(providerLocal)
                                          : ForPaid.getTotalBalance(
                                              providerLocal)),
                                      style: style.bodySmall?.copyWith(
                                          color: Colors.black,
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
    ));
  }
}
