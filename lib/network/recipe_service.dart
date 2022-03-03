import 'package:http/http.dart';

class RecipeService {
  static const _apiKey = '2c83b169b5f7fd30ee2eb28b1a8230d4';
  static const _apiId = '802d91c4';
  static const _apiUrl = 'https://api.edamam.com/search';

  //TODO: handle http request errors
  Future<String> _getData(String url) async {
    print('Calling url: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
      return '';
    }
  }

  Future<String> getRecipes(String query, int from, int to) async {
    final recipeData = await _getData(
        '$_apiUrl?app_id=$_apiId&app_key=$_apiKey&q=$query&from=${from.toString()}&to=${to.toString()}');
    return recipeData;
  }
}
