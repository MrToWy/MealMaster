import 'package:go_router/go_router.dart';
import 'package:mealmaster/features/dashboard/presentation/dashboard_screen.dart';
import 'package:mealmaster/features/meal_plan/presentation/new_plan_screen.dart';
import 'package:mealmaster/features/recipes/presentation/recipe_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/splash_screen/splash_screen.dart';
import 'package:mealmaster/features/user_profile/presentation/profile_screen.dart';

import '../db/db-test.dart';

final GoRouter router = GoRouter(
  initialLocation: '/db',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/shopping-list',
      name: 'shoppingList',
      builder: (context, state) => ShoppingListScreen(),
    ),
    GoRoute(
      path: '/new-plan',
      name: 'newPlan',
      builder: (context, state) => NewPlanScreen(),
    ),
    GoRoute(
      path: '/recipe',
      name: 'recipe',
      builder: (context, state) => RecipeScreen(),
    ),
    GoRoute(
      path: '/db',
      name: 'db',
      builder: (context, state) => DbTestScreen(),
    ),
  ],
);
