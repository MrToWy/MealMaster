import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../meal_plan/data/meal_plan_repository.dart';
import '../../user_profile/data/user_repository.dart';
import 'controller/edit_mode_controller.dart';
import 'widgets/meal_plan_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showConfirmDialog = false;
  String user = '';

  @override
  initState() {
    super.initState();
    checkIfMealPlanExists();
    getUser();
  }

  void checkIfMealPlanExists() async {
    bool hasMealPlan = await MealPlanRepository().checkIfMealPlanExists();

    setState(() {
      showConfirmDialog = hasMealPlan;
    });
  }

  getUser() async {
    final userName = await UserRepository().getUserName();
    setState(() {
      user = userName;
    });
  }

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
                if (showConfirmDialog) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Möchtest du einen neuen Plan erstellen?'),
                        content: Text(
                            'Durch das Erstellen eines neuen Plans wird der aktuelle Plan und alle damit verbundenen Daten gelöscht Möchtest du fortfahren?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dialog schließen
                            },
                            child: Text('Abbrechen'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dialog schließen
                              Navigator.pushNamed(context,
                                  '/new-plan'); // Navigation durchführen
                            },
                            child: Text('Ja'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pushNamed(context, '/new-plan');
                }
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
