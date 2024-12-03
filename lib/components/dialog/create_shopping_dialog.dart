import 'package:base_code_template_flutter/components/dialog/base_dialog.dart';
import 'package:base_code_template_flutter/data/models/shopping_list/supermaket_shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateShoppingDialog extends BaseDialog {
  const CreateShoppingDialog({
    super.key,
    super.onClosed,
    required this.onSubmit,
  }) : super(title: "Create Shopping Item");

  final Function(String item, String aisle)? onSubmit;

  @override
  Widget? buildContext(BuildContext context) {
    SupermarketShoppingItem? selectedQuantity;
    String? nameItem;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)?.item_name ?? "Item name",
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                nameItem = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.quantity ?? "Quantity",
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SupermarketShoppingItem>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.select_aisle ??
                    "Select aisle",
                border: const OutlineInputBorder(),
              ),
              value: selectedQuantity,
              onChanged: (SupermarketShoppingItem? newValue) {
                selectedQuantity = newValue;
              },
              items: listSupermarketShoppingItem
                  .map((item) => DropdownMenuItem<SupermarketShoppingItem>(
                        value: item,
                        child: Text(AppLocalizations.of(context)
                                ?.supermarket_shopping_aisle(
                                    item.name, item.name) ??
                            "Other"),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            // Nút tạo (submit)
            ElevatedButton(
              onPressed: () {
                if (onSubmit != null) {
                  if (selectedQuantity == null || nameItem == null) return;
                  onSubmit!(nameItem!, selectedQuantity!.value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                  AppLocalizations.of(context)?.create_item ?? "Create item"),
            ),
          ],
        ),
      ),
    );
  }
}
