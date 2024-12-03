import 'package:flutter/material.dart';

import '../../../data/models/api/responses/nutrition/nutrients.dart';

class NutritionChart extends StatelessWidget {
  final List<Nutrients> nutrient;

  const NutritionChart({super.key, required this.nutrient});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: nutrient.map((nutrient) {
          if (nutrient.amount != null && nutrient.amount! > 0) {
            return _buildBar(
              nutrient.amount!,
              nutrient.name ?? "",
              _getColor(
                nutrient.name ?? '',
              ),
              width,
            );
          } else {
            return const SizedBox();
          }
        }).toList(),
      ),
    );
  }

  Widget _buildBar(double value, String label, Color color, double width) {
    var widthMaxBar = width - 100 - 16 * 2 - 8;
    var widthBar = (value * 0.1 < widthMaxBar) ? value * 0.1 : widthMaxBar;
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: widthBar,
          height: 20,
          color: color,
          child: Tooltip(
            message: "$label amount $value",
            child: (widthBar > 150)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "$value",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 10,
                  ),
          ),
        ),
        if (widthMaxBar - widthBar - 200 > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("$value"),
          ),
      ],
    );
  }

  Color _getColor(String name) {
    switch (name) {
      case 'Calories':
        return Colors.red;
      case 'Fat':
        return Colors.blue;
      case 'Carbohydrates':
        return Colors.green;
      case 'Protein':
        return Colors.orange;
      case 'Sugar':
        return Colors.pink;
      case 'Alcohol':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
