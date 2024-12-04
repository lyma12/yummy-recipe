import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../resources/app_text_styles.dart';
import '../models/main_tab.dart';

class TabItem extends ConsumerWidget {
  const TabItem({
    required this.mainTab,
    required this.isActive,
    required this.onTap,
    required this.height,
    super.key,
  });

  final MainTab mainTab;
  final bool isActive;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isActive ? width / 3 : width / 6,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isActive
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        mainTab.activeIconPath(context),
                        if (isActive)
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isActive ? 1.0 : 0.6,
                              child: Text(
                                mainTab.getLabel(context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.bottomBarItemOn
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : mainTab.iconPath(context),
            if (isActive)
              SizedBox(
                height: height / 10,
              ),
          ],
        ),
      ),
    );
  }
}
