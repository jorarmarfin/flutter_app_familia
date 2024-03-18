import 'package:flutter/material.dart';
import 'package:flutter_app_familia/infrastructure/models/presupuesto_model.dart';
import 'package:flutter_app_familia/screens/components/components.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/family_provider.dart';

class PresupuestoScreen extends ConsumerWidget {
  static const routeName = 'presupuesto_screen';
  const PresupuestoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presupuestosAsyncValue = ref.watch(presupuestoStreamProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Presupuesto',
            style: TextStyle(color: appWhiteColor),
          ),
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
                Expanded(child: ListaPresupuestos()),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: appBoxDecoration,
                    child: presupuestosAsyncValue.when(
                      data: (List<PresupuestoModel> presupuestos) {
                        final total = presupuestos.fold(
                            0, (sum, item) => sum + item.cantidad);
                        return Text(
                          'Total de presupuesto: S/.${total.toString()}',
                          style: const TextStyle(
                              color:
                                  appRedColor), // Asumiendo que appWhiteColor es un color definido previamente
                        );
                      },
                      loading: () => const Text('Calculando...'),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                  ),
                ),
                const FooterMenu()
              ],
            ),
          ],
        ));
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
                Navigator.of(context).pop();
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

  int calcularTotalPresupuesto(List<PresupuestoModel> presupuestos) {
    final dbRef = FirebaseDatabase.instance.ref().child('presupuesto');
    return presupuestos.fold(0, (sum, item) => sum + item.cantidad);
  }
}

class ListaPresupuestos extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.ref().child('presupuesto');

  ListaPresupuestos({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          Map<dynamic, dynamic> map =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<PresupuestoModel> presupuestos = [];
          map.forEach((key, value) {
            var presupuesto = PresupuestoModel.fromMap(
                Map<dynamic, dynamic>.from(value), key);
            presupuestos.add(presupuesto);
          });
          presupuestos.sort((a, b) => a.nombre.compareTo(b.nombre));
          return ListView.builder(
            itemCount: presupuestos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: appBoxDecoration,
                child: ListTile(
                    title: Text(presupuestos[index].nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${presupuestos[index].cantidad}'),
                        Text('Queda: ${presupuestos[index].cantidad}'),
                      ],
                    ),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: appRedColor,
                        size: 40,
                      ),
                      onPressed: () {
                        context.pushNamed('spend_screen',
                            pathParameters: {'id': presupuestos[index].id});
                      },
                    ),
                    trailing: IconButton(
                      icon: const CircleAvatar(
                          backgroundColor: appRedColor,
                          radius: 20,
                          child: Icon(
                            Icons.delete,
                            color: appWhiteColor,
                          )),
                      onPressed: () {
                        dbRef.child(presupuestos[index].id).remove();
                      },
                    )),
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
