import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myrecipes/my_recipes_list.dart';
import 'recipes/recipe_list.dart';
import 'shopping/shopping_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final pageList = <Widget>[];
  static const String _prefSelectedIndexKey = 'selectedIndex';

  @override
  void initState() {
    super.initState();
    pageList.add(const RecipeList());
    pageList.add(const MyRecipesList());
    pageList.add(const ShoppingList());
    _getCurrentIndex();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _saveCurrentIndex();
  }

  void _saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_prefSelectedIndexKey, _selectedIndex);
  }

  void _getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_prefSelectedIndexKey) &&
        prefs.getInt(_prefSelectedIndexKey) != null) {
      setState(() => _selectedIndex = prefs.getInt(_prefSelectedIndexKey)!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.white,
          //Navigation bar divider color
          systemNavigationBarIconBrightness:
              Brightness.light, //navigation bar icon
        ),
        title: Text(
          _selectedIndex == 0
              ? 'Recipes'
              : _selectedIndex == 1
                  ? 'Bookmarks'
                  : _selectedIndex == 2
                      ? 'Groceries'
                      : 'Recipes',
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
              icon: SvgPicture.asset('assets/images/icon_recipe.svg',
                  color: _selectedIndex == 0 ? green : Colors.grey,
                  semanticsLabel: 'Recipes'),
              label: 'Recipes'),
          NavigationDestination(
              icon: SvgPicture.asset('assets/images/icon_bookmarks.svg',
                  color: _selectedIndex == 1 ? green : Colors.grey,
                  semanticsLabel: 'Bookmarks'),
              label: 'Bookmarks'),
          NavigationDestination(
              icon: SvgPicture.asset('assets/images/icon_shopping_list.svg',
                  color: _selectedIndex == 2 ? green : Colors.grey,
                  semanticsLabel: 'Groceries'),
              label: 'Groceries'),
        ],
      ),
    );
  }
}
