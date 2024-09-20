class Clasificacion {
  Clasificacion(
      {this.fullName,
      this.calandra,
      this.empaque,
      this.horno,
      this.imprecionCortes,
      this.plancha,
      this.subNormal,
      this.transfer,
      this.vinil});
  String? fullName;
  String? calandra;
  String? empaque;
  String? plancha;
  String? horno;
  String? transfer;
  String? vinil;
  String? imprecionCortes;
  String? subNormal;
}

class Classico {
  Classico({
    this.fullName,
    this.cant,
    this.nameWork,
  });
  String? fullName;
  String? cant;
  String? nameWork;
}
