import 'package:base_code_template_flutter/components/loading/icon_animation_view.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../paint/loading_paint.dart';
import 'loading_view_model.dart';

class ContainerWithLoading extends ConsumerWidget {
  const ContainerWithLoading({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loadingStateProvider);
    return Stack(
      children: [
        child,
        state.isLoading ? _buildLoading() : const SizedBox(),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: IgnorePointer(
        ignoring: true,
        child: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  IconAnimationView(
                    width: 50,
                    height: 50,
                    iconPainterBuilder: (time) => LoadingPaint(time),
                  ),
                  Text(
                    "Loading...",
                    style: AppTextStyles.titleMediumBold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
