import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/font_style.dart';

class CardSublimacion extends StatelessWidget {
  const CardSublimacion({
    super.key,
    required this.current,
    required this.press,
    required this.pressDelete,
    required this.updateStart,
    required this.updateEnd,
    // required this.pressFinishedSublic
  });
  final Sublima current;
  final Function press;
  final Function pressDelete;
  final Function updateStart;
  final Function updateEnd;
  // final Function pressFinishedSublic;
  @override
  Widget build(BuildContext context) {
    var textSize = 10.0;
    final size = MediaQuery.of(context).size;
    // print(size);

    /////// de 0 a 600
    if (size.width > 0 && size.width <= 600) {
      textSize = size.width * 0.020;
    } else {
      textSize = 15;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        child: Material(
          borderRadius: BorderRadius.circular(05.0),
          color: colorsGreyWhite,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Operario : ${current.fullName.toString()}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: textSize),
                        ),
                        Text(
                          "Logo : ${current.nameLogo.toString()}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: textSize),
                        ),
                        Text(
                          "Trabajo : ${current.nameWork.toString()}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: textSize),
                        ),
                        Text(
                          "Trabajo Id : ${current.idKeyWork.toString()}",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontSize: textSize,
                                    color: colorsAd,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          children: [
                            Text(
                              current.cantPieza.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: textSize),
                            ),
                            Text(
                              '/',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              current.cantOrden.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.blueAccent,
                                      fontSize: textSize),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Start: ${current.dateStart.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: colorsGreenLevel,
                                          fontFamily: fontMuseo,
                                          fontSize: textSize),
                                ),
                                TextButton(
                                  child: Text(
                                    'Reportar',
                                    style: TextStyle(
                                      color: colorsGreenLevel,
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    updateStart();
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Finish: ${current.dateEnd.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: colorsRedVinoHard,
                                          fontFamily: fontMuseo,
                                          fontSize: textSize),
                                ),
                                TextButton(
                                  child: Text(
                                    'Terminar',
                                    style: TextStyle(
                                        color: colorsRedVinoHard,
                                        fontSize: textSize),
                                  ),
                                  onPressed: () {
                                    updateEnd();
                                  },
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('N Orden: '),
                          Text(
                            current.numOrden.toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      Text(
                        'Ficha : ${current.ficha.toString()}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: textSize),
                      ),
                      Row(
                        children: [
                          Text(
                            current.nameDepartment.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Colors.blueAccent, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    currentUsers?.occupation == OptionAdmin.supervisor.name ||
                            currentUsers?.occupation ==
                                OptionAdmin.admin.name ||
                            currentUsers?.occupation == OptionAdmin.master.name
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.white),
                              ),
                              onPressed: () {
                                pressDelete();
                              },
                              label: Text(
                                'Eliminar',
                                style: TextStyle(
                                    color: Colors.black, fontSize: textSize),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.live_help_outlined,
                          color: Colors.red),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddIncidenciaSublimacion(
                                    current: current)));
                      },
                      label: Text(
                        'Incidencia',
                        style:
                            TextStyle(color: Colors.black, fontSize: textSize),
                      ),
                    ),
                    // const SizedBox(width: 10),
                    current.dateStart != 'N/A' && current.dateEnd != 'N/A'
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.white),
                            ),
                            onPressed: () => press(),
                            child: Text(
                              'Reportar',
                              style: TextStyle(fontSize: textSize),
                            ),
                          )
                        : const Text('NoT Report')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
