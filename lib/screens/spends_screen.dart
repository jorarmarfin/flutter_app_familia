import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'components/components.dart';
class SpendsScreen extends StatelessWidget {
  static const routeName = 'spends_screen';
  const SpendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos', style:TextStyle(color: appWhiteColor),),
        centerTitle: true,
        backgroundColor: appRedColor,
        iconTheme: const IconThemeData(color: appWhiteColor),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            //showFormDialog(context);
          },
          backgroundColor: appWhiteColor,
          child: const Icon(Icons.add),
        ),
      ),
      body: const Stack(
        children: [
          BackgroundScreen(),
          Column(
            children: [
              SizedBox(height: 40),
              //Expanded(child: ListaGastos()),
              FooterMenu()
            ],
          ),
        ],
      )
    );
  }
}
