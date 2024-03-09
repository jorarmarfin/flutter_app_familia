import 'package:flutter/material.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:go_router/go_router.dart';

import 'components/components.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(),
          Column(
            children: [
              SizedBox(height: 50),
              TitleApp(
                titleName: 'App Familia',
              ),
              SizedBox(height: 40),
              FamilyList(),
              SizedBox(height: 40),
              Expanded(child: OptionsList()),
              FooterMenu()
            ],
          ),
        ],
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  const OptionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(children: const [
      OptionMenu(
          nameMenu: 'Gastos',
          routeMenu: 'spends_screen',
          iconMenu: Icons.add_shopping_cart),
      OptionMenu(
          nameMenu: 'Presupuesto',
          routeMenu: 'presupuesto_screen',
          iconMenu: Icons.monetization_on),
    ]));
  }
}

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
    required this.nameMenu,
    required this.routeMenu,
    required this.iconMenu,
  });
  final String nameMenu;
  final String routeMenu;
  final IconData iconMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: appBoxDecorationWhitShadow,
        child: ListTile(
            leading: Icon(
              iconMenu,
              color: appBlackColor,
              size: 40,
            ),
            title: Text(nameMenu),
            trailing: const Icon(Icons.arrow_forward_ios, color: appBlackColor),
            onTap: () {
              context.pushNamed(routeMenu);
            }));
  }
}

class FamilyList extends StatelessWidget {
  const FamilyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SizedBox(width: 20),
          FamiliarContainer(
            id: '0',nameFamily: 'Luis',imageFamily: 'luis.jpg',
          ),
          SizedBox(width: 20),
          FamiliarContainer(
            id: '1',nameFamily: 'Lucy ',imageFamily: 'lucy.jpg'
          ),
          SizedBox(width: 20),
          FamiliarContainer(
            id: '2',nameFamily: 'Francisco',imageFamily: 'francisco.jpg'
          ),
        ],
      ),
    );
  }
}

class FamiliarContainer extends StatelessWidget {
  const FamiliarContainer({
    super.key,
    required this.id, required this.nameFamily, required this.imageFamily,
  });
  final String id;
  final String nameFamily;
  final String imageFamily;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed('familiar_screen', pathParameters: {'id': id});
      },
      child: Container(
        width: 170,
        height: 190,
        decoration: appBoxDecoration,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/$imageFamily', width: 100, height: 100),
          const SizedBox(height: 10),
          Text(
            nameFamily,
            style:const TextStyle(
              color: appBlackColor,
              fontSize: 20,
            ),
          ),
        ]),
      ),
    );
  }
}
