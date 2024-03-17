import 'package:flutter/material.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:go_router/go_router.dart';

class FooterMenu extends StatelessWidget {
  const FooterMenu({
    super.key,
  });
  final double buttonSize = 45.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      decoration: appBoxDecorationWhitShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              iconSize: buttonSize,
              onPressed: () => context.goNamed('home_screen'),
              icon: const Icon(Icons.home)),
          IconButton(
              iconSize: buttonSize,
              onPressed: () => context.goNamed('presupuesto_screen'),
              icon: const Icon(Icons.monetization_on_outlined)),
          IconButton(
              iconSize: buttonSize,
              onPressed: () {},
              icon: const Icon(Icons.add_shopping_cart)),
        ],
      ),
    );
  }
}
