// To parse this JSON data, do
//
//     final newUsers = newUsersFromJson(jsonString);

import 'dart:convert';

List<NewUsers> listnewUsersFromJson(String str) =>
    List<NewUsers>.from(json.decode(str).map((x) => NewUsers.fromJson(x)));

String listnewUsersToJson(List<NewUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

NewUsers newUsersFromJson(String str) => NewUsers.fromJson(json.decode(str));

String newUsersToJson(NewUsers data) => json.encode(data.toJson());

// To parse this JSON data, do
//
//     final newUsers = newUsersFromJson(jsonString);

class NewUsers {
  bool? success;
  String? message;
  Usuario? usuario;
  List<Permiso>? permisos;

  NewUsers({
    this.success,
    this.message,
    this.usuario,
    this.permisos,
  });

  NewUsers copyWith({
    bool? success,
    String? message,
    Usuario? usuario,
    List<Permiso>? permisos,
  }) =>
      NewUsers(
        success: success ?? this.success,
        message: message ?? this.message,
        usuario: usuario ?? this.usuario,
        permisos: permisos ?? this.permisos,
      );

  factory NewUsers.fromJson(Map<String, dynamic> json) => NewUsers(
        success: json["success"],
        message: json["message"],
        usuario:
            json["usuario"] == null ? null : Usuario.fromJson(json["usuario"]),
        permisos: json["permisos"] == null
            ? []
            : List<Permiso>.from(
                json["permisos"]!.map((x) => Permiso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "usuario": usuario?.toJson(),
        "permisos": permisos == null
            ? []
            : List<dynamic>.from(permisos!.map((x) => x.toJson())),
      };
}

class Permiso {
  String? idModuloPermisos;
  String? nombrePermiso;
  String? accionPermiso;

  Permiso({
    this.idModuloPermisos,
    this.nombrePermiso,
    this.accionPermiso,
  });

  Permiso copyWith({
    String? idModuloPermisos,
    String? nombrePermiso,
    String? accionPermiso,
  }) =>
      Permiso(
        idModuloPermisos: idModuloPermisos ?? this.idModuloPermisos,
        nombrePermiso: nombrePermiso ?? this.nombrePermiso,
        accionPermiso: accionPermiso ?? this.accionPermiso,
      );

  factory Permiso.fromJson(Map<String, dynamic> json) => Permiso(
        idModuloPermisos: json["id_modulo_permisos"],
        nombrePermiso: json["nombre_permiso"],
        accionPermiso: json["accion_permiso"],
      );

  Map<String, dynamic> toJson() => {
        "id_modulo_permisos": idModuloPermisos,
        "nombre_permiso": nombrePermiso,
        "accion_permiso": accionPermiso,
      };
}

class Usuario {
  String? idUsuario;
  String? fullName;
  String? typeAccess;
  String? ocupacion;
  String? usuario;
  DateTime? createdAt;
  String? idRolle;

  Usuario({
    this.idUsuario,
    this.fullName,
    this.typeAccess,
    this.ocupacion,
    this.usuario,
    this.createdAt,
    this.idRolle,
  });

  Usuario copyWith({
    String? idUsuario,
    String? fullName,
    String? typeAccess,
    String? ocupacion,
    String? usuario,
    DateTime? createdAt,
    String? idRolle,
  }) =>
      Usuario(
        idUsuario: idUsuario ?? this.idUsuario,
        fullName: fullName ?? this.fullName,
        typeAccess: typeAccess ?? this.typeAccess,
        ocupacion: ocupacion ?? this.ocupacion,
        usuario: usuario ?? this.usuario,
        createdAt: createdAt ?? this.createdAt,
        idRolle: idRolle ?? this.idRolle,
      );

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json["id_usuario"],
        fullName: json["full_name"],
        typeAccess: json["type_access"],
        ocupacion: json["ocupacion"],
        usuario: json["usuario"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        idRolle: json["id_rolle"],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
        "full_name": fullName,
        "type_access": typeAccess,
        "ocupacion": ocupacion,
        "usuario": usuario,
        "created_at": createdAt?.toIso8601String(),
        "id_rolle": idRolle,
      };
}
