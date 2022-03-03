import 'package:http/http.dart';

class _ApiServiceData {
  static const apiKey = '2c83b169b5f7fd30ee2eb28b1a8230d4';
  static const apiId = '802d91c4';
  static const apiUrl = 'https://api.edamam.com/search';
}

class RecipeService {
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
        '${_ApiServiceData.apiUrl}?app_id=${_ApiServiceData.apiId}&app_key=${_ApiServiceData.apiKey}&q=$query&from=${from.toString()}&to=${to.toString()}');
    return recipeData;
  }
}
