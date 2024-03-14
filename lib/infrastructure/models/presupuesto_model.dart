class PresupuestoModel {
  final String nombre;
  final int cantidad;

  PresupuestoModel({required this.nombre, required this.cantidad});

  factory PresupuestoModel.fromMap(Map<dynamic, dynamic> data) {
    return PresupuestoModel(
      nombre: data['nombre'] ?? '',
      cantidad: data['cantidad'] ?? 0,
    );
  }
}
