import 'package:flutter/material.dart';

class DateListTile extends StatelessWidget {
  final DateTime day;
  final int index;

  const DateListTile({super.key, required this.day, required this.index});

  @override
  Widget build(BuildContext context) {
    final dayAbbreviations = {
      1: 'MO.', // Monday
      2: 'DI.', // Tuesday
      3: 'MI.', // Wednesday
      4: 'DO.', // Thursday
      5: 'FR.', // Friday
      6: 'SA.', // Saturday
      7: 'SO.', // Sunday
    };

    String dayAbbreviation = dayAbbreviations[day.weekday] ?? 'Unknown';
    return ListTile(
      key: ValueKey(day),
      title: Text(
        dayAbbreviation,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
