import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hasBackButton;
  final List<Widget>? actions;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.title,
    this.hasBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        hasBackButton: hasBackButton,
      ),
      body: SafeArea(child: child),
    );
  }
}
