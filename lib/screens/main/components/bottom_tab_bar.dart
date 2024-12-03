import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/paint/bnb_custom_paint.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:flutter/material.dart';

import '../models/main_tab.dart';
import 'tab_item.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    required this.tabsRouter,
    super.key,
  });

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height < 400 ? size.height / 8 : size.height / 10;
    return Container(
        height: height,
        color: ColorName.orange12EE6723,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPaint(tabsRouter.activeIndex,
                  paintIconColor: Theme.of(context).colorScheme.primary),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MainTab.home,
                MainTab.cart,
                MainTab.daily,
                MainTab.loveList,
                MainTab.account,
              ].map((tab) {
                return TabItem(
                  mainTab: tab,
                  isActive: tab.index == tabsRouter.activeIndex,
                  onTap: () => tabsRouter.setActiveIndex(tab.index),
                  height: height,
                );
              }).toList(),
            ),
          ],
        ));
  }
}
