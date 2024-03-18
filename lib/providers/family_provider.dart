import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/models/presupuesto_model.dart';

final presupuestoStreamProvider = StreamProvider.autoDispose<List<PresupuestoModel>>((ref) {
  return FirebaseDatabase.instance.ref('presupuesto').onValue.map((event) {
    final presupuestosRaw = Map<String, dynamic>.from(event.snapshot.value as Map);
    return presupuestosRaw.entries.map((e) {
      return PresupuestoModel.fromMap(Map<String, dynamic>.from(e.value), e.key);
    }).toList();
  });
});