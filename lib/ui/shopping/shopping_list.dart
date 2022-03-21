import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/data/repository.dart';
import 'package:recipe_finder/data/models.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final checkBoxValues = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context);
    return StreamBuilder(
      stream: repository.watchAllIngredients(),
      builder: (context, AsyncSnapshot<List<Ingredient>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final ingredients = snapshot.data;
          if (ingredients == null) {
            return const Center();
          }

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                value:
                    checkBoxValues.containsKey(index) && checkBoxValues[index]!,
                title: Text(ingredients[index].name ?? ''),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        checkBoxValues[index] = newValue;
                      },
                    );
                  }
                },
              );
            },
          );
        } else {
          return const Center();
        }
      },
    );
  }
}
