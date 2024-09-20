import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../datebase/url.dart';

class UploadService {
  Future<String> uploadImage(File imageFile, String id, String nameFile) async {
    var uri = Uri.parse(
        "http://$ipLocal/tejido/image_document_profiles/upload_document_profiles.php");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: nameFile,
      ))
      ..fields['cliente_id'] = id;
    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var responseBody = await streamedResponse.stream.bytesToString();
        // print('responseBody : $responseBody');
        return responseBody;
      } else {
        return 'Error al cargar la imagen. Código de estado: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      return 'Error al cargar la imagen: $e';
    }
  }

  Future<String> actualiarProfilePhoto(
      File imageFile, String id, String nameFile) async {
    var uri = Uri.parse(
        "http://$ipLocal/tu_prestamo/imagen_profiles/upload_profiles.php");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path,
          filename: nameFile))
      ..fields['cliente_id'] = id;
    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var responseBody = await streamedResponse.stream.bytesToString();
        // print('responseBody : $responseBody');
        return responseBody;
      } else {
        return 'Error al cargar la imagen. Código de estado: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      return 'Error al cargar la imagen: $e';
    }
  }

  Future<String> uploadDocumentRentedCar(
      File imageFile, String id, String nameFile) async {
    var uri = Uri.parse(
        "http://$ipLocal/tu_prestamo/imagen_document_rented_car/upload_document_rented_car.php");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: nameFile,
      ))
      ..fields['renta_id'] = id;
    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var responseBody = await streamedResponse.stream.bytesToString();
        // print('responseBody : $responseBody');
        return responseBody;
      } else {
        return 'Error al cargar la imagen. Código de estado: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      return 'Error al cargar la imagen: $e';
    }
  }

// /upload_document_rented_car
}
