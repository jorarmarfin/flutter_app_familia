import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_familia/infrastructure/models/presupuesto_model.dart';
import 'package:flutter_app_familia/screens/components/components.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
class PresupuestoScreen extends StatelessWidget {
  static const routeName = 'presupuesto_screen';
  const PresupuestoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto', style:TextStyle(color: appWhiteColor),),
        centerTitle: true,
        backgroundColor: appRedColor,
        iconTheme: const IconThemeData(color: appWhiteColor),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
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
              Expanded(child: ListaPresupuestos()),
              const FooterMenu()
            ],
          ),
        ],
      )
    );
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
        if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
          Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<PresupuestoModel> presupuestos = [];
          map.forEach((key, value) {
            var presupuesto = PresupuestoModel.fromMap(Map<dynamic, dynamic>.from(value));
            presupuestos.add(presupuesto);
          });
          return ListView.builder(
            itemCount: presupuestos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                decoration: appBoxDecoration,
                child: ListTile(
                  title: Text(presupuestos[index].nombre),
                  subtitle: Text('Cantidad: ${presupuestos[index].cantidad}'),
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