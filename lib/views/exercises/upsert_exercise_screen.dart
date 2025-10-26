import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/constants/constants.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/exercise.dart';
import 'package:kidney_admin/entities/instruction.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/view_models/exercise/exercise_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_drop_down_field.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/instructions_setup_area.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class UpsertExerciseScreen extends ConsumerStatefulWidget {
  const UpsertExerciseScreen({super.key, this.exercise});

  final Exercise? exercise;

  @override
  ConsumerState<UpsertExerciseScreen> createState() =>
      _UpsertExerciseScreenState();
}

class _UpsertExerciseScreenState extends ConsumerState<UpsertExerciseScreen> {
  Exercise? get exercise => widget.exercise;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController();
  final TextEditingController _benefitCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Instruction> _instructions = [];
  MediaUploadData? _mediaUploadData;
  String? _exerciseType;
  String? _difficultyLevel;

  @override
  void initState() {
    super.initState();
    if (exercise != null) {
      _nameCtrl.text = exercise!.name;
      _benefitCtrl.text = exercise!.benefits;
      _durationCtrl.text = exercise!.duration ?? "";
      _instructions = exercise!.instructions;
      _exerciseType = exercise!.type;
      _difficultyLevel = exercise!.difficultyLevel;
    } else {
      _exerciseType = ExerciseConstants.exerciseTypes.firstOrNull;
      _difficultyLevel = ExerciseConstants.difficultyLevels.firstOrNull;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(exerciseViewModel, (prev, state) {
      if (state.upsertStatus.isFailed) {
        context.showErrorSnackBar("Failed to save exercise");
      }
      if (state.upsertStatus.isSuccess) {
        context.showSuccessSnackBar("Saved exercise successfully");
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Add Exercise")),
      body: ModalProgressHUD(
        inAsyncCall: ref.watch(exerciseViewModel).upsertStatus.isLoading,
        child: Container(
          decoration: BoxDecoration(color: AppColors.white),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          child: Column(
            spacing: 18.0,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 18.0,
                          children: [
                            CustomTextInput(
                              hint: "Exercise name",
                              controller: _nameCtrl,
                              validator:
                                  FieldValidators.notEmptyStringValidator,
                            ),

                            CustomDropDownField(
                              labelText: "Exercise Type",
                              value: _exerciseType,
                              items: ExerciseConstants.exerciseTypes,
                              onChanged: (value) {
                                setState(() {
                                  _exerciseType = value;
                                });
                              },
                            ),
                            CustomDropDownField(
                              labelText: "Difficulty Level",
                              value: _difficultyLevel,
                              items: ExerciseConstants.difficultyLevels,
                              onChanged: (value) {
                                setState(() {
                                  _difficultyLevel = value;
                                });
                              },
                            ),
                            CustomTextInput(
                              controller: _durationCtrl,
                              hint: "Duration",
                            ),
                            MediaUploadCard(
                              initialNetworkUrl: exercise?.media?.value,
                              onMediaPicked: (value) {
                                setState(() {
                                  _mediaUploadData = value;
                                });
                              },
                            ),
                            CustomTextInput(
                              controller: _benefitCtrl,
                              hint: "Health Benefits",
                              maxLines: 8,
                              validator:
                                  FieldValidators.notEmptyStringValidator,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: InstructionsSetupArea(
                          instructions: _instructions,
                          onChangedInstructions: (instructions) {
                            setState(() {
                              _instructions = instructions;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Save",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (_instructions.isEmpty) {
                            return context.showErrorSnackBar(
                              "Add Instructions of of the exercise",
                            );
                          }

                          final oliver = ref.read(authViewModel).currentOliver;

                          // process to save the exercise
                          final Exercise preparedExercise = Exercise(
                            id: exercise?.id ?? const Uuid().v4(),
                            userId: "oliver-admin",
                            username: oliver?.fullName ?? "Admin",
                            name: _nameCtrl.text,
                            benefits: _benefitCtrl.text,
                            type: _exerciseType ?? "",
                            difficultyLevel: _difficultyLevel ?? "",
                            instructions: _instructions,
                            status: exercise?.status ?? PostStatus.pending,
                          );

                          ref
                              .read(exerciseViewModel.notifier)
                              .saveExercise(
                                preparedExercise,
                                uploadedMedia: _mediaUploadData,
                              );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
