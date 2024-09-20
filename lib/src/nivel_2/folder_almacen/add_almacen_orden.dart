import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_almacen/model_data/almacen_item.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class AddAlmacenOrden extends StatefulWidget {
  const AddAlmacenOrden({Key? key, required this.current}) : super(key: key);
  final Department current;
  @override
  State<AddAlmacenOrden> createState() => _AddAlmacenOrdenState();
}

class _AddAlmacenOrdenState extends State<AddAlmacenOrden> {
  List<AlmacenItem> listItem = [];
  late TextEditingController ficha;
  late TextEditingController client;
  late TextEditingController orden;
  late TextEditingController nameProduct;
  late TextEditingController cant;
  late TextEditingController price;
  Random num = Random();
  int numRamdon = 0;
  bool isAddProducto = false;
  bool isIncidencia = false;

  void addItem() async {
    var data2 = {
      'ficha': ficha.text,
      'incidencia': isIncidencia.toString().substring(0, 1),
      'num_orden': orden.text,
      'id_depart': widget.current.id,
      'id_key_item': numRamdon.toString(),
      'date_current': DateTime.now().toString().substring(0, 19),
      'cliente': client.text,
      'code': currentUsers?.code.toString()
    };
    print(data2);
    final res = await httpRequestDatabase(insertAlmacen1, data2);
    debugPrint(res.body);
    for (var element in listItem) {
      addItemHttp(element);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future addItemHttp(AlmacenItem localData) async {
    //	$cant = $_POST['cant'];
    // $price = $_POST['price'];
    // $name_producto = $_POST['name_producto'];
    // $id_key_item = $_POST['id_key_item'];
    var data = {
      'name_producto': localData.nameProducto,
      'cant': localData.cant,
      'id_key_item': numRamdon.toString(),
      'price': localData.price,
    };

    final res = await httpRequestDatabase(insertAlmacenItem, data);
    debugPrint(res.body);
  }

  @override
  void initState() {
    super.initState();
    numRamdon = num.nextInt(999999999);
    ficha = TextEditingController();
    orden = TextEditingController();
    nameProduct = TextEditingController();
    cant = TextEditingController();
    price = TextEditingController();
    client = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    ficha.dispose();
    orden.dispose();
    nameProduct.dispose();
    cant.dispose();
    price.dispose();
    client.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Agregar Orden'),
          isAddProducto
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: nameProduct,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Nombre Pieza',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: cant,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Cantidad',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: price,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            if (cant.text.isNotEmpty &&
                                nameProduct.text.isNotEmpty &&
                                price.text.isNotEmpty) {
                              AlmacenItem data = AlmacenItem(
                                  cant: cant.text,
                                  idKeyItem: numRamdon.toString(),
                                  nameProducto: nameProduct.text,
                                  price: price.text);

                              setState(() {
                                listItem.add(data);
                                cant.clear();
                                nameProduct.clear();
                                price.clear();
                              });
                            } else {
                              utilShowMesenger(context, 'Deber de escribir');
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Precio',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorsAd,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextButton(
                          onPressed: () {
                            if (cant.text.isNotEmpty &&
                                nameProduct.text.isNotEmpty &&
                                price.text.isNotEmpty) {
                              AlmacenItem data = AlmacenItem(
                                  cant: cant.text,
                                  idKeyItem: numRamdon.toString(),
                                  nameProducto: nameProduct.text,
                                  price: price.text);

                              setState(() {
                                listItem.add(data);
                                cant.clear();
                                nameProduct.clear();
                                price.clear();
                              });
                            } else {
                              utilShowMesenger(context, 'Deber de escribir');
                            }
                          },
                          child: const Text('Agregar ala listas',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: client,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Cliente',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: orden,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Orden',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextField(
                          controller: ficha,
                          textInputAction: TextInputAction.done,
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
                    ),
                    const SizedBox(height: 10),
                    SlideInLeft(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('POR INCIDENCIA'),
                          const SizedBox(width: 15),
                          Checkbox(
                              value: isIncidencia,
                              onChanged: (value) {
                                setState(() {
                                  isIncidencia = !isIncidencia;
                                });
                              })
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ZoomIn(
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorsAd,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 250,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isAddProducto = !isAddProducto;
                            });
                          },
                          child: const Text('Continuar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
          listItem.isNotEmpty
              ? SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: listItem
                          .map(
                            (current) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                height: 100,
                                width: 200,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Product: ',
                                            style: TextStyle(
                                              color: colorsBlueTurquesa,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            current.nameProducto ?? 'N/A',
                                            style: const TextStyle(
                                              color: colorsBlueTurquesa,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Total PCS ',
                                            style: TextStyle(
                                              color: colorsAd,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            current.cant ?? 'N/A',
                                            style: const TextStyle(
                                              color: colorsAd,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Precio ',
                                            style: TextStyle(
                                              color: colorsPuppleOpaco,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${current.price} \$',
                                            style: const TextStyle(
                                              color: colorsPuppleOpaco,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              listItem.remove(current);
                                            });
                                          },
                                          child: const Text('X'))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : const SizedBox(),
          listItem.isNotEmpty
              ? ZoomIn(
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorsBlueDeepHigh,
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 250,
                    child: TextButton(
                      onPressed: () {
                        addItem();
                      },
                      child: const Text('Enviar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
