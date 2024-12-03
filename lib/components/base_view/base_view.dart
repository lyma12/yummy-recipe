import 'dart:convert';
import 'package:base_code_template_flutter/components/dialog/error_dialog.dart';
import 'package:base_code_template_flutter/utilities/exceptions/spoonacular_exception.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../data/models/api/responses/base_response_error/base_response_error.dart';
import '../dialog/dialog_provider.dart';
import 'base_view_mixin.dart';
import 'base_view_model.dart';

abstract class BaseView extends ConsumerStatefulWidget {
  const BaseView({
    super.key,
  });
}

abstract class BaseViewState<View extends BaseView,
        ViewModel extends BaseViewModel> extends ConsumerState<View>
    with BaseViewMixin {
  ViewModel get viewModel;

  final logger = Logger();

  @mustCallSuper
  void onInitState() {
    logger.d('Init State: $runtimeType');
  }

  @mustCallSuper
  void onDispose() {
    logger.d('Dispose: $runtimeType');
  }

  @override
  void initState() {
    onInitState();
    super.initState();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView(context);

  void nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> handleError(
    Object error, {
    void Function()? onButtonTapped,
  }) async {
    String? errorMessage;

    if (error is DioException) {
      final response = error.response;

      if (response != null) {
        try {
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'];
          } else {
            final errorJson = jsonDecode(response.data);
            errorMessage = BaseResponseError.fromJson(errorJson).message;
          }
        } catch (_) {
          errorMessage = error.response?.statusMessage;
        }
      } else if (error.type == DioExceptionType.connectionError) {
        errorMessage = error.message;
      }
    }
    if (error is SpoonacularException) {
      errorMessage = error.message;
    }

    if (error is FirebaseAuthException) {
      errorMessage = error.message;
    }

    if (errorMessage != null) {
      await ref.read(alertDialogProvider).showAlertDialog(
            context: context,
            dialog: ErrorDialog(
              title: errorMessage,
              onClosed: onButtonTapped,
            ),
          );
    }
  }
}
