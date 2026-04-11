import 'package:flutter/material.dart';
import '../../core/utils/app_localizations_ext.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  bool isDangerous = true,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: isDangerous
              ? TextButton.styleFrom(foregroundColor: Colors.red)
              : null,
          child: Text(confirmLabel ?? l10n.deleteConfirmButton),
        ),
      ],
    ),
  );
  return result ?? false;
}
