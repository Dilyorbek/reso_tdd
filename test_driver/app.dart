import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:reso_tdd/injection_container.dart' as di;
import 'package:reso_tdd/main.dart';

void main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(MyApp());
}