import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:recipe_finder/data/repository.dart';
import 'package:recipe_finder/data/models.dart';

class MemoryRepository extends Repository with ChangeNotifier {
  final _currentRecipes = <Recipe>[];
  final _currentIngredients = <Ingredient>[];

  @override
  List<Recipe> findAllRecipes() => _currentRecipes;

  @override
  Recipe findRecipeById(int id) =>
      _currentRecipes.firstWhere((recipe) => recipe.id == id);

  @override
  List<Ingredient> findAllIngredients() => _currentIngredients;

  @override
  List<Ingredient> findRecipeIngredients(int recipeId) {
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipeId)
        .toList();

    return recipeIngredients;
  }

  @override
  int insertRecipe(Recipe recipe) {
    _currentRecipes.add(recipe);

    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }

    notifyListeners();

    return 0;
  }

  @override
  List<int> insertIngredients(List<Ingredient> ingredients) {
    if (ingredients.isNotEmpty) {
      _currentIngredients.addAll(ingredients);
      notifyListeners();
    }

    return <int>[];
  }

  @override
  void deleteRecipe(Recipe recipe) {
    _currentRecipes.remove(recipe);

    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }

    notifyListeners();
  }

  @override
  void deleteIngredient(Ingredient ingredient) =>
      _currentIngredients.remove(ingredient);

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));

    notifyListeners();
  }

  @override
  void deleteRecipeIngredients(int recipeId) {
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);

    notifyListeners();
  }

  @override
  Future init() => Future.value(null);

  @override
  void close() {}
}
