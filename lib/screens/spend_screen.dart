import 'package:flutter/material.dart';
import 'package:flutter_app_familia/infrastructure/models/gasto_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../infrastructure/datasource/firebase_gastos.dart';
import '../providers/type_spend_provider.dart';
import '../themes/app_theme.dart';
import 'components/components.dart';

class SpendScreen extends ConsumerWidget {
  static const routeName = 'spend_screen';
  const SpendScreen({super.key, required this.spendId});
  final String spendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameTypeSpend = ref.watch(nameCategorySpendProvider);
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
              const SizedBox(height: 10),
              Text(nameTypeSpend, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appWhiteColor)),
              const SizedBox(height: 10),
              Expanded(child: ListaGastos(idPresupuesto: spendId)),
              const FooterMenu()
            ],
          ),
        ],
      ),
    );
  }
  void showFormDialog(BuildContext context) {
    final TextEditingController conceptoController = TextEditingController();
    final TextEditingController montoController = TextEditingController();
    final TextEditingController fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insertar Gasto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: conceptoController,
                  decoration: const InputDecoration(hintText: 'Concepto'),
                ),
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Monto'),
                ),
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(hintText: 'Fecha'),
                  readOnly: true, // Hace el campo de texto de solo lectura
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      // Formatea la fecha seleccionada y actualiza el controlador
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      fechaController.text = formattedDate;
                    }
                  },
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
                String concepto = conceptoController.text;
                double monto = double.tryParse(montoController.text) ?? 0.0;
                String fecha = fechaController.text;
                // Llamar a la función para crear un nuevo registro
                insertarGasto(concepto.toUpperCase(), monto, spendId,fecha , context);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
  void insertarGasto(String concepto, double monto,String presupuestoId,String fecha  , context) {
    final dbRef = FirebaseGastos();
    dbRef.createNewRecord(concepto, monto, presupuestoId,fecha  ).then((_) {
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

class ListaGastos extends StatelessWidget {
  final FirebaseGastos dbRef = FirebaseGastos();
  final String idPresupuesto; // Asumiendo que tienes esta variable

  ListaGastos({super.key, required this.idPresupuesto});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbRef.getGastosStream(idPresupuesto),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<GastoModel> gastos = snapshot.data!;
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
                    subtitle: Text('Costo: ${gastos[index].monto}'),
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
                        dbRef.eliminarGastoPorId( gastos[index].id );
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
