import 'dart:math';

import 'package:flutter/material.dart';
import 'package:m_user/dashboard.dart';
import 'package:m_user/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://zlfsyrmwvswgyflbiwdi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsZnN5cm13dnN3Z3lmbGJpd2RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcxNzY2NjAsImV4cCI6MjA1Mjc1MjY2MH0.oFauxdHnZ9XDdZbMLAybi71z0uGKOsvaYoddwIcHojU',
  );

  runApp(MainApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: Login());
  }
}
