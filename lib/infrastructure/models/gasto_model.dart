class GastoModel {
  final String id;
  final String concepto;
  final double monto;
  final String presupuestoId;

  GastoModel({required this.id, required this.concepto, required this.monto, required this.presupuestoId});

  factory GastoModel.fromMap(Map<dynamic, dynamic> data, String id) {
    return GastoModel(
      id: id,
      concepto: data['concepto'] ?? '',
      monto: (data['monto'] as num).toDouble() ?? 0.0,
      presupuestoId: data['presupuestoId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'concepto': concepto,
      'monto': monto,
      'presupuestoId': presupuestoId,
    };
  }
}
