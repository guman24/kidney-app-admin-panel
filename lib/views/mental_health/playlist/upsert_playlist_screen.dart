import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/playlist.dart';
import 'package:kidney_admin/view_models/playlist/playlist_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UpsertPlaylistScreen extends ConsumerStatefulWidget {
  const UpsertPlaylistScreen({super.key});

  @override
  ConsumerState<UpsertPlaylistScreen> createState() =>
      _UpsertPlaylistScreenState();
}

class _UpsertPlaylistScreenState extends ConsumerState<UpsertPlaylistScreen> {
  final TextEditingController _overviewDescCtrl = TextEditingController();
  final TextEditingController _benefitsDescCtrl = TextEditingController();
  final TextEditingController _playlistDescCtrl = TextEditingController();

  MediaUploadData? mediaData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playlist = ref.read(playlistViewModel).playlist;
      if (playlist != null) {
        _overviewDescCtrl.text = playlist.overview;
        _benefitsDescCtrl.text = playlist.benefits;
        _playlistDescCtrl.text = playlist.healingDesc;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(playlistViewModel, (prev, state) {
      if (state.saveStatus.isSuccess) {
        context.pop();
      }
      if (state.saveStatus.isFailed) {
        context.showErrorSnackBar("Failed to save playlist");
      }
    });

    return ModalProgressHUD(
      inAsyncCall: ref.watch(playlistViewModel).saveStatus.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Playlist"),
          actionsPadding: EdgeInsets.symmetric(horizontal: 24),
          actions: [
            CustomButton(
              label: "Save",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // proceed to save playlist
                  Playlist playlist = Playlist(
                    overview: _overviewDescCtrl.text,
                    benefits: _benefitsDescCtrl.text,
                    healingDesc: _playlistDescCtrl.text,
                  );

                  ref
                      .read(playlistViewModel.notifier)
                      .savePlaylist(playlist, mediaData: mediaData);
                }
              },
              bgColor: AppColors.green,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: GridView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 640,
              crossAxisSpacing: 18.0,
              mainAxisSpacing: 16.0,
              mainAxisExtent: 260.0,
            ),
            children: [
              CustomTextInput(
                title: "The Healing Power of Music",
                maxLines: 10,
                hint: "Type something...",
                controller: _overviewDescCtrl,
                validator: FieldValidators.notEmptyStringValidator,
              ),
              CustomTextInput(
                controller: _benefitsDescCtrl,
                title: "Benefits for mind and body",
                maxLines: 10,
                hint: "Type something...",
                validator: FieldValidators.notEmptyStringValidator,
              ),
              CustomTextInput(
                controller: _playlistDescCtrl,
                title: "Creating your healing Playlist",
                maxLines: 10,
                hint: "Type something...",
                validator: FieldValidators.notEmptyStringValidator,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.0,
                children: [
                  Text(
                    "Begin your journey",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Expanded(
                    child: MediaUploadCard(
                      initialNetworkUrl: ref
                          .read(playlistViewModel)
                          .playlist
                          ?.media
                          ?.value,
                      onMediaPicked: (mediaData) {
                        this.mediaData = mediaData;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
