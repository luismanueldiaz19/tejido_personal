library database;

import 'package:http/http.dart' as http;
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/machine_stop.dart';
import 'package:tejidos/src/model/machine_stop_record.dart';
import 'package:tejidos/src/model/operation_modulo.dart';
import 'package:tejidos/src/model/tirada.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future httpRequestDatabase(String url, Map<String, dynamic> map) async {
  var client = http.Client();

  var response = await client.post(Uri.parse(url), body: map);
  if (response.statusCode == 200) {
    client.close();
    return response;
  } else {
    client.close();
  }
}

Future getListOperationModulo({idModulo}) async {
  final res =
      await httpRequestDatabase(selectOperationModulo, {'id_modulo': idModulo});
  // print(res.body);
  return operationModuloFromJson(res.body);
}

Future<List<MachineStop>> viewStopMachine(idMachine) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachine, {
    'idMachine': idMachine,
  });
  return machineStopFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<MachineStopRecord>> viewStopMachineRecord(
    idMachine, date1, date2) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachineRecord, {
    'idMachine': idMachine,
    'date1': date1,
    'date2': date2,
  });
  // print('Las parada son ${res.body}');
  return machineStopRecordFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<MachineStopRecord>> viewStopMachineRecordVerified(
    {numOrden}) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachineRecordVerified, {
    'num_orden': numOrden,
  });
  return machineStopRecordFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<Tirada>> viewTiradaVerified({numOrden}) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectReanudarOrdenVerified, {
    'num_orden': numOrden,
  });
  return tiradaFromJson(res.body);
  // return machineFromJson(res.body);
}

Future httpEnviaMap(String url, var jsonData) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonData,
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Error en la solicitud: ${response.statusCode}';
  }
}

Future<String> saveScreenshotToLocalFile(Uint8List image,
    {String? nameFile}) async {
  var directory = await getTemporaryDirectory();
  File file = File('${directory.path}/${nameFile}_screenshot.png');
  await file.writeAsBytes(image);
  return file.path;
}
