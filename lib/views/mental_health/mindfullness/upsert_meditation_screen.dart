import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/mindfullness.dart';
import 'package:kidney_admin/view_models/mindfullness/mindfullness_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class UpsertMeditationScreen extends ConsumerStatefulWidget {
  const UpsertMeditationScreen({super.key, this.mindfullness});

  final Mindfullness? mindfullness;

  @override
  ConsumerState<UpsertMeditationScreen> createState() =>
      _UpsertMeditationScreenState();
}

class _UpsertMeditationScreenState
    extends ConsumerState<UpsertMeditationScreen> {
  Mindfullness? get mindfullness => widget.mindfullness;

  final TextEditingController _nameCtrl = TextEditingController();

  final TextEditingController _overviewTitleCtrl = TextEditingController();
  final TextEditingController _overviewCtrl = TextEditingController();

  final TextEditingController _mediaTitleCtrl = TextEditingController();

  final TextEditingController _mediaDescCtrl = TextEditingController();

  final TextEditingController _benefitsTitleCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MediaUploadData? mediaUploadData;

  List<String> benefits = [];

  @override
  void initState() {
    super.initState();
    benefits = [""];

    if (mindfullness != null) {
      _nameCtrl.text = mindfullness!.name;
      _overviewTitleCtrl.text = mindfullness!.mindfullnessOverview.title;
      _overviewCtrl.text = mindfullness!.mindfullnessOverview.overview;

      _benefitsTitleCtrl.text = mindfullness!.mindfullnessBenefits.title;
      benefits = mindfullness!.mindfullnessBenefits.benefits;

      _mediaTitleCtrl.text = mindfullness!.mindfullnessMedia.title;
      _mediaDescCtrl.text = mindfullness!.mindfullnessMedia.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(mindfullnessViewModel, (prev, state) {
      if (state.saveStatus.isSuccess) {
        context.showSuccessSnackBar("Successfully saved mindfullness");
        context.pop();
      }
      if (state.saveStatus.isFailed) {
        context.showErrorSnackBar("Could not save, please try again");
      }
    });
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 12.0),
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.black),
        title: Text(
          "Save Mindfullness",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: AppColors.white,
        actions: [
          CustomButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final saveMindfullness = Mindfullness(
                  id: mindfullness?.id ?? const Uuid().v4(),
                  name: _nameCtrl.text,
                  mindfullnessOverview: MindfullnessOverview(
                    title: _overviewTitleCtrl.text,
                    overview: _overviewCtrl.text,
                  ),
                  mindfullnessBenefits: MindfullnessBenefits(
                    title: _benefitsTitleCtrl.text,
                    benefits: benefits.where((e) => e.isNotEmpty).toList(),
                  ),
                  mindfullnessMedia: MindfullnessMedia(
                    title: _mediaTitleCtrl.text,
                    description: _mediaDescCtrl.text,
                    media: mindfullness?.mindfullnessMedia.media,
                  ),
                );

                ref
                    .read(mindfullnessViewModel.notifier)
                    .saveMindfullness(
                      saveMindfullness,
                      uploadedMedia: mediaUploadData,
                    );
              }
            },
            label: "Save",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: ref.watch(mindfullnessViewModel).saveStatus.isLoading,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Builder(
                    builder: (context) {
                      if (constraint.maxWidth <= 640) {
                        return Column(
                          children: [overviewBox(), mediaBox(), benefitsBox()],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [overviewBox(), mediaBox()],
                            ),
                          ),
                          Expanded(child: benefitsBox()),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget overviewBox() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: AppColors.olive.withValues(alpha: 0.1)),
      child: Column(
        spacing: 10.0,
        children: [
          Text("Overview"),
          CustomTextInput(
            title: "Name",
            controller: _nameCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
          CustomTextInput(
            title: "Title",
            controller: _overviewTitleCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
          CustomTextInput(
            title: "Overview",
            maxLines: 10,
            controller: _overviewCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
        ],
      ),
    );
  }

  Widget mediaBox() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: AppColors.olive.withValues(alpha: 0.1)),
      child: Column(
        spacing: 10.0,
        children: [
          Text("Media"),
          CustomTextInput(
            title: "Title",
            controller: _mediaTitleCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
          CustomTextInput(
            title: "Description",
            controller: _mediaDescCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
          MediaUploadCard(
            initialNetworkUrl: mindfullness?.mindfullnessMedia.media?.value,
            onMediaPicked: (data) {
              mediaUploadData = data;
            },
          ),
        ],
      ),
    );
  }

  Widget benefitsBox() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      constraints: BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: AppColors.olive.withValues(alpha: 0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Center(child: Text("Why Helps?")),
          CustomTextInput(
            title: "Title",
            controller: _benefitsTitleCtrl,
            validator: FieldValidators.notEmptyStringValidator,
          ),
          Text("Benefits"),
          ...List.generate(benefits.length, (index) {
            return CustomTextInput(
              initialValue: benefits[index],
              hint: "Enter benefit ${index + 1}",
              onChanged: (value) {
                benefits[index] = value;
                setState(() {});
              },
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              label: "+ New",
              onTap: () {
                setState(() {
                  benefits.add("");
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
