import 'package:flutter/material.dart';

class CalendarScreenBar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarScreenBar(
      {super.key, required this.tabController, required this.tabs});

  final TabController tabController;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: TabBar(
        controller: tabController,
        unselectedLabelColor: Theme.of(context).colorScheme.outline,
        indicator: const BoxDecoration(),
        dividerHeight: 0,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
