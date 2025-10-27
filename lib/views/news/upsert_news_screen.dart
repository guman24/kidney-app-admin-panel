import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/news.dart';
import 'package:kidney_admin/view_models/news/news_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_drop_down_field.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class UpsertNewsScreen extends ConsumerStatefulWidget {
  const UpsertNewsScreen({super.key, this.news});

  final News? news;

  @override
  ConsumerState<UpsertNewsScreen> createState() => _UpsertNewsScreenState();
}

class _UpsertNewsScreenState extends ConsumerState<UpsertNewsScreen> {
  News? get news => widget.news;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _linkCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();
  MediaUploadData? _mediaUploadData;
  NewsType _newsType = NewsType.news;

  @override
  void initState() {
    super.initState();
    if (news != null) {
      _titleCtrl.text = news!.title;
      _contentCtrl.text = news!.content;
      _linkCtrl.text = news!.url ?? "";
      _newsType = news!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(newsViewModel, (prev, state) {
      if (state.upsertStatus.isFailed) {
        context.showErrorSnackBar("Failed to save news");
      }
      if (state.upsertStatus.isSuccess) {
        context.pop();
      }
    });
    final newsState = ref.watch(newsViewModel);
    return ModalProgressHUD(
      inAsyncCall: newsState.upsertStatus.isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text("News & Research")),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(color: AppColors.white),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 18.0,
            ),
            child: Form(
              key: _formKey,
              child: Row(
                spacing: 24.0,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextInput(
                      controller: _contentCtrl,
                      maxLines: 20,
                      hint: "Write description... ",
                      validator: FieldValidators.notEmptyStringValidator,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextInput(
                          controller: _titleCtrl,
                          hint: "Title",
                          validator: FieldValidators.notEmptyStringValidator,
                        ),
                        CustomTextInput(controller: _linkCtrl, hint: "Link"),
                        CustomDropDownField(
                          value: _newsType.displayName,
                          items: NewsType.values
                              .map((e) => e.displayName)
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _newsType = value.toLowerCase().newsTypeEnum;
                            });
                          },
                        ),
                        MediaUploadCard(
                          initialNetworkUrl: news?.image,
                          acceptedFormats: ['image/*'],
                          onMediaPicked: (data) {
                            setState(() {
                              _mediaUploadData = data;
                            });
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            label: "Save",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // proceed to save news
                                final News news = News(
                                  id: const Uuid().v4(),
                                  title: _titleCtrl.text,
                                  description: _contentCtrl.text,
                                  content: _contentCtrl.text,
                                  url: _linkCtrl.text,
                                  createdAt: DateTime.now(),
                                  status: PostStatus.pending,
                                  type: _newsType,
                                );

                                ref
                                    .read(newsViewModel.notifier)
                                    .saveNews(
                                      news,
                                      mediaData: _mediaUploadData,
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
