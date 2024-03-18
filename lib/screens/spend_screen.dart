import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_familia/infrastructure/models/gasto_model.dart';
import 'package:go_router/go_router.dart';

import '../themes/app_theme.dart';
import 'components/components.dart';

class SpendScreen extends StatelessWidget {
  static const routeName = 'spend_screen';
  const SpendScreen({super.key, required this.spendId});
  final String spendId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Gastos', style:TextStyle(color: appWhiteColor),),
        centerTitle: true,
        backgroundColor: appRedColor,
        iconTheme: const IconThemeData(color: appWhiteColor),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            showFormDialog(context);
          },
          backgroundColor: appWhiteColor,
          child: const Icon(Icons.add),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundScreen(),
          Column(
            children: [
              const SizedBox(height: 40),
              Expanded(child: ListaGastos(idPresupuesto: spendId)),
              const FooterMenu()
            ],
          ),
        ],
      ),
    );
  }
  void showFormDialog(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController cantidadController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Formulario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(hintText: 'Nombre'),
                ),
                TextFormField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Cantidad'),
                ),
                // Agrega más campos de formulario según necesites
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () {
                // Obtener los valores de los controladores de texto
                String nombre = nombreController.text;
                int cantidad = int.tryParse(cantidadController.text) ?? 0;
                // Llamar a la función para crear un nuevo registro
                createNewRecord(nombre.toUpperCase(), cantidad);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
  void createNewRecord(String nombre, int cantidad) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref("presupuesto");

    // Crear un nuevo id único para el nuevo registro
    String? newRecordId = ref.push().key;

    // Definir el nuevo registro
    Map<String, dynamic> nuevoRegistro = {
      "nombre": nombre,
      "cantidad": cantidad,
    };
    // Insertar el nuevo registro en la base de datos
    ref.child(newRecordId!).set(nuevoRegistro).then((_) {
      const SnackBar(
        content: Text('A SnackBar has been shown.'),
      );
    }).catchError((error) {
      SnackBar(
        content: Text("Ha ocurrido un error: $error"),
      );
    });
  }
}

class ListaGastos extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.ref().child('gastos');
  final String idPresupuesto; // Asumiendo que tienes esta variable

  ListaGastos({super.key, required this.idPresupuesto});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
          Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<GastoModel> gastos = [];
          map.forEach((key, value) {
            var gasto = GastoModel.fromMap(Map<dynamic, dynamic>.from(value), key);
            if (gasto.presupuestoId == idPresupuesto) { // Filtra por idPresupuesto
              gastos.add(gasto);
            }
          });
          gastos.sort((a, b) => a.concepto.compareTo(b.concepto));
          return ListView.builder(
            itemCount: gastos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  // Asegúrate de tener definido appBoxDecoration o cámbialo por tu estilo
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset:const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                    title: Text(gastos[index].concepto),
                    subtitle: Text('Cantidad: ${gastos[index].monto}'),
                    trailing: IconButton(
                      icon: const CircleAvatar(
                        // Asegúrate de tener definidos appRedColor y appWhiteColor o cámbialos por tus colores
                          backgroundColor: Colors.red,
                          radius: 20,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                      onPressed: () {
                        dbRef.child(gastos[index].id).remove();
                      },
                    )
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
