import 'package:base_code_template_flutter/components/dialog/base_dialog.dart';
import 'package:flutter/material.dart';

import '../../resources/app_text_styles.dart';
import '../../resources/gen/colors.gen.dart';
import '../../utilities/constants/text_constants.dart';

class ErrorDialog extends BaseDialog {
  const ErrorDialog({
    super.key,
    required super.title,
    super.onClosed,
  });

  @override
  Widget? buildContext(BuildContext context) {
    return Text(
      TextConstants.close,
      textAlign: TextAlign.center,
      style: AppTextStyles.s16w400.copyWith(
        color: ColorName.black,
      ),
    );
  }
}
