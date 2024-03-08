import 'package:flutter/material.dart';
import 'package:flutter_app_familia/screens/components/background_screen.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              OptionsList(),
              Container(
                alignment: Alignment.center,
                height: 60,
                decoration: appBoxDecoration,
                child: Row(
                  children: [
                    IconButton(onPressed: () {
                    }, icon: Icon(Icons.home)),
                    IconButton(onPressed: () {
                    }, icon: Icon(Icons.home)),
                    IconButton(onPressed: () {
                    }, icon: Icon(Icons.home)),
                  ],
                ),
              )
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
      OptionMenu(),
      OptionMenu(),
      OptionMenu(),
    ]));
  }
}

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: appWhiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.5), // Color de la sombra
                spreadRadius: 1, // Radio de expansión de la sombra
                blurRadius: 6, // Desenfoque de la sombra
                offset: const Offset(
                    0, 3), // Cambios de posición de la sombra
              ),
            ]),
        child: ListTile(
            leading: const Icon(Icons.person, color: appBlackColor),
            title: const Text('Presupuesto'),
            trailing: const Icon(Icons.arrow_forward_ios, color: appBlackColor),
            onTap: () {
              context.pushNamed('/budget');
            }
        )
    );
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
          FamiliarContainer(),
          SizedBox(width: 20),
          FamiliarContainer(),
          SizedBox(width: 20),
          FamiliarContainer(),
        ],
      ),
    );
  }
}

class FamiliarContainer extends StatelessWidget {
  const FamiliarContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 190,
      decoration: appBoxDecoration,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/images/img_tmp.jpg', width: 100, height: 100),
        const SizedBox(height: 10),
        const Text(
          'Luis Mayta',
          style: TextStyle(
            color: appBlackColor,
            fontSize: 20,
          ),
        ),
      ]),
    );
  }
}

class TitleApp extends StatelessWidget {
  final String titleName;
  const TitleApp({
    super.key,
    required this.titleName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        titleName,
        style: const TextStyle(
          color: appWhiteColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
