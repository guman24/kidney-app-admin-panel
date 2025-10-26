import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/core/utils/validators.dart';
import 'package:kidney_admin/core/widgets/adaptive_text.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: ref.watch(authViewModel).isLoading,
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 24.0,
            ),
            constraints: BoxConstraints(maxWidth: 400.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.olive.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveText("Login into your account!"),
                  CustomTextInput(
                    controller: _emailCtrl,
                    hint: "Email or username",
                    validator: FieldValidators.notEmptyEmailValidator,
                  ),
                  CustomTextInput(
                    controller: _passwordCtrl,
                    hint: "Password",
                    validator: FieldValidators.passwordValidator,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Login",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Completer completer = Completer();
                          await ref
                              .read(authViewModel.notifier)
                              .login(
                                _emailCtrl.text,
                                _passwordCtrl.text,
                                completer: completer,
                              );
                          completer.future
                              .then((data) {
                                if (!context.mounted) return;
                                context.goNamed(Routes.dashboard.name);
                              })
                              .onError((error, st) {
                                if (!context.mounted) return;
                                context.showErrorSnackBar(error.toString());
                              });
                        }
                      },
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
