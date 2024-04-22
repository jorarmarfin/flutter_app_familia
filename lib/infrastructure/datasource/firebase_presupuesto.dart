import 'package:firebase_database/firebase_database.dart';

import '../models/presupuesto_model.dart';

class FirebasePresupuesto {
  final dbRef = FirebaseDatabase.instance.ref().child('presupuesto');
/*
* Obtener un stream de presupuestos
 */
  Stream<List<PresupuestoModel>> getPresupuestosStream() {
    return dbRef.onValue.map((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      final List<PresupuestoModel> presupuestos = [];
      if (map != null) {
        map.forEach((key, value) {
          var presupuesto = PresupuestoModel.fromMap(
              Map<dynamic, dynamic>.from(value), key);
          presupuestos.add(presupuesto);
        });
      }
      presupuestos.sort((a, b) => a.nombre.compareTo(b.nombre));
      return presupuestos;
    });
  }
  /*
  * Eliminar un presupuesto por su id
   */
  Future<void> eliminarPresupuestoPorId(String id) async {
    await dbRef.child(id).remove();
  }
  /*
  * Calcular el total de presupuesto
   */
  int calcularTotalPresupuesto(List<PresupuestoModel> presupuestos) {
    return presupuestos.fold(0, (sum, item) => sum + item.cantidad);
  }
  /*
  * Crear un nuevo registro en la base de datos
   */
  Future createNewRecord(String nombre, int cantidad,int orden) async {
    // Crear un nuevo id único para el nuevo registro
    String? newRecordId = dbRef.push().key;

    // Definir el nuevo registro
    Map<String, dynamic> nuevoRegistro = {
      "nombre": nombre,
      "cantidad": cantidad,
      "orden": orden,
    };
    // Insertar el nuevo registro en la base de datos
    return dbRef.child(newRecordId!).set(nuevoRegistro);
  }

  /// Actualizar un registro en la base de datos
  Future updateRecord(String id, String nombre, int cantidad, int orden) async {
    // Definir el registro actualizado
    Map<String, dynamic> updatedRecord = {
      "nombre": nombre,
      "cantidad": cantidad,
      "orden": orden,
    };
    // Actualizar el registro en la base de datos
    return dbRef.child(id).update(updatedRecord);
  }
}
