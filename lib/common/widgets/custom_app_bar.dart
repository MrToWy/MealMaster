import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton;
  final String title;

  const CustomAppBar(
      {super.key, this.hasBackButton = false, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      centerTitle: true,
      automaticallyImplyLeading: hasBackButton,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}