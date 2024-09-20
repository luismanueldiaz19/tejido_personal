import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/model_planificacion/planificacion_last.dart';

import 'package:tejidos/src/nivel_2/folder_planificacion/provider_planificacion_services.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
// import 'package:tejidos/src/util/show_mesenger.dart';
// import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

import '../folder_insidensia/pages_insidencia.dart/selected_department.dart';
import '../folder_reception/provider_reception_planificacion.dart';

class AddPlanificacionForm extends StatefulWidget {
  const AddPlanificacionForm({Key? key}) : super(key: key);

  @override
  State<AddPlanificacionForm> createState() => _AddPlanificacionFormState();
}

class _AddPlanificacionFormState extends State<AddPlanificacionForm> {
  final _formKey = GlobalKey<FormState>();
  List<PlanificacionLast> planificacionList = [];
  // Variables para almacenar los valores del formulario
  String nameLogo = '';
  String numOrden = '';
  String client = '';
  String numClient = '';
  String ficha = '';
  List<String> departments = [];
  //////////////////
  DateTime? _dateCreated;
  //////////////////

  //////////////////

  DateTime? _dateCreatedEntrega;
  //////////////////
  int? cantPieza;

  void methondSend(PlanificacionProvider planificacionProvider) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Random num = Random();
      var data = {
        'user_registro_orden': currentUsers?.fullName.toString(),
        'cliente': client.toString(),
        'cliente_telefono': numClient.toString(),
        'num_orden': numOrden.toString(),
        'name_logo': nameLogo.toString(),
        'ficha': ficha.toString(),
        'fecha_start': _dateCreated.toString().substring(0, 10),
        'fecha_entrega': _dateCreatedEntrega.toString().substring(0, 10),
        'is_key_unique_product': num.nextInt(999999999).toString(),
      };
      verificacionFichaVacia(ficha, data);
    }
  }

  verificacionFichaVacia(ficha, data) async {
    final res = await httpRequestDatabase(
        selectPlanificacionLastValidarFicha, {'ficha': ficha});

    print('comprobando ficha vacia ${res.body}');
    planificacionList = planificacionLastFromJson(res.body);

    if (planificacionList.isEmpty) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProductoPlanificacion(data: data)));
      }
    } else {
      if (mounted) {
        utilShowMesenger(
            context, 'Esta Ficha se encuentra llenar en el sistema',
            title: 'Corregir');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final planificacionProvider = context.read<PlanificacionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Orden Planificación')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            Form(
              key: _formKey,
              child: SizedBox(
                width: size.width * 0.50,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Num Orden'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        numOrden = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nombre Logo'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nameLogo = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Ficha'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        ficha = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nombre Cliente'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        client = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Telefono Cliente'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        numClient = value!;
                      },
                    ),
                    // departments.isEmpty
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(20.0),
                    //         child: SizedBox(
                    //           width: 200,
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => SelectedDepartments(
                    //                     pressDepartment: (val) {
                    //                       setState(() {
                    //                         departments = [...val];
                    //                         print(
                    //                             'Departamentos .... $departments');
                    //                       });
                    //                     },
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //             style: ElevatedButton.styleFrom(
                    //               // color de texto
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(
                    //                     10), // redondear bordes
                    //               ),
                    //               elevation: 5, // elevación
                    //               backgroundColor: colorsAd,
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 20, vertical: 10), // relleno
                    //             ),
                    //             child: const Text('Elegir Departmentos'),
                    //           ),
                    //         ),
                    //       )
                    //     : TextFormField(
                    //         keyboardType: TextInputType.number,
                    //         enabled: false,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly,
                    //         ],
                    //         decoration: InputDecoration(
                    //             labelText: departments.toString(),
                    //             hintText: departments.toString()),
                    //       ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Inicio',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese una fecha';
                        }
                        return null;
                      },
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1995),
                          lastDate: DateTime(2300),
                        );
                        setState(() {
                          _dateCreated = date;
                        });
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _dateCreated == null
                            ? ''
                            : '${_dateCreated!.day}/${_dateCreated!.month}/${_dateCreated!.year}',
                      ),
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha Entrega',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese una Fecha Entrega';
                        }
                        return null;
                      },
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1995),
                          lastDate: DateTime(2300),
                        );
                        setState(() {
                          _dateCreatedEntrega = date;
                          // DateTime? _dateEntrega;
                          // DateTime? _dateCreatedEntrega;
                        });
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _dateCreatedEntrega == null
                            ? ''
                            : '${_dateCreatedEntrega!.day}/${_dateCreatedEntrega!.month}/${_dateCreatedEntrega!.year}',
                      ),
                      onSaved: (value) {},
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => methondSend(planificacionProvider),
                        style: ElevatedButton.styleFrom(
                          // color de texto
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // redondear bordes
                          ),
                          // elevation: 5, // elevación
                          // backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10), // relleno
                        ),
                        child: const Text('Enviar'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductoPlanificacion extends StatefulWidget {
  const AddProductoPlanificacion({Key? key, required this.data})
      : super(key: key);
  final Map<String, String?> data;
  @override
  State<AddProductoPlanificacion> createState() =>
      _AddProductoPlanificacionState();
}

class _AddProductoPlanificacionState extends State<AddProductoPlanificacion> {
  String tipoProduct = '';
  String cantProducto = '';
  // String deparment = '';

  List listDepartment = [];

  List<ProductPlanificaion> listProduct = [];

  final _formKey = GlobalKey<FormState>();

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
    // print('YA!');
  }

  bool isLoading = false;
  void terminarOrden() async {
    bool isSent = await sendDataLast(widget.data);

    if (isSent) {
      for (var element in listProduct) {
        // is_key_unique_product, tipo_product, cant, department,fecha_start,fecha_end
        var dataItem = {
          'is_key_unique_product': widget.data['is_key_unique_product'],
          'tipo_product': element.tipoProducto,
          'cant': element.cantProduto,
          'department': element.department,
          'fecha_start': widget.data['fecha_start'],
          'fecha_end': widget.data['fecha_entrega'],
        };
        addItemHttp(dataItem);
      }
      statuMethond(
          widget.data['is_key_unique_product'].toString(), 'Registrada');
    } else {
      shomMjs('Error Al subir Al Servidor / O ya existe este numero de orden');
    }
  }

  void shomMjs(String msj) => utilShowMesenger(context, msj);

  Future addItemHttp(data) async {
    // print('Item Agregado $index');
    await httpRequestDatabase(insertProductoPlanificacionLast, data);
    // print(res.body);
  }

  Future<bool> sendDataLast(data) async {
    //print(data);
    bool isDataArrived = false;
    final res = await httpRequestDatabase(insertPlanificacionLast, data);
    if (res.body.toString() == 'good') {
      isDataArrived = true;
      // print(res.body);
      return isDataArrived;
    } else {
      // print(res.body);
      return isDataArrived;
    }
  }

  Future statuMethond(String id, String statu) async {
    var data = {'id': id, 'statu': statu};
    await httpRequestDatabase(updatePlanificacionLastStatu, data);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final planificacionProvider = context.read<PlanificacionProvider>();
    final receptionProvider = context.read<ReceptionProviderPlanificacion>();

    return Scaffold(
      appBar: AppBar(title: const Text('Continuar')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Espere ... Por favor')])
              : SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text('Validar Información',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: colorsRedVino,
                                            fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                _buildDetalleItem('User Registro Orden',
                                    widget.data['user_registro_orden']),
                                _buildDetalleItem(
                                    'Cliente', widget.data['cliente']),
                                _buildDetalleItem('Cliente Teléfono',
                                    widget.data['cliente_telefono']),
                                _buildDetalleItem('Número de Orden',
                                    widget.data['num_orden']),
                                _buildDetalleItem('Nombre del Logo',
                                    widget.data['name_logo']),
                                _buildDetalleItem(
                                    'Ficha', widget.data['ficha']),
                                _buildDetalleItem('Fecha de Inicio',
                                    widget.data['fecha_start']),
                                _buildDetalleItem('Fecha de Entrega',
                                    widget.data['fecha_entrega']),
                                const SizedBox(height: 15),
                                listProduct.isNotEmpty
                                    ? SizedBox(
                                        width: 100,
                                        height: 35,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            terminarOrden();
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                            receptionProvider
                                                .getReceptionPlanificacionAll(
                                                    DateTime.now()
                                                        .toString()
                                                        .substring(0),
                                                    DateTime.now()
                                                        .toString()
                                                        .substring(0));
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await Future.delayed(const Duration(
                                                milliseconds: 400));
                                            if (mounted) Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // color de texto
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // redondear bordes
                                            ),
                                            elevation: 5, // elevación
                                            backgroundColor: colorsRed,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // relleno
                                          ),
                                          child: const Text(
                                            'Terminar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(width: 100),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text('Agregar Productos',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              color: colorsBlueTurquesa,
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText: 'Detalle Producto'),
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
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'Cantidad'),
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
                                                    builder: (context) =>
                                                        SelectedDepartments(
                                                      pressDepartment: (val) {
                                                        setState(() {
                                                          listDepartment = val;
                                                          if (listDepartment
                                                              .contains(
                                                                  'Sublimación')) {
                                                            listDepartment.add(
                                                                'Plancha/Empaque');
                                                            listDepartment
                                                                .add('Printer');
                                                          }
                                                          if (listDepartment
                                                              .contains(
                                                                  'Serigrafia')) {
                                                            listDepartment.add(
                                                                'Plancha/Empaque');
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // redondear bordes
                                                ),
                                                elevation: 5, // elevación
                                                backgroundColor: colorsAd,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical:
                                                            10), // relleno
                                              ),
                                              child: const Text(
                                                'Elegir Departmentos',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            decoration: InputDecoration(
                                                labelText:
                                                    listDepartment.join(','),
                                                hintText:
                                                    listDepartment.join(',')),
                                          ),
                                        ),
                                  const SizedBox(height: 10),
                                  listDepartment.isNotEmpty
                                      ? SizedBox(
                                          height: 35,
                                          child: TextButton(
                                            onPressed: () => addProducto(),
                                            child:
                                                const Text('Agregar producto'),
                                          ),
                                        )
                                      : const SizedBox(height: 1),
                                ],
                              ),
                            )
                          ],
                        ),
                        listProduct.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                    'Validar Información de Producto Agregado',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: colorsBlueTurquesa,
                                            fontWeight: FontWeight.bold)),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
          isLoading
              ? const Text('')
              : listProduct.isNotEmpty
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
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
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
                  : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildDetalleItem(String label, dynamic value) {
    return Row(
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

class ProductPlanificaion {
  String? tipoProducto;
  String? cantProduto;
  String? department;

  ProductPlanificaion({
    this.tipoProducto,
    this.cantProduto,
    this.department,
  });
}
