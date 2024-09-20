import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/model/users.dart';
import 'package:tejidos/src/screen_admin/add_user.dart';
import 'package:tejidos/src/screen_admin/provider_user/services_provider_users.dart';
import 'package:tejidos/src/util/commo_pallete.dart';
import 'package:tejidos/src/util/font_style.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';
import 'package:tejidos/src/util/dialog_confimarcion.dart';

import '../widgets/button_drawer.dart';

const colorShadow = Color.fromARGB(255, 216, 195, 146);
const colorBackGroud = Color(0xffD3D4D4);
const colorMainText = Color(0xff182249);

class ScreenUsersAdmin extends StatefulWidget {
  const ScreenUsersAdmin({Key? key}) : super(key: key);

  @override
  State<ScreenUsersAdmin> createState() => _ScreenUsersAdminState();
}

class _ScreenUsersAdminState extends State<ScreenUsersAdmin> {
  @override
  Widget build(BuildContext context) {
    // var textSize = 10.0;
    final size = MediaQuery.of(context).size;
    // print(size);

    /////// de 0 a 600
    if (size.width > 0 && size.width <= 600) {
      // textSize = size.width * 0.020;
    } else {
      // textSize = 15;
    }

    // final _styleCustom = TextStyle(fontSize: textSize);
    // #EAEBEB #454C4C  #929C9C  #956565  #B8CDCD  #D3D4D4  #C29393  #BBA4A4  #DCD3D3  #E4C4C4

    return Scaffold(
      backgroundColor: const Color(0xffD3D4D4),
      body: Column(
        children: [
          //  ,
          size.width > 500
              ? Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      PanelRightUserAdmin(size: size),
                      const SizedBox(width: 25),
                      TopMainUsers(size: size),
                    ],
                  ),
                )
              : const Column(
                  children: [AppBarCustom(title: 'Admin Users')],
                ),
        ],
      ),
    );
  }
}

class TopMainUsers extends StatefulWidget {
  const TopMainUsers({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<TopMainUsers> createState() => _TopMainUsersState();
}

class _TopMainUsersState extends State<TopMainUsers> {
  Users localUser = Users();
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.read<ServicesProviderUsers>();
    // List<Users> userList = [];
    return SizedBox(
      // color: Colors.teal,
      height: widget.size.height / 1.3,
      width: widget.size.width * 0.60,
      // width: size.width / 1.2,
      // margin: EdgeInsets.all(1),
      // padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 75,
            width: widget.size.width * 0.70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  // Color.fromARGB(255, 160, 172, 168),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                  '${currentUsers?.fullName.toString().substring(0, 2)}'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentUsers?.fullName}',
                                  style: const TextStyle(
                                      color: colorMainText,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${currentUsers?.occupation}',
                                  style: const TextStyle(color: colorTextt),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: colorBackGroud,
                              ),
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.calendar_today_rounded,
                                      size: 16, color: colorMainText),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      '${currentUsers?.created}',
                                      style: const TextStyle(
                                          color: colorMainText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FadeIn(
                              child: SizedBox(
                                width: 200,
                                height: 35,
                                child: Material(
                                  color: colorBackGroud,
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: TextField(
                                    // controller: controllerSearching,
                                    onChanged: (val) =>
                                        usersProvider.searchingFilter(val),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 15.0, bottom: 15),
                                        hintText: 'Buscar',
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(15),
              child: FutureBuilder(
                future: usersProvider.getUserAdmin(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: context
                        .watch<ServicesProviderUsers>()
                        .userListFilter
                        .length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      Users current = context
                          .watch<ServicesProviderUsers>()
                          .userListFilter[index];
                      return Container(
                        height: 100,
                        width: 200,
                        margin: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 13),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircleAvatar(
                                        child: Text(
                                          current.fullName
                                              .toString()
                                              .substring(0, 2),
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 75,
                                          child: Tooltip(
                                            message: current.fullName,
                                            child: Text(
                                              '${current.fullName}',
                                              style: const TextStyle(
                                                  color: colorMainText,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${current.occupation}',
                                          style: const TextStyle(
                                              color: colorTextt),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(current.code ?? 'N/A',
                                      style: const TextStyle(
                                        color: colorsAd,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Acceso ${current.type ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: colorsAd,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                    color: colorBackGroud,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Created',
                                        style: TextStyle(
                                            fontFamily: fontAbril,
                                            color: colorsBlueDeepHigh)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.public, size: 16),
                                        const SizedBox(width: 10),
                                        Text(current.created ?? 'N/A',
                                            style: TextStyle(
                                                fontFamily: fontBalooPaaji)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  localUser = current;

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Actualizar Usuario'),
                                        content: Form(
                                          key: keyForm,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextFormField(
                                                initialValue:
                                                    localUser.fullName,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Nombre completo',
                                                ),
                                                onSaved: (String? value) {
                                                  // Guardar el valor del campo en una variable
                                                  localUser.fullName = value;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese un Full name válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                initialValue: localUser.code,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Código',
                                                ),
                                                onSaved: (String? value) {
                                                  // Guardar el valor del campo en una variable
                                                  localUser.code = value;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese un Codigo válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                initialValue: localUser.turn,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Turno',
                                                ),
                                                onSaved: (String? value) {
                                                  // Guardar el valor del campo en una variable
                                                  localUser.turn = value;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese un turno válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    localUser.occupation,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Cargo',
                                                ),
                                                onSaved: (String? value) {
                                                  // Guardar el valor del campo en una variable
                                                  localUser.occupation = value;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese una occupation válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                initialValue: localUser.type,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Acceso',
                                                ),
                                                onSaved: (String? value) {
                                                  // Guardar el valor del campo en una variable
                                                  localUser.type = value;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese una Acceso válido';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Guardar'),
                                            onPressed: () {
                                              if (keyForm.currentState!
                                                  .validate()) {
                                                // Si el formulario es válido, guardar los cambios
                                                keyForm.currentState!.save();
                                                usersProvider
                                                    .updateFrom(localUser);
                                                Navigator.of(context).pop();
                                                keyForm.currentState!.reset();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Actualizar'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.orange)),
                                child: const Text('Desactivar'),
                                onPressed: () {},
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.red)),
                                child: const Text('Borrar'),
                                onPressed: () async {
                                  localUser = current;

                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmacionDialog(
                                        mensaje:
                                            '❌❌Esta seguro de Eliminar este Usuario❌❌',
                                        titulo: 'Aviso',
                                        onConfirmar: () {
                                          Navigator.of(context).pop();
                                          // print('Correcto');

                                          // print(data);
                                          usersProvider.deleteFrom(localUser);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

const colorTextt = Color(0xff929C9C);

class PanelRightUserAdmin extends StatelessWidget {
  const PanelRightUserAdmin({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 1.3,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffEAEBEB),
            // Color.fromARGB(255, 160, 172, 168),
            Color(0xffEAEBEB)
          ],
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: colorShadow,
        //     blurRadius: 15.0,
        //     offset: Offset(0.0, 5.0),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/logo_app.png',
              height: 80,
              width: 150,
            ),
          ),
          const SizedBox(height: 20),
          ButtonDrawer(
            icon: Icons.add,
            colorIcon: colorsBlueDeepHigh,
            text: 'Add Empleado',
            colorText: colorsBlueDeepHigh,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (conext) => const AddUser(),
                ),
              );
            },
          ),
          ButtonDrawer(
            icon: Icons.add,
            colorIcon: colorTextt,
            text: 'Add Falta Empl.',
            colorText: colorTextt,
            press: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (conext) => const AddUser(),
              //   ),
              // );
            },
          ),
          ButtonDrawer(
            icon: Icons.warning_amber_rounded,
            colorIcon: colorTextt,
            text: 'Falta Empleado',
            colorText: colorTextt,
            press: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (conext) => const AddIncidenciaOut(),
              //   ),
              // );
            },
          ),
          ButtonDrawer(
            icon: Icons.list_alt_outlined,
            colorIcon: colorTextt,
            text: 'Reglamentos',
            colorText: colorTextt,
            press: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    label: const Text(
                      'Ir Hacia Atra',
                      style: TextStyle(color: Colors.black),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '@LuDeveloper',
                    style: TextStyle(
                      fontFamily: fontBalooPaaji,
                      fontSize: 11,
                      color: colorTextt,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Expanded(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                           itemCount: userList.length,
//                           itemBuilder: (context, index) {
//                             Users current = userList[index];
//                             return Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(11.0),
//                                 child: Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Column(
//                                           children: [
//                                             Text(
//                                                 'Codigo: ${current.code ?? 'N/A'}',
//                                                 style: _styleCustom),
//                                             Text(
//                                                 'Nombre: ${current.fullName ?? 'N/A'}',
//                                                 style: _styleCustom),
//                                             Text(
//                                                 'Ocupación: ${current.occupation ?? 'N/A'}',
//                                                 style: _styleCustom),
//                                             Text(
//                                                 'Turno:  ${current.turn ?? 'N/A'}',
//                                                 style: _styleCustom),
//                                             Text(
//                                                 'Fecha Entrada: ${current.created ?? 'N/A'}',
//                                                 style: _styleCustom),
//                                           ],
//                                         ),
//                                         TextButton.icon(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               EdittingUsers(
//                                                                   userEdit:
//                                                                       current)))
//                                                   .then((value) => {
//                                                         getUserAdmin(),
//                                                       });
//                                             },
//                                             icon: const Icon(Icons.edit,
//                                                 color: Colors.red, size: 10),
//                                             label: Text('Editar',
//                                                 style: _styleCustom))
//                                       ],
//                                     )),
//                               ),
//                             );
//                           }),
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                   flex: 2,
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 100,
//                         child: Lottie.asset('animation/fire.json',
//                             repeat: true, reverse: true),
//                       ),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (conext) => const AddUser()))
//                                 .then((value) => {
//                                       getUserAdmin(),
//                                     });
//                           },
//                           child: const Text('Agregar nuevo usuario')),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 10),
//                         child: Text(
//                             'También es importante validar la información ingresada por el usuario antes de agregar un nuevo registro para evitar errores o datos incorrectos.'),
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//         )
