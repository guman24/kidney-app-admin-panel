import 'package:flutter/cupertino.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/recipe.dart';

class RecipeState {
  final ActionStatus fetchRecipeStatus;
  final List<Recipe> recipes;
  final ActionStatus deleteStatus;
  final ActionStatus saveRecipeStatus;

  RecipeState({
    this.fetchRecipeStatus = ActionStatus.initial,
    this.recipes = const [],
    this.deleteStatus = ActionStatus.initial,
    this.saveRecipeStatus = ActionStatus.initial,
  });

  RecipeState copyWith({
    ActionStatus? fetchRecipeStatus,
    List<Recipe>? recipes,
    ActionStatus? deleteStatus,
    ActionStatus? saveRecipeStatus,
  }) {
    return RecipeState(
      fetchRecipeStatus: fetchRecipeStatus ?? this.fetchRecipeStatus,
      recipes: recipes ?? this.recipes,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      saveRecipeStatus: saveRecipeStatus ?? this.saveRecipeStatus,
    );
  }
}
