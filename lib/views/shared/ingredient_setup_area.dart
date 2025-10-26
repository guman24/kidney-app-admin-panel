import 'package:flutter/material.dart';
import 'package:kidney_admin/entities/ingredient.dart';
import 'package:kidney_admin/views/shared/add_more_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:uuid/uuid.dart';

class IngredientSetupArea extends StatefulWidget {
  const IngredientSetupArea({
    super.key,
    this.ingredients = const [],
    this.onChangedIngredients,
  });

  final List<Ingredient> ingredients;
  final Function(List<Ingredient>)? onChangedIngredients;

  @override
  State<IngredientSetupArea> createState() => _IngredientSetupAreaState();
}

class _IngredientSetupAreaState extends State<IngredientSetupArea> {
  final List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    ingredients.addAll(widget.ingredients);
    if (ingredients.isEmpty) {
      ingredients.add(Ingredient(id: Uuid().v4(), name: "", quantity: ""));
    }
  }

  void updateIngredients(Ingredient ingredient) {
    final index = ingredients.indexWhere((e) => e.id == ingredient.id);
    if (index != -1) {
      ingredients[index] = ingredient;
      setState(() {});
    }
    widget.onChangedIngredients?.call(
      ingredients
          .where((e) => e.name.isNotEmpty && e.quantity.isNotEmpty)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
        ...ingredients.map((ingredient) {
          return Row(
            spacing: 12.0,
            children: [
              Expanded(
                flex: 2,
                child: CustomTextInput(
                  initialValue: ingredient.name,
                  hint: "Ingredient Name",
                  onChanged: (value) {
                    ingredient = ingredient.copyWith(name: value);
                    updateIngredients(ingredient);
                    // ref
                    //     .read(contributeRecipeViewModelProvider.notifier)
                    //     .onUpdateIngredient(ingredient);
                  },
                ),
              ),
              Expanded(
                child: CustomTextInput(
                  initialValue: ingredient.quantity,
                  hint: "Quantity",
                  onChanged: (value) {
                    ingredient = ingredient.copyWith(quantity: value);
                    updateIngredients(ingredient);
                    // ref
                    //     .read(contributeRecipeViewModelProvider.notifier)
                    //     .onUpdateIngredient(ingredient);
                  },
                ),
              ),
            ],
          );
        }),
        AddMoreButton(
          label: "More",
          onTap: () {
            setState(() {
              ingredients.add(
                Ingredient(id: Uuid().v4(), name: '', quantity: ''),
              );
            });
          },
        ),
      ],
    );
  }
}
