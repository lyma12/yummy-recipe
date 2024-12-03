import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'queries.freezed.dart';
part 'queries.g.dart';

// Main Queries model
@freezed
@HiveType(typeId: 8, adapterName: 'QueriesAdapter')
class Queries with _$Queries {
  const factory Queries({
    @HiveField(0) Cuisine? cuisine,
    @HiveField(1) List<Diet>? diet,
    @HiveField(2) List<Intolerance>? intolerances,
    @HiveField(3) List<MealType>? type,
  }) = _Queries;

  factory Queries.fromJson(Map<String, dynamic> json) =>
      _$QueriesFromJson(json);
}

// Enum for Cuisine
@HiveType(typeId: 9, adapterName: 'CuisineAdapter')
enum Cuisine {
  @HiveField(0)
  none,
  @HiveField(1)
  african,
  @HiveField(2)
  asian,
  @HiveField(3)
  american,
  @HiveField(4)
  british,
  @HiveField(5)
  cajun,
  @HiveField(6)
  caribbean,
  @HiveField(7)
  chinese,
  @HiveField(8)
  easternEuropean,
  @HiveField(9)
  european,
  @HiveField(10)
  french,
  @HiveField(11)
  german,
  @HiveField(12)
  greek,
  @HiveField(13)
  indian,
  @HiveField(14)
  irish,
  @HiveField(15)
  italian,
  @HiveField(16)
  japanese,
  @HiveField(17)
  jewish,
  @HiveField(18)
  korean,
  @HiveField(19)
  latinAmerican,
  @HiveField(20)
  mediterranean,
  @HiveField(21)
  mexican,
  @HiveField(22)
  middleEastern,
  @HiveField(23)
  nordic,
  @HiveField(24)
  southern,
  @HiveField(25)
  spanish,
  @HiveField(26)
  thai,
  @HiveField(27)
  vietnamese,
}

// Enum for Diet
@HiveType(typeId: 10, adapterName: 'DietAdapter')
enum Diet {
  @HiveField(0)
  glutenFree,
  @HiveField(1)
  ketogenic,
  @HiveField(2)
  vegetarian,
  @HiveField(3)
  lactoVegetarian,
  @HiveField(4)
  ovoVegetarian,
  @HiveField(5)
  vegan,
  @HiveField(6)
  pescetarian,
  @HiveField(7)
  paleo,
  @HiveField(8)
  primal,
  @HiveField(9)
  lowFODMAP,
  @HiveField(10)
  whole30,
}

// Enum for MealType
@HiveType(typeId: 11, adapterName: 'MealTypeAdapter')
enum MealType {
  @HiveField(0)
  mainCourse,
  @HiveField(1)
  sideDish,
  @HiveField(2)
  dessert,
  @HiveField(3)
  appetizer,
  @HiveField(4)
  salad,
  @HiveField(5)
  bread,
  @HiveField(6)
  breakfast,
  @HiveField(7)
  soup,
  @HiveField(8)
  beverage,
  @HiveField(9)
  sauce,
  @HiveField(10)
  marinade,
  @HiveField(11)
  fingerFood,
  @HiveField(12)
  snack,
  @HiveField(13)
  drink,
}

// Enum for Intolerance
@HiveType(typeId: 12, adapterName: 'IntoleranceAdapter')
enum Intolerance {
  @HiveField(0)
  dairy,
  @HiveField(1)
  egg,
  @HiveField(2)
  gluten,
  @HiveField(3)
  grain,
  @HiveField(4)
  peanut,
  @HiveField(5)
  seafood,
  @HiveField(6)
  sesame,
  @HiveField(7)
  shellfish,
  @HiveField(8)
  soy,
  @HiveField(9)
  sulfite,
  @HiveField(10)
  treeNut,
  @HiveField(11)
  wheat,
}
