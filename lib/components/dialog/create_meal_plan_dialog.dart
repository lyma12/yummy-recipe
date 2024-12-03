import 'package:base_code_template_flutter/components/dialog/base_dialog.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CreateMealPlanDialog extends BaseDialog {
  const CreateMealPlanDialog({
    super.key,
    super.onClosed,
    required this.nameRecipe,
    required this.onSubmit,
  }) : super(title: "Create Meal Plan");

  final Function(DateTime time, int timeOfDate)? onSubmit;
  final String nameRecipe;

  @override
  Widget? buildContext(BuildContext context) {
    int? selectTimeOfDay = 1;
    DateTime? selectedDate;
    TextEditingController dateController = TextEditingController();
    final List<int> timeOfDay = [1, 2, 3];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nameRecipe,
              style: AppTextStyles.titleMediumBold,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)?.select_date ?? "Select Date",
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              controller: dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  selectedDate = pickedDate;
                  dateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate!);
                }
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.t_time_of_day ??
                    "Time of day",
                border: const OutlineInputBorder(),
              ),
              value: selectTimeOfDay,
              onChanged: (int? newValue) {
                selectTimeOfDay = newValue;
              },
              items: timeOfDay
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                          AppLocalizations.of(context)?.time_of_day(item) ??
                              "Other"),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            // Nút tạo (submit)
            ElevatedButton(
              onPressed: () {
                if (onSubmit != null) {
                  if (selectedDate == null || selectTimeOfDay == null) return;
                  onSubmit!(selectedDate!, selectTimeOfDay!);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)?.create_meal_plan ??
                  "Create meal plan"),
            ),
          ],
        ),
      ),
    );
  }
}
