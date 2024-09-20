import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

class SelectedDepartments extends StatefulWidget {
  const SelectedDepartments({Key? key, required this.pressDepartment})
      : super(key: key);
  final Function pressDepartment;
  @override
  State<SelectedDepartments> createState() => _SelectedDepartmentsState();
}

class _SelectedDepartmentsState extends State<SelectedDepartments> {
  List<Department> list = [];
  List choosed = [];
  Future getDepartmentNiveles() async {
    final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    list = departmentFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // date = DateTime.now().toString().substring(0, 10);
    getDepartmentNiveles();
    // getNiveles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Elegir Departamentos'),
          choosed.isNotEmpty
              ? SizedBox(
                  height: 50,
                  width: 300,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: choosed
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Chip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(e),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    choosed.remove(e);
                                  });
                                },
                                deleteIcon: const Icon(Icons.close),
                              ),
                            ))
                        .toList(),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Department current = list[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      choosed.add(current.nameDepartment);
                    });
                  },
                  title: Text(current.nameDepartment.toString()),
                  subtitle: const Text('Selected'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.pressDepartment(choosed);
                    },
                    child: const Text('Terminar'))),
          )
        ],
      ),
    );
  }
}
