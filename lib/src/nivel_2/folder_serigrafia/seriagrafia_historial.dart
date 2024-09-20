import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';
import 'package:tejidos/src/widgets/picked_date_widget.dart';

import '../../widgets/loading.dart';
import 'widgets/widget_serigrafia_card.dart';
import 'widgets/widget_total_item.dart';

class SeriagrafiaHistorial extends StatefulWidget {
  const SeriagrafiaHistorial({super.key, required this.current});
  final Department current;

  @override
  State<SeriagrafiaHistorial> createState() => _SeriagrafiaHistorialState();
}

class _SeriagrafiaHistorialState extends State<SeriagrafiaHistorial> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  List<Sublima> listFilter = [];
  List<Sublima> list = [];
  String messaje = 'Cargando... Espere por favor!';
  bool isLoading = true;

  List<PageController>? _pageController;

  @override
  void dispose() {
    super.dispose();
    for (var element in _pageController!) {
      element.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    getWork();
  }

  Future getWork() async {
    setState(() {
      messaje = 'Cargando... Espere por favor!';
      listFilter.clear();
      list.clear;
      isLoading = true;
    });

    String url =
        "http://$ipLocal/settingmat/admin/select/select_serigrafia_work_finished_by_date.php";
    final res = await httpRequestDatabase(url, {
      'id_depart': widget.current.id,
      'date1': _firstDate,
      'date2': _secondDate
    });
    // print('Filter es ${res.body}');
    list = sublimaFromJson(res.body);
    listFilter = [...list];
    setState(() {
      if (listFilter.isEmpty) {
        messaje = 'No hay Trabajos';
        isLoading = false;
      }
      _pageController = List.generate(
          list.length, (index) => PageController(viewportFraction: 0.5));
    });
    // resultado = sumarCantidades(listFilter);
    // takeTime(listFilter);
    // tomarUsuarios(listFilter);
    // // print(res.body);
  }

  void _searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listFilter = List.from(list
          .where((x) =>
              x.codeUser!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameWork!.toUpperCase().contains(val.toUpperCase()) ||
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.turn!.toUpperCase().contains(val.toUpperCase()))
          .toList());

      //  takeTime(listFilter);
      setState(() {});
    } else {
      listFilter = [...list];
      //  takeTime(listFilter);
      setState(() {});
    }
  }

  void searchingFilterChip(String? val) {
    // print(val);
    if (val!.isNotEmpty) {
      listFilter = List.from(list
          .where((x) =>
              x.nameWork!.toUpperCase().contains(val.toUpperCase()) ||
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());

      // takeTime(listFilter);
      // tomarUsuarios(listFilter);
      setState(() {});
    } else {
      listFilter = [...list];
      // takeTime(listFilter);
      //  tomarUsuarios(listFilter);
      setState(() {});
    }
  }

  Future deleteFromDone(context2, id) async {
    if (validarSupervisor()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta Seguro de Eliminar❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              // delete_serigrafia_work_finished_done
              String url =
                  "http://$ipLocal/settingmat/admin/delete/delete_serigrafia_work_finished_done.php";
              final res = await httpRequestDatabase(url, {'id': id});
              // print(res.body);
              Navigator.of(context).pop();
              getWork();
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No tiene permiso para eliminar'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos realizados'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.print)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                selectDateRange(context, (date1, date2) {
                  _firstDate = date1;
                  _secondDate = date2;
                  getWork();
                });
              },
              icon: const Icon(Icons.calendar_month))
        ],
      ),
      body: size.width > 900
          ? const Center(child: Text('Pantalla no disponible'))
          : Column(
              children: [
                const SizedBox(width: double.infinity),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.0)),
                  width: 250,
                  child: TextField(
                    onChanged: (val) => _searchingFilter(val),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Buscar',
                        label: Text('Buscar'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        suffixIcon: Icon(Icons.search)),
                  ),
                ),
                listFilter.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MyWidgetTotalItem(
                                icon: Icons.assignment,
                                message: 'Total Trabajos',
                                total: listFilter.length.toString()),
                            MyWidgetTotalItem(
                                icon: Icons.numbers_outlined,
                                message: 'Total de Ordenes',
                                total: Sublima.getTotalOrden(listFilter)),
                            MyWidgetTotalItem(
                                icon: Icons.download_done_sharp,
                                message: 'Trabajos Terminados',
                                total: Sublima.getTotalRealizado(listFilter)),
                          ],
                        ),
                      )
                    : const SizedBox(),
                listFilter.isNotEmpty
                    ? Expanded(
                        child: RefreshIndicator(
                        onRefresh: () => getWork(),
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: listFilter.length,
                            itemBuilder: (context, index) {
                              Sublima current = listFilter[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyWidgetSerigrafiaCard(
                                  current: current,
                                  deleteFromDone: () =>
                                      deleteFromDone(context, current.id),
                                  pageController: _pageController![index],
                                ),
                              );
                            }),
                      ))
                    : Expanded(
                        child: Loading(text: messaje, isLoading: isLoading),
                      ),
                identy(context),
              ],
            ),
    );
  }
}
