import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/inspiration.dart';
import 'package:kidney_admin/view_models/inspiration/inspiration_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:uuid/uuid.dart';

class InspirationUpsertDrawer extends ConsumerStatefulWidget {
  const InspirationUpsertDrawer({super.key});

  @override
  ConsumerState<InspirationUpsertDrawer> createState() =>
      _InspirationUpsertDrawerState();
}

class _InspirationUpsertDrawerState
    extends ConsumerState<InspirationUpsertDrawer> {
  final TextEditingController _quoteCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Inspiration? editInspiration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editInspiration = ref.read(inspirationsViewModel).editInspiration;
      if (editInspiration != null) {
        _quoteCtrl.text = editInspiration!.quote;
      }
    });
  }

  @override
  void dispose() {
    Future.microtask(() {
      ref.read(inspirationsViewModel.notifier).setEditInspiration(null);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
      constraints: BoxConstraints(maxWidth: 420),
      color: AppColors.white,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 12.0,
          children: [
            CustomTextInput(
              controller: _quoteCtrl,
              hint: "Write inspiration",
              maxLines: 3,
              title: "Inspiration Quote",
              validator: FieldValidators.notEmptyStringValidator,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: "Save",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    //  save inspiration quote
                    final Inspiration inspiration = Inspiration(
                      id: editInspiration?.id ?? const Uuid().v4(),
                      quote: _quoteCtrl.text,
                      createdAt: DateTime.now(),
                    );
                    ref
                        .read(inspirationsViewModel.notifier)
                        .saveInspiration(inspiration);

                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
