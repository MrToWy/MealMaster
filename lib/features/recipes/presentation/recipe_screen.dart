import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Rezept ${widget.id}",
      hasBackButton: true,
      child: Text('Rezept'),
    );
  }
}
