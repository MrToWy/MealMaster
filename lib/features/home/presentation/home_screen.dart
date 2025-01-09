import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/widgets/meal_plan_list.dart';
import 'package:provider/provider.dart';

import 'controller/edit_mode_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String user = 'Max';

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          centerTitle: true,
          title: Text(
            'Hallo $user!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              final currentMode = context.read<EditModeProvider>().inEditMode;
              context.read<EditModeProvider>().setEditMode(!currentMode);
            },
            child: Text(
              context.watch<EditModeProvider>().inEditMode
                  ? 'Fertig'
                  : 'Bearbeiten',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new-plan');
              },
              child: Text(
                'Neuer Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: MealPlanList(),
        ),
      ],
    );
  }
}
