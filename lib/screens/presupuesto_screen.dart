import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app_familia/infrastructure/datasource/firebase_gastos.dart';
import 'package:flutter_app_familia/infrastructure/models/presupuesto_model.dart';
import 'package:flutter_app_familia/screens/components/components.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../infrastructure/datasource/firebase_presupuesto.dart';
import '../providers/budgetListProvider.dart';
import '../providers/family_provider.dart';
import '../providers/type_spend_provider.dart';

class PresupuestoScreen extends ConsumerWidget {
  static const routeName = 'presupuesto_screen';
  const PresupuestoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presupuestosAsyncValue = ref.watch(presupuestoStreamProvider);
    final dbRef = FirebasePresupuesto();
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
                        final total =
                            dbRef.calcularTotalPresupuesto(presupuestos);
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
    final TextEditingController ordenController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Presupuesto'),
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
                TextFormField(
                  controller: ordenController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Orden'),
                )
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
                int orden = int.tryParse(ordenController.text) ?? 0;
                // Llamar a la función para crear un nuevo registro
                insertarPresupuesto(
                    nombre.toUpperCase(), cantidad, orden, context);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertarPresupuesto(String nombre, int cantidad, int orden, context) {
    final dbRef = FirebasePresupuesto();
    dbRef.createNewRecord(nombre, cantidad, orden).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro creado con éxito.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ha ocurrido un error: $error")),
      );
    });
  }
}

class ListaPresupuestos extends ConsumerWidget {
  final FirebasePresupuesto dbRef = FirebasePresupuesto();

  ListaPresupuestos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(nameCategorySpendProvider);
    final itemList = ref.watch(itemListProvider);
    return StreamBuilder<List<PresupuestoModel>>(
      stream: dbRef.getPresupuestosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PresupuestoModel> presupuestos = snapshot.data!;
          presupuestos.sort((a, b) => (a.orden ?? 0).compareTo(b.orden ?? 0));
          return ListView.builder(
            itemCount: presupuestos.length,
            itemBuilder: (context, index) {
              double total = presupuestos[index].cantidad.toDouble();
              return Dismissible(
                key: Key(presupuestos[index].id),
                background: Container(
                  padding: const EdgeInsets.only(left: 20),
                  color: appBlueColor,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.edit,
                    color: appWhiteColor,
                  ),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.only(right: 20),
                  color: appRedColor,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: appWhiteColor),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    showUpdateFormDialog(context, presupuestos[index]);
                  } else {
                    dbRef.eliminarPresupuestoPorId(presupuestos[index].id);
                  }
                },
                child: buildContainer(presupuestos, index, total, context, ref),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container buildContainer(List<PresupuestoModel> presupuestos, int index,
      double total, BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: appBoxDecoration,
      child: ListTile(
          contentPadding: const EdgeInsets.all(2),
          title: Text(
            '${presupuestos[index].orden} - ${presupuestos[index].nombre}',
            style: const TextStyle(fontSize: 15),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cantidad: ${presupuestos[index].cantidad}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Saldo: ${presupuestos[index].saldo}',
                style: const TextStyle(fontSize: 12),
              ),

            ],
          ),
          leading: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            onPressed: () {
              context.pushNamed('spend_screen',
                  pathParameters: {'id': presupuestos[index].id});
              ref.read(nameCategorySpendProvider.notifier).state =
                  presupuestos[index].nombre;
            },
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Editar') {
                showUpdateFormDialog(context, presupuestos[index]);
              } else {
                dbRef.eliminarPresupuestoPorId(presupuestos[index].id);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Editar',
                child: Text('Editar'),
              ),
              const PopupMenuItem<String>(
                value: 'Eliminar',
                child: Text('Eliminar'),
              ),
            ],
          )),
    );
  }

  void showUpdateFormDialog(
      BuildContext context, PresupuestoModel presupuesto) {
    // Inicializar los controladores con los valores actuales
    final TextEditingController nombreController =
        TextEditingController(text: presupuesto.nombre);
    final TextEditingController cantidadController =
        TextEditingController(text: presupuesto.cantidad.toString());
    final TextEditingController ordenController =
        TextEditingController(text: presupuesto.orden.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualizar Presupuesto'),
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
                TextFormField(
                  controller: ordenController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Orden'),
                )
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
              child: const Text('Actualizar'),
              onPressed: () {
                // Obtener los valores actualizados de los controladores
                String nombre = nombreController.text;
                int cantidad = int.tryParse(cantidadController.text) ?? 0;
                int orden = int.tryParse(ordenController.text) ?? 0;

                // Llamar a la función para actualizar el registro
                actualizarPresupuesto(context, presupuesto.id,
                    nombre.toUpperCase(), cantidad, orden);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void actualizarPresupuesto(
      BuildContext context, String id, String nombre, int cantidad, int orden) {
    final dbRef = FirebasePresupuesto();
    dbRef.updateRecord(id, nombre, cantidad, orden).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado con éxito.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ha ocurrido un error: $error")),
      );
    });
  }
}

