import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/recipe.dart';

const String _collectionRecipes = 'recipes';
final recipeServiceProvider = AutoDisposeProvider((_) => RecipeService());

class RecipeService {
  RecipeService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Recipe> saveRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection(_collectionRecipes)
          .doc(recipe.id)
          .set(recipe.toMap(), SetOptions(merge: true));
      return recipe;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final query = await _firestore.collection(_collectionRecipes).get();
      final recipes = List<Recipe>.from(
        query.docs.map((doc) => Recipe.fromJson(doc.data())),
      );
      return recipes;
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> updateRecipeStatus(String recipeId, PostStatus status) async {
    try {
      await _firestore.collection(_collectionRecipes).doc(recipeId).update({
        'status': status.name,
      });
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection(_collectionRecipes).doc(recipeId).delete();
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
