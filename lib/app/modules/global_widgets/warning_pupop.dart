import 'package:flutter/material.dart';

class WarningDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Annuler",
                  style: const TextStyle(color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onConfirm != null) onConfirm();
                },
                child: Text(
                  confirmText,
                  style: const TextStyle(color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}