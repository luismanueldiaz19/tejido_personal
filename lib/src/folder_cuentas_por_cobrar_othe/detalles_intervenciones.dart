import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar_othe/model/for_paid.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import '../screen_print_pdf/apis/pdf_api.dart';
import 'print/print_detalles_for_paid.dart';

class DetallesIntervenciones extends StatefulWidget {
  const DetallesIntervenciones({super.key, this.item});
  final ForPaid? item;

  @override
  State<DetallesIntervenciones> createState() => _DetallesIntervencionesState();
}

class _DetallesIntervencionesState extends State<DetallesIntervenciones> {
  List<ForPaid> list = [];
  Future getDetalles() async {
    //select_cuentas_por_cobrar
    debugPrint('Get Cuentas Por Cobrar ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_por_pagar_inter.php";
    final res = await httpRequestDatabase(url,
        {'token': token, 'f_key_inter': widget.item?.fKeyInter.toString()});

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
      appBar: AppBar(title: const Text('Seguimiento Cuentas'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () async {
              if (list.isNotEmpty) {
                final pdfFile = await PrintDetallesForPaid.generate(list,
                    DateTime.now().toString().substring(0, 19), widget.item!);

                PdfApi.openFile(pdfFile);
              }
            },
            icon: const Icon(Icons.print),
          ),
        ),
      ]),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Text('Informacion de cuenta',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: colorsAd)),
          const SizedBox(height: 5),
          SizedBox(
            width: 350,
            child: ListTile(
              tileColor: colorsGreyWhite,
              title: Text(widget.item?.fNombre ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Num Orden :  ${widget.item?.fDocumento ?? ''}'),
                  const Divider(),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Monto'),
                          Text('\$ ${widget.item?.fMonto ?? ''}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Balance'),
                          Text('\$ ${widget.item?.fBalance ?? ''}',
                              style: const TextStyle(color: Colors.black)),
                          const Text('Pagado'),
                          Text('\$ ${ForPaid.restaItem(widget.item!)}',
                              style: const TextStyle(color: Colors.green))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const SizedBox(width: 350, child: Divider()),
          const SizedBox(height: 5),
          list.isEmpty
              ? const Expanded(child: Center(child: Text('Sin Intervenciones')))
              : Expanded(
                  child: SizedBox(
                  width: 350,
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        ForPaid item = list[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(item.interRegited ?? 'N/A',
                                style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.interComent ?? 'N/A',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
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
                      }),
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
