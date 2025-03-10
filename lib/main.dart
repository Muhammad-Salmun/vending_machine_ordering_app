import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vending_machine_ordering_app/firebase_options.dart';
import 'package:vending_machine_ordering_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
