import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worker/dashboard.dart';
import 'package:worker/login.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://zlfsyrmwvswgyflbiwdi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsZnN5cm13dnN3Z3lmbGJpd2RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcxNzY2NjAsImV4cCI6MjA1Mjc1MjY2MH0.oFauxdHnZ9XDdZbMLAybi71z0uGKOsvaYoddwIcHojU',
  );
  runApp(MainApp());
}
  final supabase = Supabase.instance.client;



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
