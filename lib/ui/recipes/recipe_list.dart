import 'dart:math';
import 'dart:convert';
import 'package:recipe_finder/network/recipe_model.dart';
import 'package:flutter/services.dart';
import 'package:recipe_finder/ui/recipe_card.dart';
import 'package:recipe_finder/ui/recipes/recipe_details.dart';
import 'package:flutter/material.dart';
import 'package:recipe_finder/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_finder/ui/widgets/custom_dropdown.dart';
import 'package:recipe_finder/ui/colors.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const prefSearchKey = 'previousSearches';
  late final TextEditingController _searchTextController;
  final _scrollController = ScrollController();
  final _currentSearchList = [];
  var _currentCount = 0;
  var _currentStartPosition = 0;
  var _currentEndPosition = 20;
  var _pageCount = 20;
  var _hasMore = false;
  var _loading = false;
  var _inErrorState = false;
  var _previousSearches = <String>[];
  ApiRecipeQuery? _currentRecipes1 = null;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _getPreviousSearches();
    _searchTextController = TextEditingController(text: '');
    _scrollController.addListener(
      () {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (_hasMore &&
              _currentEndPosition < _currentCount &&
              !_loading &&
              !_inErrorState) {
            setState(
              () {
                _loading = true;
                _currentStartPosition = _currentEndPosition;
                _currentEndPosition =
                    min(_currentStartPosition + _pageCount, _currentCount);
              },
            );
          }
        }
      },
    );
  }

  Future _loadRecipes() async {
    final jsonString = await rootBundle.loadString('assets/recipes1.json');
    setState(() =>
        _currentRecipes1 = ApiRecipeQuery.fromJson(jsonDecode(jsonString)));
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, _previousSearches);
  }

  void _getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
      _previousSearches = searches ?? <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Search'),
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (String value) {
                      //   if (!previousSearches.contains(value) &&
                      //       value.isNotEmpty) {
                      //     previousSearches.add(value);
                      //     savePreviousSearches();
                      //   }
                      // },
                      onSubmitted: _startSearch,
                      controller: _searchTextController,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: (String value) {
                      _searchTextController.text = value;
                      _startSearch(_searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      return _previousSearches
                          .map<CustomDropdownMenuItem<String>>(
                        (String value) {
                          return CustomDropdownMenuItem<String>(
                            value: value,
                            text: value,
                            callback: () {
                              setState(() {
                                _previousSearches.remove(value);
                                Navigator.pop(context);
                              });
                            },
                          );
                        },
                      ).toList();
                    },
                  ),
                  gapW8,
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _startSearch(_searchTextController.text);
                      final currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startSearch(String value) {
    setState(
      () {
        _resetSearchList();
        _hasMore = true;
        value = value.trim();

        if (!_previousSearches.contains(value) && value.isNotEmpty) {
          _previousSearches.add(value);
          savePreviousSearches();
        }
      },
    );
  }

  void _resetSearchList() {
    _currentSearchList.clear();
    _currentCount = 0;
    _currentEndPosition = _pageCount;
    _currentStartPosition = 0;
  }

//TODO: replace method
  Widget _buildRecipeLoader(BuildContext context) {
    if (_currentRecipes1 == null || _currentRecipes1?.hits == null) {
      return Container();
    }
    // Show a loading indicator while waiting for the movies
    return Center(
      child: _buildRecipeCard(context, _currentRecipes1!.hits, 0),
    );
  }
}

Widget _buildRecipeCard(
  BuildContext topLevelContext,
  List<ApiHits> hits,
  int index,
) {
  final recipe = hits[index].recipe;
  return GestureDetector(
    onTap: () => Navigator.push(
      topLevelContext,
      MaterialPageRoute(
        builder: ((context) => const RecipeDetails()),
      ),
    ),
    child: recipeStringCard(recipe.image, recipe.label),
  );
}
