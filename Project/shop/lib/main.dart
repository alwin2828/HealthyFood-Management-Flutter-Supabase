
import 'package:flutter/material.dart';
import 'package:shop/screens/dashboard.dart';
import 'package:shop/screens/index.dart';
import 'package:shop/screens/login.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

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
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is already logged in
    final session = supabase.auth.currentSession;

    if (session != null) {
      // User is logged in, navigate to HomePage
      return Index();
    } else {
      // User is not logged in, navigate to LandingPage
      return Index();
    }
  }
}
