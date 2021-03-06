import 'package:chopper/chopper.dart';

import 'package:recipe_finder/network/model_converter.dart';
import 'package:recipe_finder/network/model_response.dart';
import 'package:recipe_finder/network/recipe_model.dart';
import 'package:recipe_finder/network/service_interface.dart';

part 'recipe_service.chopper.dart';

const String apiKey = '2c83b169b5f7fd30ee2eb28b1a8230d4';
const String apiId = '802d91c4';
const String apiUrl = 'https://api.edamam.com';

@ChopperApi()
abstract class RecipeService extends ChopperService
    implements ServiceInterface {
  @Get(path: 'search')
  @override
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      @Query('q') String query, @Query('from') int from, @Query('to') int to);

  static RecipeService create() {
    final client = ChopperClient(
      baseUrl: apiUrl,
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: ModelConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$RecipeService(),
      ],
    );
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);
  params['app_id'] = apiId;
  params['app_key'] = apiKey;

  return req.copyWith(parameters: params);
}
