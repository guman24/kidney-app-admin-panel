import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/transplant_center.dart';
import 'package:kidney_admin/view_models/wait_time/wait_times_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:uuid/uuid.dart';

class SaveWaitTimeDrawer extends ConsumerStatefulWidget {
  const SaveWaitTimeDrawer({super.key});

  @override
  ConsumerState<SaveWaitTimeDrawer> createState() => _SaveWaitTimeDrawerState();
}

class _SaveWaitTimeDrawerState extends ConsumerState<SaveWaitTimeDrawer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _centerCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _highlightCtrl = TextEditingController();

  TransplantCenter? editCenter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editCenter = ref.read(waitTimesViewModel).editCenter;
      if (editCenter != null) {
        _centerCtrl.text = editCenter!.center;
        _locationCtrl.text = editCenter!.location;
        _highlightCtrl.text = editCenter!.highlights;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      decoration: BoxDecoration(color: AppColors.white),
      constraints: BoxConstraints(minWidth: 400, maxWidth: 420),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            Text(
              "Save Transplant Center",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.black),
            ),

            CustomTextInput(
              hint: "Center",
              controller: _centerCtrl,
              validator: FieldValidators.notEmptyStringValidator,
            ),
            CustomTextInput(
              hint: "Highlight",
              maxLines: 5,
              controller: _highlightCtrl,
              validator: FieldValidators.notEmptyStringValidator,
            ),
            CustomTextInput(
              hint: "Location",
              controller: _locationCtrl,
              validator: FieldValidators.notEmptyStringValidator,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                label: "Save",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // proceed to save the wait time (transplant center)
                    context.pop();
                    final center = TransplantCenter(
                      id: editCenter?.id ?? const Uuid().v4(),
                      center: _centerCtrl.text,
                      location: _locationCtrl.text,
                      highlights: _highlightCtrl.text,
                    );
                    ref
                        .read(waitTimesViewModel.notifier)
                        .saveTransplantCenter(center);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Future.microtask(() {
      ref.read(waitTimesViewModel.notifier).setEditCenter(null);
    });
    super.dispose();
  }
}
