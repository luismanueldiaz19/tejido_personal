import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/folder_cuentas_por_cobrar/provider/provider_cuentas_por_cobrar.dart';
import 'package:tejidos/src/nivel_2/folder_reception/provider_reception_planificacion.dart';
import 'package:tejidos/src/screen_admin/provider_user/services_provider_users.dart';

import 'screen_splash.dart';
import 'src/folder_cliente_company/provider_clientes/provider_clientes.dart';
import 'src/nivel_2/folder_bordado/provider/provider_bordado.dart';
import 'src/nivel_2/folder_bordado/provider/provider_bordado_tirada.dart';
import 'src/nivel_2/folder_planificacion/provider_planificacion_services.dart';
import 'src/nivel_2/folder_satreria/provider/provider_sastreria.dart';
import 'src/nivel_2/folder_serigrafia/provider/provider_serigrafia.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlanificacionProvider()),
        ChangeNotifierProvider(create: (_) => ReceptionProviderPlanificacion()),
        ChangeNotifierProvider(create: (_) => ServicesProviderUsers()),
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProviderCuentasPorCobrar()),
        ChangeNotifierProvider(create: (_) => ProvideBordado()),
        ChangeNotifierProvider(create: (_) => ProviderBordadoTirada()),
        ChangeNotifierProvider(create: (_) => ProviderSastreria()),
        ChangeNotifierProvider(create: (_) => ProviderSerigrafia()),
      
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tejidos Tropical',
          scrollBehavior: MyCustomScrollBehavior(),
          color: const Color.fromARGB(255, 233, 234, 238),
          theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color.fromARGB(255, 233, 234, 238),
              buttonTheme: ButtonThemeData(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  minWidth: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    padding: MaterialStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5))),
              ),
              appBarTheme: AppBarTheme(
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Colors.transparent,
                  titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                  elevation: 0)),
          home: const ScreenSplash()),
    );
  }
}
