import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_almacen/screen_almacen.dart';
import 'package:tejidos/src/nivel_2/folder_bordado/bordado_orden_main/screen_bordado.dart';
import 'package:tejidos/src/nivel_2/folder_confecion/screen_confecion.dart';
import 'package:tejidos/src/nivel_2/folder_diseno/mode_diseno_direcion.dart';
import 'package:tejidos/src/nivel_2/folder_printer/screen_model_printer.dart';
import 'package:tejidos/src/nivel_2/folder_reception/screen_reception_entregas.dart';
import 'package:tejidos/src/nivel_2/folder_redes/screen_redes.dart';
import 'package:tejidos/src/nivel_2/folder_satreria/screen_sastreria_report.dart';
import 'package:tejidos/src/nivel_2/folder_serigrafia/serigrafia_depart.dart';
import 'package:tejidos/src/nivel_2/forder_sublimacion/sublimacion_depart.dart';
import 'package:tejidos/src/util/get_image_area.dart';
import 'package:tejidos/src/util/show_mesenger.dart';
// import 'package:tejidos/src/widgets/get_sized.dart';

class NivelWidgets extends StatefulWidget {
  const NivelWidgets({super.key});

  @override
  State<NivelWidgets> createState() => _NivelWidgetsState();
}

class _NivelWidgetsState extends State<NivelWidgets> {
  String date = '';
  List<Department> list = [];

  Future getDepartmentNiveles() async {
    if (mounted) {
      final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
      list = departmentFromJson(res.body);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getDepartmentNiveles();
  }

  void getNavigatorDepartment(Department current) {
    switch (current.id) {
      case '1':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SublimacioDepart(current: current)));
        break;

      case '2':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ModeDisenoDirecion(current: current)));

        break;
      case '3':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SerigrafiaDepart(current: current)));
        break;
      case '4':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenSastreriaReport(current: current)));
        break;
      case '5':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenBordado(current: current)));

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SerigrafiaNivelDos(current: current)));
        break;
      case '6':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenSastreriaReport(current: current)));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ScreenConfecion(current: current)));
        break;
      case '7':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenAlmacen(current: current)));
        break;

      case '8':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ScreenReceptionEntregas()));
        break;

      case '9':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ScreenRedes()));
        break;
      case '10':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenModelPrinter(current: current)));

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return list.isNotEmpty
        ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 1.9,
              maxCrossAxisExtent: 400,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Department current = list[index];
              String image = getImageAreas(int.parse(current.id.toString()));

              return BounceInDown(
                duration: Duration(milliseconds: 300 * index),
                child: GestureDetector(
                  onTap: () {
                    currentUsers!.type
                                .toString()
                                .contains(current.type ?? 'n'.toString()) ||
                            currentUsers!.type.toString().contains('t')
                        ? getNavigatorDepartment(current)
                        : () {};
                  },
                  child: Container(
                    height: 220,
                    width: 300,
                    margin: const EdgeInsets.all(1.0),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                              child: Image.asset(image, fit: BoxFit.cover)),
                        ),
                        const Positioned.fill(
                          child: Material(color: Colors.black45),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              current.nameDepartment.toString(),
                              style: style.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              current.type.toString().toUpperCase(),
                              style: style.bodySmall?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        currentUsers!.type
                                    .toString()
                                    .contains(current.type ?? '0'.toString()) ||
                                currentUsers!.type.toString().contains('t')
                            ? Container()
                            : GestureDetector(
                                onTap: () => utilShowMesenger(context,
                                    'Area Bloqueda Solicitar la Administrador',
                                    title: 'Información'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.lock,
                                        color: Colors.red, size: 50),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              );
            })
        : const Text('No hay Departamentos');
  }
}
