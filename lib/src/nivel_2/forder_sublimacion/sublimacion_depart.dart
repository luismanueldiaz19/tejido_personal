import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/model/type_work.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/forder_reporte_general/sublimacion_report_general.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/trabajos_actuales.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/get_sized.dart';

class SublimacioDepart extends StatefulWidget {
  const SublimacioDepart({super.key, required this.current});
  final Department current;
  @override
  State<SublimacioDepart> createState() => _SublimacioDepartState();
}

class _SublimacioDepartState extends State<SublimacioDepart> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();
  List<TypeWork> listTypeWork = [];
  TypeWork selectType = TypeWork();
  bool idType = false;
  List<Sublima> listOrden = [];

  Future selectTypeWorkMethond() async {
    // print(widget.current.idKeyWork);
    // listTypeWork.clear();
    final res = await httpRequestDatabase(
        selectTypeWorkByKey, {'id_key': widget.current.idKeyWork});
    // print('List de Type Work ${res.body}');
    listTypeWork = typeWorkFromJson(res.body);
    // print(listTypeWork.length);
    if (listTypeWork.isNotEmpty) {
      setState(() {});
    }
  }

  Future insertSublimacionWorkMethond(data) async {
    await httpRequestDatabase(insertSublimacionWorkIdKeyWork, data);
  }

  Future insertListsWork(keyWork) async {
    for (var element in listOrden) {
      var data = {
        'id_depart': widget.current.id,
        'code_user': currentUsers?.code,
        'num_orden': element.numOrden,
        'type_work': selectType.id,
        'ficha': element.ficha,
        'cant_orden': element.cantOrden,
        'name_logo': element.nameLogo,
        'id_key_work': keyWork
      };
      insertSublimacionWorkMethond(data);
      // print('Element ${element.nameLogo} Inserted');
    }

    idType = false;
    listOrden.clear();
    selectType = TypeWork();
    setState(() {});
  }

  Future insertListWork() async {
    var randow = Random();
    var numKey = randow.nextInt(999999999);
    var data = {
      'id_depart': widget.current.id,
      'code': currentUsers?.code,
      'id_key_work': numKey.toString(),
    };

    await httpRequestDatabase(insertListWorkSublimacion, data);
    insertListsWork(numKey.toString());
  }

  @override
  void initState() {
    super.initState();
    // _chosenValue = 'Android';
    selectTypeWorkMethond();
  }

  void agregarWork() {
    if (controllerLogo.text.isNotEmpty &&
        controllerOrden.text.isNotEmpty &&
        controllerCantOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty) {
      Sublima data = Sublima(
          nameLogo: controllerLogo.text,
          numOrden: controllerOrden.text,
          cantOrden: controllerCantOrden.text,
          ficha: controllerFicha.text,
          typeWork: selectType.id);

      listOrden.add(data);
      debugPrint('Tamaño de la lista ${listOrden.length}');
      controllerOrden.clear();
      controllerFicha.clear();
      controllerCantOrden.clear();
      controllerLogo.clear();
      setState(() {});
    } else {
      utilShowMesenger(context, 'Error Campos vacios');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double sizeObtenido = getSize(size.width);
    // print(size.width);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sublimación'),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 5),
            child: IconButton(
                icon: const Icon(Icons.work_history_sharp),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TrabajosActuales(
                              current: widget.current,
                            )),
                  );
                }),
          ),
          listTypeWork.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 15, right: 25),
                  child: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (conext) => SublimacionReportGeneral(
                                    current: widget.current,
                                    listTypeWork: listTypeWork)));
                      }),
                )
              : const SizedBox()
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          idType
              ? Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ZoomIn(
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerLogo,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Nombre Logo',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerOrden,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Num Orden',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerFicha,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Ficha',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerCantOrden,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Cant Orden',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                    onEditingComplete: () => agregarWork(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      // onPressed: () =>  insertSublimacionWorkMethond(),
                                      onPressed: () => agregarWork(),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Colors.teal)),
                                      child: const Text('Agregar'),
                                    ),
                                    const SizedBox(width: 25),
                                    listOrden.isNotEmpty
                                        ? ElevatedButton(
                                            onPressed: listOrden.isNotEmpty
                                                ? () => insertListWork()
                                                : () {
                                                    utilShowMesenger(
                                                        context, 'Lista Vacia');
                                                  },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.red)),
                                            child: const Text('Enviar '),
                                          )
                                        : const SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        listOrden.isNotEmpty
                            ? SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: listOrden
                                        .map((e) => SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.50,
                                              // color: Colors.red,
                                              child: ListTile(
                                                title: Text(
                                                    'Logo:  ${e.nameLogo ?? 'N/A'}'),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Ficha : ${e.ficha ?? 'N/A'}'),
                                                    Text(
                                                        "Num Orden ${e.numOrden ?? 'N/A'}"),
                                                    Text(
                                                        "Cant Orden ${e.cantOrden ?? 'N/A'}")
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ))
                            : const Text('Lista en espera...'),
                      ],
                    ),
                  ),
                )
              : listTypeWork.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          addAutomaticKeepAlives: false,
                          padding: const EdgeInsets.all(10.0),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 1.9,
                            maxCrossAxisExtent: sizeObtenido,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: listTypeWork.length,
                          itemBuilder: (context, index) {
                            TypeWork current = listTypeWork[index];
                            String image =
                                "http://$ipLocal/settingmat/admin/imagen/${current.imagePath.toString()}";
                            //     getImageAreas(int.parse(current.id.toString()));
                            // print(current.id);
                            // print('Imagen del department $image');
                            return BounceInDown(
                              duration: Duration(milliseconds: 300 * index),
                              child: GestureDetector(
                                onTap: () {
                                  selectType = current;
                                  setState(() {
                                    idType = true;
                                  });
                                },
                                child: Container(
                                  height: 220,
                                  margin: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.white),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            cacheWidth: 200,
                                            cacheHeight: 200,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }

                                              return const Center(
                                                  child: Text('Loading...'));
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black45,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            current.typeWork.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }
}
