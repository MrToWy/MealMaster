import 'package:flutter/material.dart';

class DateListTile extends StatelessWidget {
  final String day;
  final int index;

  const DateListTile({super.key, required this.day, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(day),
      title: Text(
        day,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 30,
        ),
      ),
    );
  }
}
