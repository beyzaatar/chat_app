import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      color: colors.primaryButton,
      child: Form(
        child: TextFormField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: colors.scaffoldBackground,
            prefixIcon: Icon(
              Icons.search,
              color: colors.iconColor.withValues(alpha: 0.64),
            ),
            hintText: "Arama...",
            hintStyle: TextStyle(
              color: colors.iconColor.withValues(alpha: 0.64),
            ),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0 * 1.5,
              vertical: 16.0,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
        ),
      ),
    );
  }
}
