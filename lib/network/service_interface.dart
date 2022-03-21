import 'package:chopper/chopper.dart';
import 'package:recipe_finder/network/model_response.dart';
import 'package:recipe_finder/network/recipe_model.dart';

abstract class ServiceInterface {
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to);
}
