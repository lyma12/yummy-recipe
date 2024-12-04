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
      required this.onScrapeDataTap,
      required this.isCanSave});

  final String title;

  final Color? backgroundColor;

  final VoidCallback onSaveIconTap;

  final VoidCallback onAnalyzeIconTap;
  final VoidCallback onScrapeDataTap;

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
            child: Tooltip(
              message: AppLocalizations.of(context)?.create ?? "Create",
              child: IconButton(
                onPressed: () {
                  onSaveIconTap();
                },
                icon: const Icon(Icons.upload_file),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message: AppLocalizations.of(context)?.analyze ?? "Analyze",
            child: IconButton(
              onPressed: () {
                onAnalyzeIconTap();
              },
              icon: const Icon(Icons.analytics_outlined),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message: AppLocalizations.of(context)?.scrape ?? "Scrape data",
            child: IconButton(
              onPressed: () {
                onScrapeDataTap();
              },
              icon: const Icon(Icons.web_sharp),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
