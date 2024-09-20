import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/selected_department.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/add_planificacion.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

import '../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../folder_planificacion/url_planificacion/url_planificacion.dart';

class AddItemOrden extends StatefulWidget {
  const AddItemOrden({Key? key, required this.item}) : super(key: key);
  final PlanificacionLast item;

  @override
  State<AddItemOrden> createState() => _AddItemOrdenState();
}

class _AddItemOrdenState extends State<AddItemOrden> {
  final _formKey = GlobalKey<FormState>();
  String tipoProduct = '';
  String cantProducto = '';
  // String deparment = '';
  List<ProductPlanificaion> listProduct = [];
  List listDepartment = [];
  void addProducto() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      for (var depart in listDepartment) {
        listProduct.add(ProductPlanificaion(
            cantProduto: cantProducto,
            tipoProducto: tipoProduct,
            department: depart));
      }
      _formKey.currentState?.reset();
      tipoProduct = '';
      cantProducto = '';
      listDepartment.clear();
      setState(() {});
    }
  }

  void terminarOrden() async {
    for (var element in listProduct) {
      // is_key_unique_product, tipo_product, cant, department,fecha_start,fecha_end
      var dataItem = {
        'is_key_unique_product': widget.item.isKeyUniqueProduct,
        'tipo_product': element.tipoProducto,
        'cant': element.cantProduto,
        'department': element.department,
        'fecha_start': widget.item.fechaStart,
        'fecha_end': widget.item.fechaEntrega,
      };
      addItemHttp(dataItem);
    }
    statuMethond(widget.item.isKeyUniqueProduct.toString(), 'New Item');
    Navigator.pop(context, true);
  }

  Future statuMethond(String id, String statu) async {
    var data = {'id': id, 'statu': statu};
    await httpRequestDatabase(updatePlanificacionLastStatu, data);
  }

  Future addItemHttp(data) async {
    // print('Item Agregado $index');
    await httpRequestDatabase(insertProductoPlanificacionLast, data);
    // print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Agregar producto'),
          Column(
            children: [
              Text('Agregar Productos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorsBlueTurquesa, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildDetalleItem('Número de Orden', widget.item.numOrden),
              _buildDetalleItem('Nombre del Logo', widget.item.nameLogo),
              _buildDetalleItem('Ficha', widget.item.ficha),
              // listProduct.isNotEmpty
              //     ? SizedBox(
              //         width: 100,
              //         height: 35,
              //         child: ElevatedButton(
              //           onPressed: () async {
              //             setState(() {
              //               isLoading = true;
              //             });
              //             terminarOrden();

              //             await Future.delayed(const Duration(seconds: 1));
              //             receptionProvider.getReceptionPlanificacionAll('all');
              //             setState(() {
              //               isLoading = false;
              //             });
              //             await Future.delayed(
              //                 const Duration(milliseconds: 400));
              //             if (mounted) Navigator.pop(context);
              //           },
              //           style: ElevatedButton.styleFrom(
              //             // color de texto
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(10), // redondear bordes
              //             ),
              //             elevation: 5, // elevación
              //             backgroundColor: colorsRed,
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 20, vertical: 10), // relleno
              //           ),
              //           child: const Text(
              //             'Terminar',
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:
                        const InputDecoration(labelText: 'Detalle Producto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      tipoProduct = value!;
                    },
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      cantProducto = value!;
                    },
                  ),
                ),
                listDepartment.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectedDepartments(
                                    pressDepartment: (val) {
                                      setState(() {
                                        listDepartment = val;
                                        if (listDepartment
                                            .contains('Sublimación')) {
                                          listDepartment.add('Plancha/Empaque');
                                          listDepartment.add('Printer');
                                        }
                                        if (listDepartment
                                            .contains('Serigrafia')) {
                                          listDepartment.add('Plancha/Empaque');
                                        }
                                      });
                                    },
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
                              'Elegir Departmentos',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 250,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          enabled: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                              labelText: listDepartment.join(','),
                              hintText: listDepartment.join(',')),
                        ),
                      ),
                const SizedBox(height: 10),
                listDepartment.isNotEmpty
                    ? SizedBox(
                        height: 35,
                        child: TextButton(
                          onPressed: () => addProducto(),
                          child: const Text('Agregar producto'),
                        ),
                      )
                    : const SizedBox(height: 1),
              ],
            ),
          ),
          listProduct.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      dataRowMaxHeight: 20,
                      dataRowMinHeight: 15,
                      horizontalMargin: 10.0,
                      columnSpacing: 15,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 205, 208, 221),
                            Color.fromARGB(255, 225, 228, 241),
                            Color.fromARGB(255, 233, 234, 238),
                          ],
                        ),
                      ),
                      border: TableBorder.symmetric(
                          inside: const BorderSide(
                              style: BorderStyle.solid, color: Colors.grey)),
                      columns: const [
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Producto')),
                        DataColumn(label: Text('Cantidad')),
                      ],
                      rows: listProduct!
                          .map(
                            (item) => DataRow(
                              // color: MaterialStateProperty.resolveWith(
                              //     (states) => getColor(item)),
                              cells: [
                                DataCell(Text(item.department ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      Text(item.tipoProducto ?? ''),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            listProduct.remove(item);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                DataCell(Text(item.cantProduto ?? '')),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          listProduct.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        terminarOrden();
                      },
                      style: ElevatedButton.styleFrom(
                        // color de texto
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // redondear bordes
                        ),
                        elevation: 5, // elevación
                        backgroundColor: colorsRed,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10), // relleno
                      ),
                      child: const Text(
                        'Terminar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildDetalleItem(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15.0),
        Text(
          value.toString(),
        ),
      ],
    );
  }
}
