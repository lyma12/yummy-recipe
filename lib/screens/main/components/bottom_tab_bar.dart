import 'package:auto_route/auto_route.dart';
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
    return Container(
      height: MediaQuery.of(context).size.height < 400
          ? MediaQuery.of(context).size.height / 10
          : MediaQuery.of(context).size.height / 13,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
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
            onTap: () {
              if (tabsRouter.canPop()) {
                tabsRouter.maybePopTop();
              }
              tabsRouter.setActiveIndex(tab.index);
            },
          );
        }).toList(),
      ),
    );
  }
}
