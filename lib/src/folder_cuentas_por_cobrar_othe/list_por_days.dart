import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/print/print_main_for_paid_diario.dart';
import 'package:tejidos/src/screen_print_pdf/apis/pdf_api.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import '../widgets/pick_range_date.dart';

class ListPorDays extends StatefulWidget {
  const ListPorDays({super.key});

  @override
  State<ListPorDays> createState() => _ListPorDaysState();
}

class _ListPorDaysState extends State<ListPorDays> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ForPaid> list = [];
  Future getDetalles() async {
    //select_cuentas_por_cobrar
    debugPrint('Get Cuentas Por Cobrar ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_por_pagar_inter_report.php";
    final res = await httpRequestDatabase(
        url, {'token': token, 'date1': firstDate, 'date2': secondDate});
    print(res.body);
    list = forPaidFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    getDetalles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento Por Dias'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () async {
              if (list.isNotEmpty) {
                final docs = await PrintMainForPaidDiario.generate(
                    list, '$firstDate-$secondDate');
                await PdfApi.openFile(docs);
              }
            },
            icon: const Icon(Icons.print),
          ),
        ),
      ]),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                firstDate = date1.toString();
                secondDate = date2.toString();
                getDetalles();
              });
            },
          ),
          Text('Informacion de Seguimientos',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: colorsAd)),
          const SizedBox(height: 5),
          list.isEmpty
              ? const Expanded(
                  child:
                      Center(child: Text('No hay Intervenciones en la Fecha')))
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    width: 350,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        ForPaid item = list[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            // tileColor: Colors.white,
                            title: Text('Client : ${item.fNombre ?? 'N/A'}',
                                style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Orden : ${item.fDocumento ?? 'N/A'}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text('Registed : ${item.interRegited ?? 'N/A'}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text('Nota : ${item.interComent ?? 'N/A'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: colorsBlueTurquesa)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Monto'),
                                    Text('\$ ${item.fMonto ?? ''}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Balance'),
                                    Text('\$ ${item.fBalance ?? ''}',
                                        style: const TextStyle(
                                            color: Colors.black)),
                                    const Text('Pagado'),
                                    Text('\$ ${ForPaid.restaItem(item)}',
                                        style: const TextStyle(
                                            color: Colors.green))
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(item.interHora ?? 'N/A',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  color: colorsGreenLevel)),
                                      const SizedBox(width: 5),
                                      const Icon(Icons.public,
                                          size: 16, color: colorsGreenLevel),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
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
                            Text('Total :',
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(width: 10),
                            Text(list.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Colors.brown,
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
