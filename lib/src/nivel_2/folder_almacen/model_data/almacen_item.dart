// To parse this JSON data, do
//
//     final almacenItem = almacenItemFromJson(jsonString);

import 'dart:convert';

List<AlmacenItem> almacenItemFromJson(String str) => List<AlmacenItem>.from(
    json.decode(str).map((x) => AlmacenItem.fromJson(x)));

String almacenItemToJson(List<AlmacenItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlmacenItem {
  AlmacenItem({
    this.id,
    this.idKeyItem,
    this.nameProducto,
    this.cant,
    this.price,
  });

  String? id;
  String? idKeyItem;
  String? nameProducto;
  String? cant;
  String? price;

  factory AlmacenItem.fromJson(Map<String, dynamic> json) => AlmacenItem(
        id: json["id"],
        idKeyItem: json["id_key_item"],
        nameProducto: json["name_producto"],
        cant: json["cant"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_key_item": idKeyItem,
        "name_producto": nameProducto,
        "cant": cant,
        "price": price,
      };
}
