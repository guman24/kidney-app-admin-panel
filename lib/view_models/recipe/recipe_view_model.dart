import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:kidney_admin/entities/recipe.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/services/recipe_service.dart';
import 'package:kidney_admin/services/users_service.dart';
import 'package:kidney_admin/view_models/recipe/recipe_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:uuid/uuid.dart';

final recipeViewModel = NotifierProvider(() => RecipeViewModel());

class RecipeViewModel extends Notifier<RecipeState> {
  @override
  RecipeState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRecipes();
    });
    return RecipeState();
  }

  void saveRecipe(Recipe recipe, {MediaUploadData? recipeFile}) async {
    state = state.copyWith(saveRecipeStatus: ActionStatus.loading);
    try {
      if (recipeFile != null) {
        final mediaUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(recipeFile, "/recipe_images");
        if (mediaUrl == null) return;
        Media media = Media(
          type: recipeFile.isVideo ? MediaType.video : MediaType.image,
          networkType: NetworkType.network,
          value: mediaUrl,
        );
        recipe = recipe.copyWith(media: media);
      }

      final savedRecipe = await ref
          .read(recipeServiceProvider)
          .saveRecipe(recipe);
      final List<Recipe> allRecipes = List.from(state.recipes);
      state = state.copyWith(
        saveRecipeStatus: ActionStatus.success,
        recipes: [savedRecipe, ...allRecipes],
      );
    } catch (error) {
      state = state.copyWith(saveRecipeStatus: ActionStatus.failed);
    }
  }

  void fetchRecipes() async {
    state = state.copyWith(fetchRecipeStatus: ActionStatus.loading);
    try {
      final recipes = await ref.read(recipeServiceProvider).fetchRecipes();
      state = state.copyWith(
        fetchRecipeStatus: ActionStatus.success,
        recipes: recipes,
      );
    } catch (error) {
      state = state.copyWith(fetchRecipeStatus: ActionStatus.failed);
    }
  }

  Future<void> updateRecipeStatus(String recipeId, PostStatus status) async {
    try {
      await ref
          .read(recipeServiceProvider)
          .updateRecipeStatus(recipeId, status);
      List<Recipe> recipes = List.from(state.recipes);
      int index = recipes.indexWhere((e) => e.id == recipeId);
      Recipe updatedRecipe = recipes[index];
      updatedRecipe = updatedRecipe.copyWith(status: status);
      recipes[index] = updatedRecipe;
      state = state.copyWith(recipes: recipes);
    } catch (error) {
      debugPrint("Could not update status of this recipe");
    }
  }

  void deleteRecipe(String recipeId) async {
    state = state.copyWith(deleteStatus: ActionStatus.loading);
    try {
      await ref.read(recipeServiceProvider).deleteRecipe(recipeId);
      List<Recipe> recipes = List.from(state.recipes);
      recipes.removeWhere((e) => e.id == recipeId);
      state = state.copyWith(
        deleteStatus: ActionStatus.success,
        recipes: recipes,
      );
    } catch (error) {
      state = state.copyWith(deleteStatus: ActionStatus.failed);
    }
  }
}
