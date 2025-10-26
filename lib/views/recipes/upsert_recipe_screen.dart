import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/ingredient.dart';
import 'package:kidney_admin/entities/instruction.dart';
import 'package:kidney_admin/entities/recipe.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/view_models/recipe/recipe_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/ingredient_setup_area.dart';
import 'package:kidney_admin/views/shared/instructions_setup_area.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class UpsertRecipeScreen extends ConsumerStatefulWidget {
  const UpsertRecipeScreen({super.key, this.recipe});

  final Recipe? recipe;

  @override
  ConsumerState<UpsertRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<UpsertRecipeScreen> {
  Recipe? get recipe => widget.recipe;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  List<Ingredient> _ingredients = [];
  List<Instruction> _instructions = [];
  MediaUploadData? _mediaUploadData;

  @override
  void initState() {
    super.initState();
    if (recipe != null) {
      _nameCtrl.text = recipe!.name;
      _descCtrl.text = recipe!.description;
      _ingredients = recipe!.ingredients;
      _instructions = recipe!.instructions;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(recipeViewModel, (prev, state) {
      if (state.saveRecipeStatus.isSuccess) {
        context.pop();
      }
      if (state.saveRecipeStatus.isFailed) {
        context.showErrorSnackBar("Failed to add recipe");
      }
    });

    return ModalProgressHUD(
      inAsyncCall: ref.watch(recipeViewModel).saveRecipeStatus.isLoading,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 680),
          child: Scaffold(
            appBar: AppBar(title: Text("Add Recipe")),
            body: Container(
              decoration: BoxDecoration(color: AppColors.white),
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16.0,
                    children: [
                      CustomTextInput(
                        hint: "Recipe name",
                        controller: _nameCtrl,
                        validator: FieldValidators.notEmptyStringValidator,
                      ),
                      MediaUploadCard(
                        initialNetworkUrl: recipe?.media?.value,
                        onMediaPicked: (value) {
                          setState(() {
                            _mediaUploadData = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        hint: "Description",
                        maxLines: 8,
                        controller: _descCtrl,
                        validator: FieldValidators.notEmptyStringValidator,
                      ),
                      IngredientSetupArea(
                        ingredients: _ingredients,
                        onChangedIngredients: (ingredients) {
                          setState(() {
                            _ingredients = ingredients;
                          });
                        },
                      ),

                      InstructionsSetupArea(
                        onChangedInstructions: (instructions) {
                          setState(() {
                            _instructions = instructions;
                          });
                        },
                        instructions: _instructions,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onTap: () {
                            final oliver = ref
                                .read(authViewModel)
                                .currentOliver;
                            if (_formKey.currentState!.validate()) {
                              if (_ingredients.isEmpty) {
                                return context.showErrorSnackBar(
                                  "Please add ingredients",
                                );
                              }

                              /// save recipe
                              ref
                                  .read(recipeViewModel.notifier)
                                  .saveRecipe(
                                    Recipe(
                                      id: recipe?.id ?? const Uuid().v4(),
                                      userId: recipe?.userId ?? 'oliver-admin',
                                      username:
                                          recipe?.username ??
                                          oliver?.fullName ??
                                          "Admin",
                                      name: _nameCtrl.text,
                                      description: _descCtrl.text,
                                      ingredients: _ingredients,
                                      instructions: _instructions,
                                      status:
                                          recipe?.status ?? PostStatus.pending,
                                    ),
                                    recipeFile: _mediaUploadData,
                                  );
                            }
                          },
                          label: "Save",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
