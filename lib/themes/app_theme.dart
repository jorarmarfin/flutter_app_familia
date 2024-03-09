import 'package:flutter/material.dart';

const Color appWhiteColor = Color(0xFFFFFFFF);
const Color appRedColor = Color(0xFFC6302C);
const Color appBlackColor = Color(0xFF000000);

class AppTheme {
  AppTheme();
  ThemeData getTheme() =>
      ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFC6302C));
}

final BoxDecoration appBoxDecoration = BoxDecoration(
  color: appWhiteColor,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: appRedColor,
    width: 1,
  ),
);

final BoxDecoration appBoxDecorationWhitShadow = BoxDecoration(
    color: appWhiteColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Color de la sombra
        spreadRadius: 1, // Radio de expansión de la sombra
        blurRadius: 6, // Desenfoque de la sombra
        offset: const Offset(0, 3), // Cambios de posición de la sombra
      ),
    ]);
