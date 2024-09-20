import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tejidos/src/model/users.dart';

String appTOKEN = "SMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
Users? currentUsers;
DateTime? dateActual = DateTime.now();

const versionApp = 2;
bool isUpdate = false;

const nameApp = 'Tejidos Tropical';

const logoApp = 'assets/logo_app.png';

const firmaLu = "assets/logo_lu.png";

enum OptionAdmin { admin, master, supervisor, boss }

const String onProducion = 'En Produción';
const String onEntregar = 'Por Entregar';
const String onParada = 'En Parada';
const String onFallo = 'En Error';
const String onDone = 'Listo';
const String onProceso = 'En Proceso';
const String onOutStatu = 'N/A';

String textConfirmacion = '👉🏼Esta seguro realizar el pedido ? 👈🏼';
String eliminarMjs = '🥺Esta seguro de eliminar🥺';
String actionMjs = '👉🏼Esta seguro de confirmar el tiempo ?👈🏼';
String confirmarMjs =
    '👉🏼Esta seguro de confirmar el despacho de las facturas?👈🏼';

bool validatorUser() {
  if (currentUsers?.occupation == OptionAdmin.admin.name ||
      currentUsers?.occupation == OptionAdmin.boss.name ||
      currentUsers?.occupation == OptionAdmin.master.name) {
    return true;
  }
  return false;
}

bool validateAdmin() {
  if (currentUsers?.occupation == OptionAdmin.boss.name ||
      currentUsers?.occupation == OptionAdmin.master.name) {
    return true;
  }
  return false;
}

bool validarContable() {
  return currentUsers?.code == '1302' ||
          currentUsers?.code == '199512' ||
          currentUsers?.code == '9876'
      ? true
      : false;
}

bool validarSupervisor() {
  return currentUsers?.occupation == OptionAdmin.admin.name ||
          currentUsers?.occupation == OptionAdmin.master.name ||
          currentUsers?.occupation == OptionAdmin.boss.name
      ? true
      : false;
}

bool validarMySelf(String? usuario) {
  return currentUsers?.fullName?.toUpperCase() == usuario?.toUpperCase()
      ? true
      : false;
}

class EmpresaLocal {
  String? nombreEmpresa;
  String? adressEmpressa;
  String? telefonoEmpresa;
  String? celularEmpresa;
  String? oficinaEmpres;
  String? rncEmpresa;
  String? nCFEmpresa;
  String? correoEmpresa;

  EmpresaLocal(
      {this.adressEmpressa,
      this.celularEmpresa,
      this.nombreEmpresa,
      this.oficinaEmpres,
      this.rncEmpresa,
      this.telefonoEmpresa,
      this.nCFEmpresa,
      this.correoEmpresa});
}

EmpresaLocal currentEmpresa = EmpresaLocal(
    adressEmpressa:
        'C. Beller #78, Puerto Plata 57000, Puerto Plata, República Dominicana',
    celularEmpresa: '829-733-7630',
    nombreEmpresa: 'Tejidos Tropical',
    oficinaEmpres: '(829) 733-7630',
    rncEmpresa: 'xxxxx-x',
    telefonoEmpresa: '829-733-7630',
    nCFEmpresa: 'A0100000001',
    correoEmpresa: 'Tejidos_Tropical_***@**.com');

// user : upload
// clave : tbsyomsyaasinjnjyeyye

// tbsyomsyaasinjnjyeyye

bool isNewVersionAvailable(int newVersion) {
  // Lógica para comparar las versiones y determinar si hay una nueva versión disponible
  // Puedes usar paquetes como 'version' para facilitar esta comparación
  // Aquí se realiza una comparación simple, asegúrate de ajustar según tus necesidades.
  return versionApp != newVersion ? true : false;
}

String obtenerSistemaOperativo() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  } else if (Platform.isWindows) {
    return 'Windows';
  } else if (Platform.isLinux) {
    return 'Linux';
  } else if (Platform.isMacOS) {
    return 'macOS';
  } else {
    return 'Plataforma desconocida';
  }
}

Widget identy(context) => Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 25),
      child: Text("©$nameApp Created by LuDeveloper",
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center),
    );
