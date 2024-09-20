class CuentasPorCobrarLast {
  String? idCuentasPorCobrar;
  String? documento;
  String? idCliente;
  String? cliente;
  String? monto;
  String? fecha;
  String? dias;
  String? balance;
  String? vencimiento;
  String? avancesMonto;
  String? avancesPercent;
  String? direccion;
  String? telefono;
  String? comentarios;
  String? createBy;
  String? whatAction;
  String? fechaPertenecia;

  CuentasPorCobrarLast({
    this.idCuentasPorCobrar,
    this.documento = 'N/A',
    this.idCliente,
    this.cliente,
    this.monto,
    this.fecha,
    this.dias,
    this.balance,
    this.vencimiento,
    this.avancesMonto,
    this.avancesPercent = 'N/A',
    this.direccion,
    this.telefono,
    this.comentarios = 'N/A',
    this.createBy = 'N/A',
    this.whatAction = 'N/A',
    this.fechaPertenecia = 'N/A',
  });

  Map<String, dynamic> toJson() {
    return {
      'idCuentasPorCobrar': idCuentasPorCobrar ?? 'N/A',
      'documento': documento ?? 'N/A',
      'idCliente': idCliente ?? 'N/A',
      'cliente': cliente ?? 'N/A',
      'monto': monto ?? 'N/A',
      'fecha': fecha ?? 'N/A',
      'dias': dias ?? 'N/A',
      'balance': balance ?? 'N/A',
      'vencimiento': vencimiento ?? 'N/A',
      'avancesMonto': avancesMonto ?? 'N/A',
      'avancesPercent': avancesPercent ?? 'N/A',
      'direccion': direccion ?? 'N/A',
      'telefono': telefono ?? 'N/A',
      'comentarios': comentarios ?? 'N/A',
      'createBy': createBy ?? 'N/A',
      'whatAction': whatAction ?? 'N/A',
      'fechaPertenecia': fechaPertenecia ?? 'N/A',
    };
  }
}
