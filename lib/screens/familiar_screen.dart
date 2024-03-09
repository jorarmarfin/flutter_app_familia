import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'components/components.dart';

class FamiliarScreen extends StatelessWidget {
  static const routeName = 'familiar_screen';
  FamiliarScreen({super.key, required this.familyId});
  final String familyId;
  static String nroCuenta1 = '''Número de Cuenta BCP
    Nro cuenta: 191-19101948-0-96
    CI: 00219111910194809657
    ''';
  static String nroCuenta2 = '''Número de Cuenta BN
    Nro cuenta: 4214100324324732
    CI: 04-082-460751
    ''';
  final List<Map<String, String>> familiar = [
    {
      'nombre': 'Luis',
      'dn1': 'dni_luis_1.jpg',
      'dn2': 'dni_luis_2.jpg',
      'cuenta': nroCuenta1,
      'phone': '+51992949424'
    },
    {
      'nombre': 'Lucy',
      'dn1': 'dni_lucy_1.jpg',
      'dn2': 'dni_lucy_2.jpg',
      'cuenta': nroCuenta2,
      'phone': '+51987190604'
      },
    {
      'nombre': 'Francisco',
      'dn1': 'dni_f_1.jpg',
      'dn2': 'dni_f_2.jpg',
      'cuenta': ' ',
      'phone': '+51987190604'
    },
  ];

  @override
  Widget build(BuildContext context) {
    int? id = int.tryParse(familyId) ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(familiar[id]['nombre']!, style:const TextStyle(color: appWhiteColor),),
        centerTitle: true,
        backgroundColor: appRedColor,
        iconTheme: const IconThemeData(color: appWhiteColor),
      ),
        body: Stack(
      children: [
        const BackgroundScreen(),
        Column(
          children: [
            const SizedBox(height: 40),
            FamilyContent(
              imageDni1: familiar[id]['dn1']!,
              imageDni2: familiar[id]['dn2']!,
              nroCuenta: familiar[id]['cuenta']!,
              nroTelefono: familiar[id]['phone']!,
            ),
            const FooterMenu()
          ],
        ),
      ],
    ));
  }
}

class FamilyContent extends StatelessWidget {
  const FamilyContent({
    super.key,
    required this.imageDni1,
    required this.imageDni2,
    required this.nroCuenta,
    required this.nroTelefono,
  });
  final String imageDni1;
  final String imageDni2;
  final String nroCuenta;
  final String nroTelefono;
  final snackBar =const SnackBar(
    content: Text('El texto ya se copió'),
    duration: Duration(seconds: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          FamilyDni(
            familyImage: imageDni1,
          ),
          const SizedBox(height: 20),
          FamilyDni(familyImage: imageDni2),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            padding: const EdgeInsets.all(20),
            decoration: appBoxDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Numero de cuenta del Banco',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(nroCuenta, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: nroCuenta));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Copiar el Texto'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}

class FamilyDni extends StatelessWidget {
  const FamilyDni({
    super.key,
    required this.familyImage,
  });
  final String familyImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: appBoxDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 4,
            panEnabled: false,
            child: Image.asset('assets/images/$familyImage',fit: BoxFit.fill,)),
      ),
    );
  }
}
