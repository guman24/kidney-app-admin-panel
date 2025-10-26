import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    required this.items,
    this.value,
  });

  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String?)? onChanged;
  final List<String> items;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.black),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      decoration: InputDecoration(
        hintText: hintText,
        label: labelText == null && hintText == null
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 1.0,
                ),
                color: Theme.of(context).colorScheme.onPrimary,
                child: Text(labelText ?? hintText!),
              ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          maxWidth: 48.0,
          maxHeight: 48.0,
          minHeight: 24.0,
          minWidth: 24.0,
        ),
      ),
    );
  }
}
