import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class DetallesEntrega extends StatefulWidget {
  const DetallesEntrega({Key? key, this.currentLocal}) : super(key: key);
  final PlanificacionItem? currentLocal;

  @override
  State<DetallesEntrega> createState() => _DetallesEntregaState();
}

class _DetallesEntregaState extends State<DetallesEntrega> {
  late TextEditingController comment;
  late TextEditingController cantElab;

  Future updateFrom(id, value) async {
    await httpRequestDatabase(updateProductoPlanificacionLastCalidad,
        {'id': id, 'is_calidad': value, 'is_done': value});
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
  }

  @override
  void dispose() {
    super.dispose();
    comment.dispose();
    cantElab.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de Orden')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Row(children: [
              Icon(Icons.change_circle_rounded, color: Colors.orange, size: 50)
            ]),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
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
                          TextButton(
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2100),
                                );
                                // print(date);
                                if (date != null) {
                                  setState(() {});
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text(
                                  widget.currentLocal?.fechaStart ?? 'N/A')),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15),
              child: Row(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                              widget.currentLocal?.isDone == 't'
                                  ? 'Entregado'
                                  : 'Entregar',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.black54)),
                          const SizedBox(width: 5),
                          Icon(
                            widget.currentLocal?.isDone == 't'
                                ? Icons.shopping_cart_outlined
                                : Icons.shopping_basket_outlined,
                            color: widget.currentLocal?.isDone == 't'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                              widget.currentLocal?.isCalidad == 'f'
                                  ? 'Realizar'
                                  : 'Realizado',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.black54)),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.verified,
                            color: widget.currentLocal?.isCalidad == 't'
                                ? Colors.green
                                : Colors.red,
                          )
                        ],
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
                      // Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: SizedBox(
                      //     child: ElevatedButton(
                      //       onPressed: () async {
                      //         FocusScope.of(context).requestFocus(FocusNode());
                      //         final date = await showDatePicker(
                      //           context: context,
                      //           initialDate: DateTime.now(),
                      //           firstDate: DateTime(2023),
                      //           lastDate: DateTime(2100),
                      //         );
                      //         // print(date);
                      //         if (date != null) {
                      //           updateFromDateEntrega(widget.currentLocal?.id,
                      //               date.toString().substring(0, 10));

                      //           var commentLocal =
                      //               '${widget.currentLocal?.comment}- (se modifico la fecha de entrega : ${widget.currentLocal?.fechaEntrega} a ${date.toString().substring(0, 10)} Por : ${currentUsers?.fullName} a la ${DateTime.now().toString().substring(0, 19)} )';

                      //           if (widget.currentLocal?.comment ==
                      //               'No hay Comentario') {
                      //             commentLocal =
                      //                 'se modificó la fecha de entrega de ${widget.currentLocal?.fechaEntrega} a ${date.toString().substring(0, 10)} Por : ${currentUsers?.fullName} a la ${DateTime.now().toString().substring(0, 19)}';
                      //           }
                      //           updateFromComment(
                      //               widget.currentLocal?.id, commentLocal);

                      //           setState(() {
                      //             // _dateSelectedEntrega = date;
                      //             widget.currentLocal?.fechaEntrega =
                      //                 date.toString().substring(0, 10);
                      //             widget.currentLocal?.comment = commentLocal;
                      //           });
                      //         }
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         // color de texto
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(
                      //               10), // redondear bordes
                      //         ),
                      //         elevation: 5, // elevación
                      //         backgroundColor: colorsBlueTurquesa,
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 20, vertical: 10), // relleno
                      //       ),
                      //       child: const Text('Cambiar Fecha Entrega'),
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: SizedBox(
                      //     width: 150,
                      //     child: ElevatedButton(
                      //       onPressed: () async {
                      //         String? value = await showDialog<String>(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: BounceInDown(
                      //                   child:
                      //                       const Text('Cant Elaborada')),
                      //               content: Column(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   ZoomIn(
                      //                     duration: const Duration(
                      //                         milliseconds: 300),
                      //                     child: Container(
                      //                       decoration: BoxDecoration(
                      //                         color: Colors.grey.shade200,
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                           10.0,
                      //                         ),
                      //                       ),
                      //                       width: 250,
                      //                       child: TextField(
                      //                         textInputAction:
                      //                             TextInputAction.next,
                      //                         controller: cantElab,
                      //                         decoration:
                      //                             const InputDecoration(
                      //                           border: InputBorder.none,
                      //                           labelText: 'Cantidad',
                      //                           contentPadding:
                      //                               EdgeInsets.only(
                      //                                   left: 10),
                      //                         ),
                      //                         onEditingComplete: () {
                      //                           Navigator.of(context)
                      //                               .pop(cantElab.text);
                      //                           cantElab.clear();
                      //                         },
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //               actions: [
                      //                 TextButton(
                      //                   child: const Text('Cancelar'),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //                 TextButton(
                      //                   child: const Text('reportar'),
                      //                   onPressed: () {
                      //                     if (cantElab.text.isNotEmpty) {
                      //                       Navigator.of(context)
                      //                           .pop(cantElab.text);
                      //                       cantElab.clear();
                      //                     }
                      //                   },
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );

                      //         if (value != null) {
                      //           print(value);

                      //           updatedFromCanElab(
                      //               widget.currentLocal?.id, value);
                      //         }
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         // color de texto
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(
                      //               10), // redondear bordes
                      //         ),
                      //         elevation: 5, // elevación
                      //         backgroundColor: colorsPuppleOpaco,
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 20,
                      //             vertical: 10), // relleno
                      //       ),
                      //       child: const Text('Cant Elab'),
                      //     ),
                      //   ),
                      // ),

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
            )
          ],
        ),
      ),
    );
  }
}
