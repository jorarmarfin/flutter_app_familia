import 'package:firebase_database/firebase_database.dart';

import '../models/gasto_model.dart';

class FirebaseGastos {
  final dbRef = FirebaseDatabase.instance.ref().child('gastos');

  Stream<List<GastoModel>> getGastosStream(String idPresupuesto) {
    return dbRef.onValue.map((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      final List<GastoModel> gastos = [];
      if (map != null) {
        map.forEach((key, value) {
          var gasto =
              GastoModel.fromMap(Map<dynamic, dynamic>.from(value), key);
          if (gasto.presupuestoId == idPresupuesto) {
            gastos.add(gasto);
          }
        });
      }
      //gastos.sort((a, b) => a.concepto.compareTo(b.concepto));
      return gastos;
    });
  }

  Future<void> eliminarGastoPorId(String id) async {
    await dbRef.child(id).remove();
  }

  double calcularTotalGasto(List<GastoModel> gastos) {
    return gastos.fold(0, (sum, item) => sum + item.monto);
  }

  Future createNewRecord(String concepto, double monto, String presupuestoId,String fecha) async {
    String? newRecordId = dbRef.push().key;
    Map<String, dynamic> nuevoRegistro = {
      "concepto": concepto,
      "monto": monto,
      "presupuestoId": presupuestoId,
      "fecha": fecha,
    };
    return dbRef.child(newRecordId!).set(nuevoRegistro);
  }

  Future<double> getSumByPresupuestoId(String presupuestoId) async {
    double total = 0.0;

    // Realiza la consulta para obtener todos los registros con el mismo presupuestoId
    Query query = dbRef.orderByChild('presupuestoId').equalTo(presupuestoId);

    // Ejecutar la consulta y calcular la suma de los montos
    DataSnapshot snapshot = await query.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        double monto = double.tryParse(value['monto'].toString()) ?? 0.0;
        total += monto;
      });
    }
    return total;
  }

}
