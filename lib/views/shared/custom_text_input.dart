import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    this.hint,
    this.controller,
    this.validator,
    this.obscure,
    this.autoValidateMode,
    this.onChanged,
    this.maxLines,
    this.initialValue,
  });

  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscure;
  final AutovalidateMode? autoValidateMode;
  final Function(String)? onChanged;
  final int? maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.0,
      children: [
        TextFormField(
          maxLines: maxLines,
          onChanged: onChanged,
          autovalidateMode:
              autoValidateMode ?? AutovalidateMode.onUserInteraction,
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          validator: validator,
          obscureText: obscure ?? false,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: TextStyle(fontSize: 14.0, color: AppColors.textColor),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
