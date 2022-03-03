import 'package:json_annotation/json_annotation.dart';
part 'recipe_model.g.dart';

@JsonSerializable()
class ApiRecipeQuery {
  @JsonKey(name: 'q')
  final String query;
  final int from;
  final int to;
  final bool more;
  final int count;
  final List<ApiHits> hits;

  ApiRecipeQuery({
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });

  factory ApiRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeQueryFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRecipeQueryToJson(this);
}

@JsonSerializable()
class ApiHits {
  final ApiRecipe recipe;

  ApiHits({required this.recipe});

  factory ApiHits.fromJson(Map<String, dynamic> json) =>
      _$ApiHitsFromJson(json);
  Map<String, dynamic> toJson() => _$ApiHitsToJson(this);
}

@JsonSerializable()
class ApiRecipe {
  final String label;
  final String image;
  final String url;
  final List<ApiIngredients> ingredients;
  final double calories;
  final double totalWeight;
  final double totalTime;

  ApiRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  });

  factory ApiRecipe.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRecipeToJson(this);
}

String getCaloriesAsString(double? calories) {
  if (calories == null) return '0 KCAL';
  return calories.floor().toString() + 'KCAL';
}

String getWeightAsString(double? weight) {
  if (weight == null) return '0g';
  return weight.floor().toString() + 'g';
}

@JsonSerializable()
class ApiIngredients {
  @JsonKey(name: 'text')
  final String name;
  final double weight;

  ApiIngredients({
    required this.name,
    required this.weight,
  });

  factory ApiIngredients.fromJson(Map<String, dynamic> json) =>
      _$ApiIngredientsFromJson(json);
  Map<String, dynamic> toJson() => _$ApiIngredientsToJson(this);
}
