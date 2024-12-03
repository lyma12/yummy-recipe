import 'package:base_code_template_flutter/data/models/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';

class ItemShoppingList extends StatelessWidget {
  final List<ItemAisles> items;
  final Function(int id) onDeleteItem;
  final Function(int id) onCheckBox;
  final Map<String, bool> stateItems;

  const ItemShoppingList({
    super.key,
    required this.onDeleteItem,
    required this.items,
    required this.onCheckBox,
    required this.stateItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map(
        (item) {
          final measure = item.measures?['us'];
          final isChecked = stateItems[item.id.toString()] ?? false;
          return Dismissible(
            key: Key((item.id ?? 0).toString()),
            child: ListTile(
              leading: Checkbox(
                value: isChecked,
                onChanged: (isCheck) {
                  final id = item.id;
                  if (id != null) {
                    onCheckBox(id);
                  }
                },
              ),
              title: Text(
                "${measure?.amount} ${measure?.unit} ${item.name ?? 'item aisle'}",
                style: TextStyle(
                  decoration:
                      isChecked == true ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  onDeleteItem(item.id ?? 0);
                },
                icon: const Icon(Icons.more_vert_sharp),
              ),
              onTap: () {
                final id = item.id;
                if (id != null) {
                  onCheckBox(id);
                }
              },
            ),
            onDismissed: (_) {
              final id = item.id;
              if (id == null) return;
              onDeleteItem(id);
            },
          );
        },
      ).toList(),
    );
  }
}
