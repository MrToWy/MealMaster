import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
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
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/new-plan');
          },
          child: Text(
            'Neuer Plan',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
