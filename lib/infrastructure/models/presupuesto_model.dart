class PresupuestoModel {
  final String id;
  final String nombre;
  final int cantidad;

  PresupuestoModel({required this.id,required this.nombre, required this.cantidad});

  factory PresupuestoModel.fromMap(Map<dynamic, dynamic> data,String id) {
    return PresupuestoModel(
      id: id ?? '',
      nombre: data['nombre'] ?? '',
      cantidad: data['cantidad'] ?? 0,
    );
  }
  // Método para convertir el modelo en un mapa, útil para actualizaciones en Firebase.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
    };
  }
}
