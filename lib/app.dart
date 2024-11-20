import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:mealmaster/shared/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meal Master',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(scheme: FlexScheme.materialHc),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.materialHc),
      routerConfig: router,
    );
  }
}
