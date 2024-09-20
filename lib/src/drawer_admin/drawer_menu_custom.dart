import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/folder_cliente_company/screen_cliente_company.dart';
import 'package:tejidos/src/home.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/home_incidencia_pendientes.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/home_incidencia_resuelto.dart';
import 'package:tejidos/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_out.dart';
import 'package:tejidos/src/nivel_2/folder_planificacion/screen_planificacion_semanal.dart';
import 'package:tejidos/src/nivel_2/folder_reception/historia_record/list_report_intput_output.dart';
import 'package:tejidos/src/pages/sign_in/sign_in_login.dart';
import 'package:tejidos/src/screen_admin/screen_users_admin.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import '../folder_cliente_company/add_cliente.dart';
import '../folder_cuentas_por_cobrar_othe/screen_main_cuentas.dart';
import '../folder_type_works/add_type_work.dart';
import '../nivel_2/folder_actividades_foxin/screen_actividades.dart';
import '../widgets/button_menu_drawer.dart';

class DrawerMenuCustom extends StatefulWidget {
  const DrawerMenuCustom({super.key});

  @override
  State<DrawerMenuCustom> createState() => _DrawerMenuCustomState();
}

class _DrawerMenuCustomState extends State<DrawerMenuCustom> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      height: size.height,
      width: 200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (conext) => const MyHomePage()),
                          (route) => false);
                    },
                    child:
                        BounceInDown(child: Image.asset(logoApp, height: 50))),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Gestion Clientes',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh))
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.home_outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) => const AddClientForm()),
                            );
                          },
                          textButton: 'Agregar clientes'),
                      MyWidgetButton(
                          icon: Icons.group,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) =>
                                        const ScreenClientes()));
                          },
                          textButton: 'Lista clientes'),
                    ],
                  ),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Gestion Cobros',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.snippet_folder_outlined,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) =>
                                        const ScreenMainCuentas()));
                          },
                          textButton: 'Cuentas Por Cobrar'),
                    ],
                  ),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Gestion Usuarios',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.person_2_outlined,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) =>
                                        const ScreenUsersAdmin()));
                          },
                          textButton: 'Usuarios'),
                    ],
                  ),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Gestion Incidencia',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (conext) => const AddIncidenciaOut(),
                              ),
                            );
                          },
                          textButton: 'Agregar Incidencias'),
                      MyWidgetButton(
                          icon: Icons.warning_amber_rounded,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) =>
                                        const HomeIncidenciaPendientes()));
                          },
                          textButton: 'Incidencias'),
                      MyWidgetButton(
                          icon: Icons.find_in_page,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) =>
                                        const HomeIncidenciaResueltos()));
                          },
                          textButton: 'Inc. Resueltos'),
                    ],
                  ),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Planificación',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.warning_amber_rounded,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (conext) =>
                                    const ScreenPlanificacionSemanal(),
                              ),
                            );
                          },
                          textButton: 'Area de Trabajos'),
                    ],
                  ),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Administración',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      MyWidgetButton(
                          icon: Icons.workspaces_outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddTypeWork()),
                            );
                          },
                          textButton: 'Tipos de Trabajos'),
                      MyWidgetButton(
                          icon: Icons.list,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListReportInputOutPut()));
                          },
                          textButton: 'Reception R.'),
                      MyWidgetButton(
                          icon: Icons.local_activity_rounded,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenActividades()));
                          },
                          textButton: 'Actividades'),
                      const Divider(endIndent: 20, indent: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text('Sección',
                                textAlign: TextAlign.justify,
                                style: style.bodySmall
                                    ?.copyWith(color: colorsBlueDeepHigh)),
                          ],
                        ),
                      ),
                      MyWidgetButton(
                          icon: Icons.local_activity_rounded,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (conext) => const SignInLogin()),
                                (route) => false);
                          },
                          textButton: 'Cerrar Sección'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
