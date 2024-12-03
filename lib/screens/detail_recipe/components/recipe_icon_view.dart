import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 1. cheap
// Ý Nghĩa: Công thức này có chi phí thấp để thực hiện.
// Icon: 💸 (biểu tượng tiền hoặc ngân sách)
// 2. dairyFree
// Ý Nghĩa: Công thức không chứa sản phẩm từ sữa.
// Icon: 🥛🚫 (biểu tượng sản phẩm từ sữa với dấu gạch chéo)
// 3. glutenFree
// Ý Nghĩa: Công thức không chứa gluten, phù hợp với người nhạy cảm với gluten hoặc bệnh celiac.
// Icon: 🌾🚫 (biểu tượng gluten hoặc lúa mì với dấu gạch chéo)
// 4. ketogenic
// Ý Nghĩa: Công thức phù hợp với chế độ ăn ketogenic, thường chứa ít carbohydrate và nhiều chất béo.
// Icon: 🥑 (biểu tượng bơ hoặc thực phẩm giàu chất béo lành mạnh)
// 5. lowFodmap
// Ý Nghĩa: Công thức phù hợp với chế độ ăn low-FODMAP, giúp giảm các triệu chứng tiêu hóa cho người mắc hội chứng ruột kích thích (IBS).
// Icon: 🍏 (biểu tượng táo xanh hoặc thực phẩm dễ tiêu hóa)
// 6. sustainable
// Ý Nghĩa: Công thức này được chuẩn bị với nguyên liệu hoặc phương pháp bền vững về môi trường.
// Icon: 🌍 (biểu tượng trái đất hoặc lá cây)
// 7. vegan
// Ý Nghĩa: Công thức không chứa bất kỳ sản phẩm động vật nào.
// Icon: 🌱 (biểu tượng cây xanh hoặc rau quả)
// 8. vegetarian
// Ý Nghĩa: Công thức không chứa thịt, nhưng có thể chứa các sản phẩm từ sữa và trứng.
// Icon: 🥕 (biểu tượng cà rốt hoặc rau quả)
// 9. veryHealthy
// Ý Nghĩa: Công thức rất tốt cho sức khỏe, thường chứa nhiều chất dinh dưỡng và ít thành phần không lành mạnh.
// Icon: ❤️ (biểu tượng trái tim hoặc biểu tượng sức khỏe)
// 10. whole30
// Ý Nghĩa: Công thức phù hợp với chế độ ăn Whole30, không chứa đường, ngũ cốc, đậu, hoặc sản phẩm từ sữa trong 30 ngày.
// Icon: 🥗 (biểu tượng salad hoặc thực phẩm Whole30)
class RecipeIconview extends StatelessWidget {
  const RecipeIconview({super.key, required this.type});

  final RecipeTagType type;

  String? getMessage(RecipeTagType id, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return "icon tags";
    switch (id) {
      case RecipeTagType.cheap:
        return localizations.cheap;
      case RecipeTagType.dairFree:
        return localizations.dairy_free;
      case RecipeTagType.glutenFree:
        return localizations.gluten_free;
      case RecipeTagType.ketogenic:
        return localizations.ketogenic;
      case RecipeTagType.lowFodmap:
        return localizations.lowFodmap;
      case RecipeTagType.sustainable:
        return localizations.sustainable;
      case RecipeTagType.vegan:
        return localizations.vegan;
      case RecipeTagType.vegetarian:
        return localizations.vegetarian;
      case RecipeTagType.veryHealthy:
        return localizations.very_healthy;
      case RecipeTagType.whole30:
        return localizations.whole30;
      default:
        return null;
    }
  }

  Widget? getIcon(RecipeTagType id) {
    switch (id) {
      case RecipeTagType.cheap:
        return Assets.icons.cheap.svg(height: 30, width: 30);
      case RecipeTagType.dairFree:
        return Assets.icons.dairyFree.svg(height: 30, width: 30);
      case RecipeTagType.glutenFree:
        return Assets.icons.glutenFree.svg(height: 30, width: 30);
      case RecipeTagType.ketogenic:
        return Assets.icons.ketogenic.svg(height: 30, width: 30);
      case RecipeTagType.lowFodmap:
        return Assets.icons.lowFodMap.svg(height: 30, width: 30);
      case RecipeTagType.sustainable:
        return Assets.icons.sustainable.svg(height: 30, width: 30);
      case RecipeTagType.vegan:
        return Assets.icons.vegan.svg(height: 30, width: 30);
      case RecipeTagType.vegetarian:
        return Assets.icons.vegetarian.svg(height: 30, width: 30);
      case RecipeTagType.veryHealthy:
        return Assets.icons.veryHealthy.svg(height: 30, width: 30);
      case RecipeTagType.whole30:
        return Assets.icons.whole30.svg(height: 30, width: 30);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: getMessage(type, context),
      child: getIcon(type),
    );
  }
}
