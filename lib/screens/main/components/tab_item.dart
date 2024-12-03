import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../resources/app_text_styles.dart';
import '../models/main_tab.dart';

class TabItem extends ConsumerWidget {
  const TabItem({
    required this.mainTab,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final MainTab mainTab;

  final bool isActive;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            isActive
                ? mainTab.activeIconPath(context)
                : mainTab.iconPath(context),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                mainTab.getLabel(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: isActive
                    ? AppTextStyles.bottomBarItemOn
                        .copyWith(color: Theme.of(context).colorScheme.primary)
                    : AppTextStyles.bottomBarItem.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
