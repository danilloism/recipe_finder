import 'package:json_annotation/json_annotation.dart';
part 'recipe_model.g.dart';

@JsonSerializable()
class ApiRecipeQuery {
  ApiRecipeQuery({
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });

  @JsonKey(name: 'q')
  final String query;
  final int from;
  final int to;
  final bool more;
  final int count;
  final List<ApiHits> hits;

  factory ApiRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeQueryFromJson(json);
  Map<String, dynamic> toJson() => _$ApiRecipeQueryToJson(this);
}

@JsonSerializable()
class ApiHits {
  ApiHits({required this.recipe});

  final ApiRecipe recipe;

  factory ApiHits.fromJson(Map<String, dynamic> json) =>
      _$ApiHitsFromJson(json);
  Map<String, dynamic> toJson() => _$ApiHitsToJson(this);
}

@JsonSerializable()
class ApiRecipe {
  ApiRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  });

  final String label;
  final String image;
  final String url;
  final List<ApiIngredients> ingredients;
  final double calories;
  final double totalWeight;
  final double totalTime;

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
  ApiIngredients({
    required this.name,
    required this.weight,
  });

  @JsonKey(name: 'text')
  final String name;
  final double weight;

  factory ApiIngredients.fromJson(Map<String, dynamic> json) =>
      _$ApiIngredientsFromJson(json);
  Map<String, dynamic> toJson() => _$ApiIngredientsToJson(this);
}
