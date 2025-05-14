import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true
    ),
  );
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
  ));
}
