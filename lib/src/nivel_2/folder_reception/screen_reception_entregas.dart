import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/add_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_re_orden/dialog_reorden_record.dart';
import 'package:tejidos/src/nivel_2/folder_reception/historia_record/screen_record_reception.dart';
import 'package:tejidos/src/nivel_2/folder_reception/custom_delegate_searching.dart';
import 'package:tejidos/src/nivel_2/folder_reception/seguimiento_orden.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/get_formatted_number.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import '../../datebase/url.dart';
import '../../util/dialog_confimarcion.dart';
import '../../widgets/pick_range_date.dart';
import '../../widgets/picked_date_widget.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../folder_planificacion/url_planificacion/url_planificacion.dart';
import '../folder_re_orden/dialog_reorden.dart';
import '../folder_re_orden/model/reorden.dart';
import 'folder_admin_re_orden/screen_admin_re_orden.dart';
import 'folder_historia_cliente_orden/screen_historia_cliente_orden.dart';
import 'print_reception/print_reception_orden.dart';

class ScreenReceptionEntregas extends StatefulWidget {
  const ScreenReceptionEntregas({Key? key}) : super(key: key);

  @override
  State<ScreenReceptionEntregas> createState() =>
      _ScreenReceptionEntregasState();
}

class _ScreenReceptionEntregasState extends State<ScreenReceptionEntregas> {
  List<PlanificacionLast> planificacionList = [];
  List<PlanificacionLast> planificacionListFilter = [];
  String modoEstado = "";
  String usuario = "";
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ReOrden> listReOrden = [];

  ///ordenes no entregado
  Future getReception() async {
    final res = await httpRequestDatabase(
        selectPlanificacionLast, {'date1': firstDate, 'date2': secondDate});
    // print(res.body);
    planificacionList = planificacionLastFromJson(res.body);
    planificacionListFilter = List.from(planificacionList);
    setState(() {});
  }

  void shomMjs(String msj) => utilShowMesenger(context, msj);

  ///ordenes no entregado
  Future getMonthly(date1, date2) async {
    setState(() {
      planificacionList.clear();
      planificacionListFilter.clear();
    });
    final res = await httpRequestDatabase(
        selectPlanificacionByMothEntregas, {'date1': date1, 'date2': date2});
    planificacionList = planificacionLastFromJson(res.body);

    setState(() {
      planificacionListFilter = planificacionList;
    });
  }

  Future getMonthlyCreated(date1, date2) async {
    setState(() {
      planificacionList.clear();
      planificacionListFilter.clear();
    });
    final res = await httpRequestDatabase(
        selectPlanificacionByMonthlyCreated, {'date1': date1, 'date2': date2});
    planificacionList = planificacionLastFromJson(res.body);

    setState(() {
      planificacionListFilter = planificacionList;
    });
  }

  @override
  void initState() {
    super.initState();
    getReorden();
    getReception();
  }

  Future deleleFromRecord(PlanificacionLast item) async {
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta seguro de eliminar esto?❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              Navigator.of(context).pop();
              shomMjs(mjs) => utilShowMesenger(context, mjs);
              final res = await httpRequestDatabase(deletePlanificacionLast,
                  {'id': '${item.isKeyUniqueProduct}'});

              // print(res.body);
              if (res.body.toString().contains(
                  'Key (is_key_unique_product)=(${item.isKeyUniqueProduct})')) {
                shomMjs(
                    'Tiene que eliminar los producto que existen de esta orden');
              }
            },
          );
        });
  }

  String totalOrdenEntregar(List<PlanificacionLast> list) {
    var listll = List.from(list
        .where((x) => x.statu!.toUpperCase() == onEntregar.toUpperCase())
        .toList());

    return listll.length.toString();
  }

  Future searchingOrden(String val) async {
    if (val.isNotEmpty) {
      planificacionListFilter = List.from(planificacionList
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
              x.clienteTelefono!.toUpperCase().contains(val.toUpperCase()) ||
              x.cliente!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      setState(() {
        planificacionListFilter = [...planificacionList];
      });
    }
  }

  atrasada() {
    List<PlanificacionLast> lisLocal = [];
    for (var item in planificacionList) {
      if (PlanificacionLast.comparaTime(
              DateTime.parse(item.fechaEntrega ?? '')) &&
          item.statu?.toUpperCase() != onEntregar.toUpperCase()) {
        lisLocal.add(item);
      }
    }
    planificacionListFilter = lisLocal;
    setState(() {});
  }

  String getTotalAtrasada(List<PlanificacionLast> listss) {
    int value = 0;
    for (var item in listss) {
      if (PlanificacionLast.comparaTime(
              DateTime.parse(item.fechaEntrega ?? '')) &&
          item.statu?.toUpperCase() != onEntregar.toUpperCase()) {
        value++;
      }
    }
    return value.toString();
  }

  searchingEstadoEmpleado() {
    setState(() {
      planificacionListFilter = List.from(planificacionList
          .where((x) =>
              x.userRegistroOrden!.toUpperCase() == usuario.toUpperCase() &&
              x.statu!.toUpperCase() == modoEstado.toUpperCase())
          .toList());
    });
  }

  normalizarWithRegisterOrden() {
    setState(() {
      planificacionListFilter = planificacionList
          .where((element) =>
              element.userRegistroOrden?.toUpperCase() == usuario.toUpperCase())
          .toList();
    });
  }

  searchingOnlyEstado() {
    setState(() {
      planificacionListFilter = List.from(planificacionList
          .where((x) => x.statu!.toUpperCase() == modoEstado.toUpperCase())
          .toList());
    });
  }

  Color getNombre(userRegited) {
    return usuario.toUpperCase() == userRegited.toUpperCase()
        ? Colors.red
        : Colors.blue;
  }

  Future getReorden() async {
    final res = await httpRequestDatabase(selectReOrden,
        {'token': token, 'date1': DateTime.now().toString().substring(0, 10)});
    listReOrden = reOrdenFromJson(res.body);
    await Future.delayed(const Duration(seconds: 2));

    if (!validatorUser()) {
      listReOrden = listReOrden
          .where((element) =>
              element.usuario?.toUpperCase() ==
              currentUsers?.fullName?.toUpperCase())
          .toList();
    }

    if (res.body != '') {
      if (!mounted) {
        return;
      }
      if (listReOrden.isNotEmpty) {
        await showDialog(
            context: context,
            builder: (context) {
              return DialogReOrden(listReOrden: listReOrden);
            });
      }
    }
  }

  void settingContabilidad(PlanificacionLast item) async {
    await showDialog(
        context: context, builder: (context) => builder(context, item));
  }

  Widget builder(context, PlanificacionLast item) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('Orden : ${item.numOrden}')),
              Text('Ficha : ${item.ficha}'),
              Text('${item.nameLogo}'),
              Text('${item.cliente}'),
              Text('${item.clienteTelefono}'),
              Text('Estado ${item.statu}'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        asignaContabilida(item);
                      },
                      child: const Text('Asignar a Contabilidad')),
                ),
              ),
            ],
          ),
        ),
      );

  Future asignaContabilida(PlanificacionLast item) async {
    final res = await httpRequestDatabase(
        updatePlanificacionContabilidad, {'id': item.id});
    // /print(res.body);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.body)));
  }

  Future setIsBalancePaid(PlanificacionLast item) async {
    // print('Valor inicial ${item.isValidateBalance}');
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: 'Esta seguro de cambiar estado de balance?',
            titulo: 'Aviso',
            onConfirmar: () async {
              var value = item.isValidateBalance == 't' ? 'f' : 't';
              await httpRequestDatabase(
                  updateIsValidateBalance, {'id': item.id, 'value': value});
              exit();
            },
          );
        });

    // /print(res.body);
    if (!mounted) {
      return;
    }
  }

  void exit() async {
    Navigator.of(context).pop();
    await getReception();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
            margin: const EdgeInsets.only(top: 15, right: 16),
            child: const Text('Entregas De Saquetas')),
        leading: Container(
            margin: const EdgeInsets.only(top: 15, left: 16),
            child: const BackButton()),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int index) async {
              if (index == 5) {
                getReorden();
              } else if (index == 1) {
                showSearch(context: context, delegate: CustomSearchDelegate());
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPlanificacionForm()),
                );
              } else if (index == 3) {
                if (planificacionListFilter.isNotEmpty) {
                  final pdfFile = await PdfReceptionOrdenes.generate(
                      planificacionListFilter,
                      firstDate,
                      secondDate,
                      'atrazadas',
                      totalOrdenEntregar(planificacionListFilter));
                  PdfApi.openFile(pdfFile);
                }
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenRecordReception()),
                );
              } else if (index == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenAdminReOrden()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Search'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.add, color: Colors.black),
                  title: Text('Add Planificacion Form'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.print, color: Colors.black),
                  title: Text('Print'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 4,
                child: ListTile(
                  leading:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                  title: Text('Screen Record Reception'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 5,
                child: ListTile(
                  leading:
                      Icon(Icons.info_outline_rounded, color: Colors.amber),
                  title: Text('Aviso Entregas'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 6,
                child: ListTile(
                    leading:
                        Icon(Icons.calendar_month_outlined, color: Colors.red),
                    title: Text('Admin Aviso Entregas')),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5, width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                usuario = "";
                modoEstado = "";
                firstDate = date1.toString();
                secondDate = date2.toString();
                planificacionList.clear();
                planificacionListFilter.clear();
              });
              getReception();
              getReorden();
            },
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 250,
            child: FadeIn(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
                child: TextField(
                  onChanged: (val) => searchingOrden(val),
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, top: 10),
                    suffixIcon: Tooltip(
                      message: 'Buscar',
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    PlanificacionLast.depurarRegistradorOrden(planificacionList)
                        .map((userRegited) {
                  return BounceInDown(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 35,
                        color: getNombre(userRegited.toUpperCase()),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    modoEstado = '';
                                    usuario = userRegited.toUpperCase();
                                    planificacionListFilter = planificacionList
                                        .where((element) =>
                                            element.userRegistroOrden
                                                ?.toUpperCase() ==
                                            usuario.toUpperCase())
                                        .toList();
                                  });
                                },
                                child: Text(
                                  userRegited,
                                  style: const TextStyle(color: Colors.white),
                                )),
                            usuario.toUpperCase() == userRegited.toUpperCase()
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        usuario = '';
                                        planificacionListFilter =
                                            List.from(planificacionList);
                                      });
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.white))
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 35,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: PlanificacionLast.depurraEstadoOrden(
                          planificacionListFilter)
                      .map(
                    (estado) {
                      return Container(
                        color: modoEstado == estado
                            ? Colors.blue.shade100
                            : Colors.white,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  modoEstado = estado;
                                  if (usuario.isEmpty) {
                                    searchingOnlyEstado();
                                  } else {
                                    searchingEstadoEmpleado();
                                  }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.resolveWith(
                                        (states) =>
                                            const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.zero))),
                                child: Text(estado)),
                            modoEstado == estado
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        modoEstado = '';
                                        if (usuario.isEmpty) {
                                          //normalizar lista
                                          planificacionListFilter =
                                              planificacionList;
                                        } else {
                                          normalizarWithRegisterOrden();
                                        }
                                      });
                                    },
                                    child: const Center(
                                      child: Icon(Icons.close,
                                          color: Colors.red, size: 15),
                                    ))
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                  ).toList()),
            ),
          ),
          planificacionListFilter.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      dataRowMaxHeight: 20,
                      dataRowMinHeight: 20,
                      headingRowHeight: 30,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 205, 208, 221),
                            Color.fromARGB(255, 225, 228, 241),
                            Color.fromARGB(255, 233, 234, 238)
                          ],
                        ),
                      ),
                      border: TableBorder.symmetric(
                          inside: const BorderSide(
                              style: BorderStyle.solid, color: Colors.grey)),
                      columns: [
                        const DataColumn(label: Text('Detalles')),
                        const DataColumn(label: Text('Empleado')),
                        const DataColumn(label: Text('Numero Orden')),
                        DataColumn(
                            label: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    planificacionListFilter.sort(
                                        (a, b) => a.ficha!.compareTo(b.ficha!));
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_up,
                                    color: Colors.green, size: 20)),
                            const Text('Fichas'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    planificacionListFilter.sort(
                                        (a, b) => b.ficha!.compareTo(a.ficha!));
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: Colors.red, size: 20))
                          ],
                        )),
                        const DataColumn(label: Text('Balance')),
                        const DataColumn(label: Text('Intervención')),
                        const DataColumn(label: Text('Comentarios')),
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Fecha de entrega'),
                              IconButton(
                                  onPressed: () {
                                    selectDateRange(context, (date1, date2) {
                                      getMonthly(date1, date2);
                                      // getMonthlyCreated
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_month,
                                      color: Colors.red, size: 20))
                            ],
                          ),
                        ),
                        const DataColumn(label: Text('Logo')),
                        const DataColumn(label: Text('Estado')),
                        DataColumn(
                            label: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    planificacionListFilter.sort((a, b) =>
                                        a.cliente!.compareTo(b.cliente!));
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_up,
                                    color: Colors.green, size: 20)),
                            const Text('Cliente'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    planificacionListFilter.sort((a, b) =>
                                        b.cliente!.compareTo(a.cliente!));
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: Colors.red, size: 20))
                          ],
                        )),
                        const DataColumn(label: Text('Cliente Telefono')),
                        DataColumn(
                            label: Row(
                          children: [
                            const Text('Fecha Creación'),
                            IconButton(
                                onPressed: () {
                                  selectDateRange(context, (date1, date2) {
                                    getMonthlyCreated(date1, date2);
                                  });
                                },
                                icon: const Icon(Icons.calendar_month,
                                    color: Colors.red, size: 20))
                          ],
                        )),
                        const DataColumn(label: Text('Eliminar')),
                      ],
                      rows: planificacionListFilter
                          .map(
                            (item) => DataRow(
                              color: MaterialStateProperty.resolveWith(
                                  (states) => PlanificacionLast.getColor(item)),
                              cells: [
                                DataCell(TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (conext) =>
                                                SeguimientoOrden(item: item)));
                                  },
                                  child: const Text('CLICK!'),
                                )),
                                DataCell(Text(item.userRegistroOrden ?? ''),
                                    onTap: () {
                                  settingContabilidad(item);
                                }, showEditIcon: true),
                                DataCell(
                                  Center(
                                      child: Text(item.numOrden ?? '',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              overflow:
                                                  TextOverflow.ellipsis))),
                                ),
                                DataCell(
                                    Center(
                                      child:
                                          Text(item.ficha ?? '', maxLines: 1),
                                    ), onTap: () {
                                  utilShowMesenger(context, item.ficha ?? '',
                                      title: 'Ficha');
                                }),
                                DataCell(
                                    Center(
                                        child: Text(
                                      '\$ ${getNumFormatedDouble(item.balance ?? '0')}',
                                      style: TextStyle(
                                          fontWeight:
                                              item.isValidateBalance == 't'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color: PlanificacionLast
                                              .getColorIsBalancePaid(item)),
                                    )), onTap: () async {
                                  await setIsBalancePaid(item);
                                }),
                                DataCell(
                                    Center(child: Text(item.llamada ?? '0')),
                                    onTap: () {
                                  if (item.llamada!.contains('0')) {
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DialogReOrdenRecord(
                                                  numOrden: item.numOrden!)),
                                    );
                                  }
                                }),
                                DataCell(
                                  SizedBox(
                                      width: 300,
                                      child: Text(item.comment ?? '',
                                          maxLines: 1)),
                                  onTap: () {
                                    utilShowMesenger(
                                        context, item.comment ?? '',
                                        title: 'Comentarios');
                                  },
                                ),
                                DataCell(
                                  Text(
                                    item.fechaEntrega ?? '',
                                    style: TextStyle(
                                        color:
                                            PlanificacionLast.getColorsAtradas(
                                                    item)
                                                ? Colors.black
                                                : Colors.red,
                                        fontWeight:
                                            PlanificacionLast.getColorsAtradas(
                                                    item)
                                                ? FontWeight.normal
                                                : FontWeight.bold),
                                  ),
                                ),
                                DataCell(
                                    SizedBox(
                                      width: 75,
                                      child: Text(
                                        item.nameLogo ?? '',
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ), onTap: () {
                                  utilShowMesenger(context, item.nameLogo ?? '',
                                      title: 'LOGO');
                                }),
                                DataCell(Text(item.statu ?? '')),
                                DataCell(
                                    SizedBox(
                                      width: 70,
                                      child: Text(item.cliente ?? '',
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis)),
                                    ), onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenHistoriaClienteOrden(
                                                client: item.cliente ?? 'N/A')),
                                  );
                                }, onLongPress: () {
                                  utilShowMesenger(context, item.cliente ?? '',
                                      title: 'CLIENTE');
                                }),
                                DataCell(Text(item.clienteTelefono ?? '')),
                                DataCell(Text(item.fechaStart ?? '')),
                                DataCell(validatorUser()
                                    ? TextButton(
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () => deleleFromRecord(item),
                                      )
                                    : const Text('Not'))
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ))
              : const SizedBox(child: Text('No hay Datos')),
          planificacionListFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 50),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('TOTAL ORDEN : '),
                                      const SizedBox(width: 15),
                                      Text('${planificacionListFilter.length}',
                                          style: const TextStyle(
                                              color: Colors.brown,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 100),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('POR ENTREGAR: '),
                                      const SizedBox(width: 15),
                                      Text(
                                          totalOrdenEntregar(
                                              planificacionListFilter),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 100),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('ATRASADAS: '),
                                      const SizedBox(width: 15),
                                      Text(
                                          getTotalAtrasada(
                                              planificacionListFilter),
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          BounceInDown(
                            delay: const Duration(milliseconds: 100),
                            child: Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Text('BALANCE: '),
                                      const SizedBox(width: 15),
                                      Text(
                                          '\$ ${getNumFormatedDouble(PlanificacionLast.getBalanceTotal(planificacionListFilter))}',
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
