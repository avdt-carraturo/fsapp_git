import 'package:flutter/material.dart';

class ConfirmButtons extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmButtons({
    super.key,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: const Text("Annulla"),
          onPressed: onCancel ?? () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          child: const Text("Conferma"),
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
