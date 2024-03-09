import 'package:flutter/material.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';

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
