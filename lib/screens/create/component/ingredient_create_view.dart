import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IngredientCreateView extends StatefulWidget {
  const IngredientCreateView({
    super.key,
    required this.ingredient,
    required this.onSubmit,
  });

  final Ingredient ingredient;
  final Function(Ingredient ingredient) onSubmit;

  @override
  State<StatefulWidget> createState() => _IngredientCreateViewState();
}

class _IngredientCreateViewState extends State<IngredientCreateView> {
  bool _edit = false;
  double? amount;
  String? unit;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _edit
        ? Form(
            key: _keyForm,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)?.enter_amount,
                        ),
                        onChanged: (value) {
                          amount = double.tryParse(value);
                        },
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null) {
                            return AppLocalizations.of(context)?.complete_text;
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.ingredient.name ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        style: AppTextStyles.bodyMedium,
                        onChanged: (value) {
                          unit = value;
                        },
                        items: widget.ingredient.possibleUnits
                            ?.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.done_sharp,
                    size: 20,
                  ),
                  onPressed: () {
                    final formState = _keyForm.currentState;
                    if (formState != null) {
                      if (formState.validate()) {
                        setState(
                          () {
                            _edit = false;
                            Ingredient ingredient = widget.ingredient.copyWith(
                              amount: amount,
                              unit: unit,
                              original:
                                  "$amount ${widget.ingredient.name} $unit",
                            );
                            widget.onSubmit(ingredient);
                          },
                        );
                      }
                    }
                  },
                )
              ],
            ))
        : Row(
            children: [
              if (widget.ingredient.image != null)
                CachedNetworkImage(
                  height: 40,
                  width: 40,
                  imageUrl:
                      "https://img.spoonacular.com/ingredients_100x100/${widget.ingredient.image!}",
                  fit: BoxFit.fill,
                ),
              const SizedBox(
                width: 20,
              ),
              Text(widget.ingredient.original ?? ""),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _edit = true;
                    });
                  },
                  icon: const Icon(Icons.edit))
            ],
          );
  }
}
