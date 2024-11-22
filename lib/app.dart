import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:mealmaster/shared/app_router.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditModeProvider>(
          create: (_) => EditModeProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Meal Master',
        themeMode: ThemeMode.system,
        theme: FlexThemeData.light(scheme: FlexScheme.materialHc),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.materialHc),
        routerConfig: router,
      ),
    );
  }
}
