import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

class JournalHeaderInput extends ConsumerWidget {
  const JournalHeaderInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalViewModel);
    return Container(
      padding: const EdgeInsets.all(18.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gradient10),
        color: AppColors.white,
      ),
      child: Column(
        spacing: 12.0,
        children: [
          Text("Header"),
          CustomTextInput(
            title: "Title",
            initialValue: journalState.title,
            onChanged: ref.read(journalViewModel.notifier).onTitleChanged,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thumbnail"),
              MediaUploadCard(
                initialNetworkUrl: journalState.journal?.thumbnailImage,
                acceptedFormats: ['image/*'],
                onMediaPicked: ref
                    .read(journalViewModel.notifier)
                    .onThumbnailMediaChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
