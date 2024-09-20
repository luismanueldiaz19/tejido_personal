import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/users.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class EdittingUsers extends StatefulWidget {
  const EdittingUsers({Key? key, this.userEdit}) : super(key: key);
  final Users? userEdit;

  @override
  State<EdittingUsers> createState() => _EdittingUsersState();
}

class _EdittingUsersState extends State<EdittingUsers> {
  TextEditingController name = TextEditingController();

  TextEditingController code = TextEditingController();

  List<String> categories = [
    'Sublimador',
    'Operador',
    'master',
    'Diseñador',
    'Costura',
    'Otros',
    'Limpieza',
    'Supervisor',
  ];
  List<String> categoriesTurno = ['Turno A', 'Turno B', 'Sin Turno'];
  late String _selectedCategory;
  late String _selectedCategoryTurno;
  @override
  void initState() {
    super.initState();
    code.text = widget.userEdit?.code ?? '';
    name.text = widget.userEdit?.fullName ?? '';
    _selectedCategory = 'Sublimador';
    _selectedCategoryTurno = 'Turno A';
  }

  Future updateFrom() async {
    //full_name= '$full_name', occupation= '$occupation',turn='$turn', code= '$code'

    var data = {
      'id': widget.userEdit?.id,
      'full_name': name.text,
      'occupation': _selectedCategory,
      'turn': _selectedCategoryTurno,
      'code': code.text,
    };
    print(data);
    final res = await httpRequestDatabase(updateUsers, data);
    print(res.body);
    if (res.body.toString().contains('good')) {
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future deleteFrom() async {
    await httpRequestDatabase(deleteUsers, {'id': widget.userEdit?.id});
    // print(res.body);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Editando'),
          ZoomIn(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 250,
                  child: TextField(
                    controller: name,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: colorsBlueDeepHigh),
                      labelText: 'Nombre',
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 250,
                  child: TextField(
                    controller: code,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: colorsBlueDeepHigh),
                      labelText: 'Codigo',
                      hintText: 'Codigo',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 15),
                DropdownButton<String>(
                  value: _selectedCategoryTurno,
                  items: categoriesTurno.map((turnCategori) {
                    return DropdownMenuItem<String>(
                      value: turnCategori,
                      child: Text(turnCategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryTurno = value.toString();
                    });
                  },
                ),
                // Text('Ocupación: ${widget.userEdit?.occupation ?? 'N/A'}'),
                // Text('Fecha Entrada: ${widget.userEdit?.created ?? 'N/A'}'),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextButton.icon(
                        onPressed: () {
                          updateFrom();
                          // showMensenger(context, 'Todavia en  Desarrollo');
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Update usuario',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.orange),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextButton.icon(
                        onPressed: () {
                          deleteFrom();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text(
                          'Eliminar usuario',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.red),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
