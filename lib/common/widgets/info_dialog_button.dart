import 'package:flutter/material.dart';

class InfoDialogButton extends StatelessWidget {
  final String infoText;
  final String title;

  const InfoDialogButton({
    super.key,
    required this.infoText,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Text(
                  infoText,
                  style: textTheme.bodyLarge,
                  softWrap: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dialog schließen
                    },
                    child: Text("Schließen"),
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.info_outline));
  }
}
