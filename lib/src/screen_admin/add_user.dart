import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/screen_admin/provider_user/services_provider_users.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late TextEditingController code;
  late TextEditingController name;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Sublimador';
    _selectedCategoryTurno = 'Turno A';
    name = TextEditingController();
    code = TextEditingController();
  }

  List<String> categories = [
    'Sublimador',
    'Operador',
    'master',
    'boss',
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
  Widget build(BuildContext context) {
    final usersProvider = context.read<ServicesProviderUsers>();

    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Agregar usuarios'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    BounceInRight(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        width: 200,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: name,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Nombre',
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    BounceInRight(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        width: 200,
                        child: TextField(
                          controller: code,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Codigo',
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextButton.icon(
                        onPressed: () {
                          if (name.text.isNotEmpty && code.text.isNotEmpty) {
                            var data = {
                              'full_name': name.text,
                              'occupation': _selectedCategory,
                              'code': code.text,
                              'turn': _selectedCategoryTurno,
                            };
                            usersProvider.addUser(data);
                            code.clear();
                            name.clear();
                          } else {
                            utilShowMesenger(context, 'hay datos vacia');
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Agregar usuario',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.orange.shade200),
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
    );
  }
}
