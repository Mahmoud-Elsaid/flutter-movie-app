import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/colors.dart';
import 'package:movie_app/features/home/presentation/component/custom_text.dart';

class CustomTextFormFieldSearch extends StatelessWidget {
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  const CustomTextFormFieldSearch({super.key, this.controller, this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.textColor,
      style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.textformfieldbackgroundcolor,
        suffixIcon: Icon(Icons.search, color: AppColors.hintcolor),
        hint: CustomText(
          text: "Search",
          color: AppColors.hintcolor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      textInputAction: TextInputAction.search,

      onFieldSubmitted:onFieldSubmitted,
    );
  }
}

