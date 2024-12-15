import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;

  const LoadingButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
