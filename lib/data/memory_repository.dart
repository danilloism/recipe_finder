import 'dart:async';
import 'dart:core';

import 'package:recipe_finder/data/models.dart';
import 'package:recipe_finder/data/repository.dart';

class MemoryRepository extends Repository {
  final _currentRecipes = <Recipe>[];
  final _currentIngredients = <Ingredient>[];
  Stream<List<Recipe>>? _recipeStream;
  Stream<List<Ingredient>>? _ingredientStream;
  final StreamController _recipeStreamController =
      StreamController<List<Recipe>>();
  final StreamController _ingredientStreamController =
      StreamController<List<Ingredient>>();

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    _recipeStream ??= _recipeStreamController.stream as Stream<List<Recipe>>;
    return _recipeStream!;
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    _ingredientStream ??=
        _ingredientStreamController.stream as Stream<List<Ingredient>>;
    return _ingredientStream!;
  }

  @override
  Future<List<Recipe>> findAllRecipes() => Future.value(_currentRecipes);

  @override
  Future<Recipe> findRecipeById(int id) =>
      Future.value(_currentRecipes.firstWhere((recipe) => recipe.id == id));

  @override
  Future<List<Ingredient>> findAllIngredients() =>
      Future.value(_currentIngredients);

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipeId)
        .toList();

    return Future.value(recipeIngredients);
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    _currentRecipes.add(recipe);

    _recipeStreamController.sink.add(_currentRecipes);
    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }

    return Future.value(0);
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    if (ingredients.isNotEmpty) {
      _currentIngredients.addAll(ingredients);
      _ingredientStreamController.sink.add(_currentIngredients);
    }

    return Future.value(<int>[]);
  }

  @override
  void deleteRecipe(Recipe recipe) {
    _currentRecipes.remove(recipe);
    _recipeStreamController.sink.add(_currentRecipes);
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
  }

  @override
  void deleteIngredient(Ingredient ingredient) {
    _currentIngredients.remove(ingredient);
    _recipeStreamController.sink.add(_currentIngredients);
  }

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));
    _ingredientStreamController.sink.add(_currentIngredients);
  }

  @override
  void deleteRecipeIngredients(int recipeId) {
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);

    _ingredientStreamController.sink.add(_currentIngredients);
  }

  @override
  Future init() => Future.value();

  @override
  void close() {
    _recipeStreamController.close();
    _ingredientStreamController.close();
  }
}
