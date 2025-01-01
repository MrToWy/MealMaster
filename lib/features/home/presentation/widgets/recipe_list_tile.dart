import 'package:flutter/material.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:provider/provider.dart';

import '../../../recipes/presentation/recipe_screen.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  final int index;

  const RecipeListTile({super.key, required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isEditMode = context.watch<EditModeProvider>().inEditMode;
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: ListTile(
          key: ValueKey(recipe.id),
          title: Text(
            'Recipe ${recipe.title}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface,
                fontSize: 22),
          ),
          subtitle: Row(
            children: [
              Text(
                '${recipe.cookingDuration} min  -  ',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              //DifficultyIndicator(difficulty: recipe.difficulty!)
            ],
          ),
          trailing: isEditMode
              ? ReorderableDragStartListener(
                  index: index,
                  child: Icon(Icons.drag_handle,
                      color: theme.colorScheme.onSurface, size: 30),
                )
              : IconButton(
                  icon: const Icon(Icons.assignment),
                  iconSize: 30,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeScreen(id: 16))),
                ),
        ),
      ),
    );
  }
}
