import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        automaticallyImplyLeading: hasBackButton,
      ),
      body: child,
    );
  }
}
