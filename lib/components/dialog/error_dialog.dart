import 'package:base_code_template_flutter/components/loading/icon_animation_view.dart';
import 'package:base_code_template_flutter/components/paint/error_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../resources/app_text_styles.dart';
import '../../resources/gen/colors.gen.dart';
import '../../utilities/constants/text_constants.dart';
import '../divider/divider_horizontal.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    this.onClosed,
    required this.title,
  });

  final String title;

  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            11,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: IconAnimationView(
                    iconPainterBuilder: (time) => ErrorPainter(time),
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                AppLocalizations.of(context)?.opps ?? "OOPS",
                style: AppTextStyles.s16w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: AppTextStyles.s14w400,
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  ),
                ),
                child: Text(
                  TextConstants.close,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s16w400.copyWith(
                    color: ColorName.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //onWillPop: () async => true,
    );
  }
}
