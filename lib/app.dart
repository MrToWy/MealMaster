import 'package:flutter/material.dart';
import 'package:mealmaster/common/widgets/navigation_menu.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:mealmaster/features/home/presentation/home_screen.dart';
import 'package:mealmaster/features/meal_plan/presentation/new_plan_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/splash_screen/splash_screen.dart';
import 'package:mealmaster/features/user_profile/presentation/profile_screen.dart';
import 'package:provider/provider.dart';

import 'shared/theme.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meal Master',
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: '/navigation',
        routes: {
          '/navigation': (context) => NavigationMenu(),
          '/splash': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
          '/shopping-list': (context) => ShoppingListScreen(),
          '/new-plan': (context) => NewPlanScreen(),
        },
      ),
    );
  }
}
