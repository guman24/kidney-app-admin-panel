import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/view_models/olivers/olivers_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';

class OliversEndDrawer extends ConsumerStatefulWidget {
  const OliversEndDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  ConsumerState<OliversEndDrawer> createState() => _OliversEndDrawerState();
}

class _OliversEndDrawerState extends ConsumerState<OliversEndDrawer> {
  String selectedRole = "Specialist";

  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void onChangeRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final oliver = Oliver(
        fullName: _fullNameCtrl.text,
        email: _emailCtrl.text,
        role: selectedRole,
      );
      ref.read(oliversViewModel.notifier).saveOliver(oliver);
      widget.scaffoldKey.currentState?.closeEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      constraints: BoxConstraints(minWidth: 300, maxWidth: 400),
      decoration: BoxDecoration(color: AppColors.white),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 10.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add User", style: TextStyle(fontSize: 18.0)),
            Column(
              spacing: 18.0,
              children: [
                CustomTextInput(
                  hint: "Full Name",
                  controller: _fullNameCtrl,
                  validator: FieldValidators.notEmptyStringValidator,
                ),
                CustomTextInput(
                  hint: "Email",
                  controller: _emailCtrl,
                  validator: FieldValidators.notEmptyEmailValidator,
                ),
                Column(
                  spacing: 8.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Role", style: Theme.of(context).textTheme.labelLarge),
                    Row(
                      spacing: 8.0,
                      children: [
                        Radio.adaptive(
                          value: "Specialist",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            onChangeRole(value ?? "");
                          },
                        ),
                        Text(
                          "Specialist",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        Radio.adaptive(
                          value: "Maintainer",
                          groupValue: selectedRole,
                          onChanged: (value) {
                            onChangeRole(value ?? "");
                          },
                        ),
                        Text(
                          "Maintainer",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  spacing: 18.0,
                  children: [
                    CustomButton(label: "Save", onTap: _onSave),
                    CustomButton(
                      label: "Cancel",
                      onTap: () {
                        widget.scaffoldKey.currentState?.closeEndDrawer();
                      },
                      bgColor: AppColors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
