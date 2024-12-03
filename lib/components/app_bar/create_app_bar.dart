import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.onSaveIconTap,
      required this.onAnalyzeIconTap,
      required this.isCanSave});

  final String title;

  final Color? backgroundColor;

  final VoidCallback onSaveIconTap;

  final VoidCallback onAnalyzeIconTap;

  final bool isCanSave;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.titleLargeBold,
      ),
      actions: [
        if (isCanSave)
          Padding(
            padding: const EdgeInsets.all(4),
            child: OutlinedButton(
              onPressed: () {
                onSaveIconTap();
              },
              child: Text(AppLocalizations.of(context)?.save ?? "Save"),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: OutlinedButton(
            onPressed: () {
              onAnalyzeIconTap();
            },
            child: Text(AppLocalizations.of(context)?.analyze ?? "Analyze"),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
