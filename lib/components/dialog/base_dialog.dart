import 'package:flutter/material.dart';

import '../../resources/app_text_styles.dart';
import '../divider/divider_horizontal.dart';

abstract class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    required this.title,
    this.onClosed,
    this.height,
  });

  final String title;
  final VoidCallback? onClosed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  title,
                  style: AppTextStyles.s16w700,
                ),
              ),
              const DividerHorizontal(height: 1),
              GestureDetector(
                onTap: onClosed ??
                        () {
                      Navigator.of(context).pop();
                    },
                child: Container(
                  width: double.infinity,
                  height: height,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                    ),
                  ),
                  child: buildContext(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? buildContext(BuildContext context) => null;
}
