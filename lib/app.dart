import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:mealmaster/features/dashboard/presentation/dashboard_screen.dart';
import 'package:mealmaster/shared/app_router.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meal Master',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      routerConfig: router,
    );
  }
}
