import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/controller/shopping_list_provider.dart';
import 'package:provider/provider.dart';

import 'common/widgets/navigation_menu.dart';
import 'features/home/presentation/controller/edit_mode_controller.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/meal_plan/presentation/controller/meal_plan_provider.dart';
import 'features/meal_plan/presentation/new_plan_screen.dart';
import 'features/shopping_list/presentation/shopping_list_screen.dart';
import 'features/splash_screen/splash_screen.dart';
import 'features/user_profile/presentation/profile_screen.dart';
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
        ChangeNotifierProvider<MealPlanProvider>(
          create: (_) => MealPlanProvider(),
        ),
        ChangeNotifierProvider<ShoppingListProvider>(
            create: (_) => ShoppingListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meal Master',
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: '/splash',
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
