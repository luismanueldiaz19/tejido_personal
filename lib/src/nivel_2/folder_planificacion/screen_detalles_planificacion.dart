import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';

class DetallesPlanificacion extends StatefulWidget {
  const DetallesPlanificacion({Key? key, this.currentLocal}) : super(key: key);
  final PlanificacionItem? currentLocal;

  @override
  State<DetallesPlanificacion> createState() => _DetallesPlanificacionState();
}

class _DetallesPlanificacionState extends State<DetallesPlanificacion> {
  late TextEditingController comment;
  late TextEditingController cantElab;
  List<PlanificacionItem> list = [];
  bool isDonePanificacion = false;
  Future updateFrom(id, value) async {
    await httpRequestDatabase(updateProductoPlanificacionLastCalidad,
        {'id': id, 'is_calidad': value, 'is_done': value});

    // print(res.body);
  }

  Future updateFromComment(id, comment) async {
    await httpRequestDatabase(updateProductoPlanificacionCommentLast, {
      'id': id,
      'comment': comment,
    });
    // print('Comment  Reponse:  ${res.body}');
  }

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    cantElab = TextEditingController();
    getSeguimiento();
  }

  Future getSeguimiento() async {
    final res = await httpRequestDatabase(selectProductoPlanificacionLastIdKey,
        {'is_key_product': widget.currentLocal?.isKeyUniqueProduct.toString()});
    print('la orde tiene todo esto productos : ${res.body}');
    list = planificacionItemFromJson(res.body);
    checkAllItemsDone(list);
    // print('Estado : $allItemsDone');

    //  list.isNotEmpty ? validadListaTerminada(list) : () {};
    // setState(() {});
  }

  checkAllItemsDone(List<PlanificacionItem> itemList) {
    int countItem = 0;
    for (var item in list) {
      if (item.isDone.toString() == 't') {
        countItem++;
        print('Cant: $countItem De ${list.length}');
        // return true; // Si algún item no tiene 'is_done' igual a 't', retorna false
      }
      print('Cantidad item Terminado $countItem De ${list.length}');
      print('La orden no ha terminado');
      // return false;
    } // Si todos los items tienen 'is_done' igual a 't', retorna true
    if (countItem == list.length - 1) {
      print('Se puede actualizar');
      isDonePanificacion = true;
    } else {
      isDonePanificacion = false;
      print('todavia falta elemento por terminar');
    }
  }

  Future statuMethondOrdenCompleta(PlanificacionItem? current,
      {required String statu}) async {
    var data = {
      'id': current?.isKeyUniqueProduct,
      'statu': statu,
    };
    final res = await httpRequestDatabase(updatePlanificacionLastStatu, data);
    // print(res.body);
    if (res.body.toString() == 'good') {}
  }

  @override
  void dispose() {
    super.dispose();
    comment.dispose();
    cantElab.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.currentLocal);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const AppBarCustom(title: 'Detalles de Orden'),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.change_circle_rounded,
                    color: Colors.orange,
                    size: 75,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        'Numero Orden : ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.black54, fontSize: 16),
                      ),
                      Text(
                        widget.currentLocal?.numOrden ?? 'N/A',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: colorsAd,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      const Text('Ficha : ',
                          style: TextStyle(color: Colors.black54)),
                      Text(
                        widget.currentLocal?.ficha ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.shopping_bag_sharp,
                          color: Colors.indigoAccent.shade100, size: 15)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        widget.currentLocal?.nameLogo ?? 'N/A',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        'Cant : ${widget.currentLocal?.cant ?? 'N/A'}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(widget.currentLocal?.department ?? 'N/A'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Fecha Creación : ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.black54, fontSize: 16),
                          ),
                          Text(widget.currentLocal?.fechaStart ?? 'N/A')
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Text(
                                  'Entrega : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.black54, fontSize: 16),
                                ),
                                Text(widget.currentLocal?.fechaEnd ?? 'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorsGreenLevel)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(bottom: 15, left: 15),
              child: Row(
                children: [
                  Text('Estado de la orden',
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15, left: 15),
            //   child: Row(
            //     children: [
            //       // SizedBox(
            //       //   width: MediaQuery.of(context).size.width * 0.80,
            //       //   child: IndetificacionAction(press: (value) {
            //       //     statuProductoMethond(widget.currentLocal, statu: value);
            //       //     if (value == onEntregar) {
            //       //       statuMethond(widget.currentLocal, statu: value);
            //       //     }
            //       //     //
            //       //     utilShowMesenger(context, 'Publicado en $value');
            //       //   }),
            //       // ),
            //     ],
            //   ),
            // ),
            // // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.currentLocal?.isDone == 'f' &&
                            widget.currentLocal?.isCalidad == 't' &&
                            widget.currentLocal?.isWorking == 't'
                        ? () async {
                            var value = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Realizar ?'),
                                  content: const Text(
                                      '¿Esta seguro de reportar como realizado?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop('Cancelar');
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Terminar'),
                                      onPressed: () {
                                        Navigator.of(context).pop('Terminar');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (value != null) {
                              if (value == 'Terminar') {
                                // print(value);

                                updateFrom(widget.currentLocal?.id, 't');
                                widget.currentLocal?.isCalidad = 't';

                                var commentLocal =
                                    '${widget.currentLocal?.comment}- ( Terminado En :  🕗${DateTime.now().toString().substring(0, 19)}🕗 ) Por ${currentUsers?.fullName}';

                                if (widget.currentLocal?.comment == 'N/A') {
                                  commentLocal = value;
                                }
                                updateFromComment(
                                    widget.currentLocal?.id, commentLocal);
                                widget.currentLocal?.comment = commentLocal;
                                statuProductoMethond(widget.currentLocal,
                                    statu: onDone);
                                statuMethond(widget.currentLocal,
                                    statu: onProceso);
                                if (isDonePanificacion) {
                                  statuMethondOrdenCompleta(
                                      PlanificacionItem(
                                          isKeyUniqueProduct: widget
                                              .currentLocal
                                              ?.isKeyUniqueProduct),
                                      statu: onEntregar);
                                }

                                setState(() {
                                  widget.currentLocal?.isDone = 't';
                                });
                              }
                            }
                          }
                        : () {
                            utilShowMesenger(context,
                                'Todavia Faltan Factores Por Cumplir De Esta Orden');
                          },
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                                widget.currentLocal?.isDone == 'f' ||
                                        widget.currentLocal?.isCalidad == 't' &&
                                            widget.currentLocal?.isWorking ==
                                                't'
                                    ? 'Sin Terminar'
                                    : 'Terminado',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.black54)),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.verified,
                              color: widget.currentLocal?.isDone == 'f' ||
                                      widget.currentLocal?.isCalidad == 't' &&
                                          widget.currentLocal?.isWorking == 't'
                                  ? Colors.red
                                  : Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: GestureDetector(
                onTap: () async {
                  String? value = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: BounceInDown(
                            child: const Text('Agregar Comentario')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ZoomIn(
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                ),
                                width: 250,
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: comment,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Comentario',
                                    contentPadding: EdgeInsets.only(left: 10),
                                  ),
                                  onEditingComplete: () {
                                    Navigator.of(context).pop(comment.text);
                                    comment.clear();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Comentar'),
                            onPressed: () {
                              if (comment.text.isNotEmpty) {
                                Navigator.of(context).pop(comment.text);
                                comment.clear();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // print(value);

                  if (value != null) {
                    var commentLocal =
                        '${widget.currentLocal?.comment}- ( $value ${DateTime.now().toString().substring(0, 19)} )';

                    if (widget.currentLocal?.comment == 'N/A') {
                      commentLocal = value;
                    }
                    updateFromComment(widget.currentLocal?.id, commentLocal);
                    widget.currentLocal?.comment = commentLocal;
                    setState(() {});
                  }
                },
                child: ListTile(
                  title: Text(
                    'Proceso : ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black54, fontSize: 16),
                  ),
                  subtitle: Text(
                    widget.currentLocal?.comment ?? 'N/A',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: colorsAd,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      widget.currentLocal?.isWorking == 'f'
                          ? TextButton(
                              child: const Text('Trabajar'),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmacionDialog(
                                      mensaje:
                                          '❌❌Esta seguro de cerrar esta Acción❌❌',
                                      titulo: 'Aviso',
                                      onConfirmar: () {
                                        Navigator.of(context).pop();
                                        isWorkingMethond(widget.currentLocal,
                                            isWorked: 't', statu: onProceso);
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          : const Text('Ya se esta Trabando ...',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(width: 15),
                      widget.currentLocal?.isCalidad == 'f' &&
                              widget.currentLocal?.isWorking == 't'
                          ? ElevatedButton(
                              child: const Text(
                                'Confirmar calidad',
                                style: TextStyle(color: colorsAd),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmacionDialog(
                                      mensaje:
                                          '❌❌Esta Seguro De Verificar La Calidad De Este Artitulo Para Realizar Esta Acción❌❌',
                                      titulo: 'Aviso De Calidad',
                                      onConfirmar: () {
                                        Navigator.of(context).pop();
                                        isCalidadMethond(widget.currentLocal,
                                            isCalidad: 't',
                                            statu: 'Calidad Verificada');
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          : const SizedBox(),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddIncidenciaSublimacion(
                                    current: Sublima(
                                        numOrden: widget.currentLocal?.numOrden,
                                        ficha: widget.currentLocal?.ficha,
                                        nameDepartment:
                                            widget.currentLocal?.department),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              // color de texto
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // redondear bordes
                              ),
                              elevation: 5, // elevación
                              backgroundColor: colorsAd,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10), // relleno
                            ),
                            child: const Text(
                              'Incidencia',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future isWorkingMethond(PlanificacionItem? current,
      {required String isWorked, required String statu}) async {
    var comentario =
        '${widget.currentLocal?.comment} $statu Por ${currentUsers?.fullName} a la 🕗${DateTime.now().toString().substring(0, 19)}🕗.';
    var data = {
      'id': current?.id,
      'is_working': isWorked,
      'statu': statu,
      'comment': comentario,
    };
    final res = await httpRequestDatabase(
        updateProductoPlanificacionLastIsWorking, data);

    // print(res.body);
    if (res.body.toString() == 'good') {
      setState(() {
        widget.currentLocal?.comment = comentario;
        widget.currentLocal?.isWorking = isWorked;
      });
    }
  }

  Future isCalidadMethond(PlanificacionItem? current,
      {required String isCalidad, required String statu}) async {
    var comentario =
        '${widget.currentLocal?.comment} ✅ $statu ✅ por ${currentUsers?.fullName} a la 🕗${DateTime.now().toString().substring(0, 19)}🕗.';

    var data = {
      'id': current?.id,
      'is_calidad': isCalidad,
      'statu': '✅ $statu ✅',
      'comment': comentario,
    };
    final res = await httpRequestDatabase(
        updateProductoPlanificacionLastIsCalidad, data);

    // print(res.body);
    if (res.body.toString() == 'good') {
      setState(() {
        widget.currentLocal?.comment = comentario;
        widget.currentLocal?.isCalidad = isCalidad;
      });
    }
  }

  Future statuMethond(PlanificacionItem? current,
      {required String statu}) async {
    var data = {
      'id': current?.isKeyUniqueProduct,
      'statu': statu,
    };
    final res = await httpRequestDatabase(updatePlanificacionLastStatu, data);
    // print(res.body);
    if (res.body.toString() == 'good') {}
  }

  Future statuProductoMethond(PlanificacionItem? current,
      {required String statu}) async {
    var data = {'id': current?.id, 'statu': statu};

    await httpRequestDatabase(updateProductoPlanificacionLastStatu, data);
    // print(res.body);
    // if (res.body.toString() == 'good') {}
  }
}
