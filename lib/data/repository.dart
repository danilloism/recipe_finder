import 'package:recipe_finder/data/models.dart';

abstract class Repository {
  Future<List<Recipe>> findAllRecipes();
  Stream<List<Recipe>> watchAllRecipes();
  Stream<List<Ingredient>> watchAllIngredients();
  Future<Recipe> findRecipeById(int id);
  Future<List<Ingredient>> findAllIngredients();
  Future<List<Ingredient>> findRecipeIngredients(int recipeId);

  Future<int> insertRecipe(Recipe recipe);
  Future<List<int>> insertIngredients(List<Ingredient> ingredients);

  void deleteRecipe(Recipe recipe);
  void deleteIngredient(Ingredient ingredient);
  void deleteIngredients(List<Ingredient> ingredients);
  void deleteRecipeIngredients(int recipeId);

  Future init();
  void close();
}
