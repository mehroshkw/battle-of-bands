import 'package:flutter/material.dart';
import '../util/constants.dart';

class AppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hint;
  final TextInputType textInputType;
  final bool isError;
  final TextInputAction textInputAction;
  final bool isObscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool readOnly;
  final bool enabled;
  final Function()? onSuffixClick;

  const AppTextField(
      {super.key,
      required this.hint,
      required this.textInputType,
      required this.isError,
      this.controller,
      this.onChanged,
      this.isObscure = false,
      this.readOnly = false,
      this.suffixIcon,
      this.onSuffixClick,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
            color: Constants.colorPrimaryVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.3, color: isError ? Constants.colorError : Constants.colorGreen)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: TextFormField(
                  obscureText: isObscure,
                  controller: controller,
                  readOnly: readOnly,
                  enabled: enabled,
                  onChanged: onChanged,
                  keyboardType: textInputType,
                  textInputAction: textInputAction,
                  style: const TextStyle(color: Constants.colorOnSurface, fontFamily: Constants.montserratRegular, fontSize: 14),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: const TextStyle(color: Constants.colorText, fontFamily: Constants.montserratRegular, fontSize: 13)))),
          suffixIcon != null
              ? GestureDetector(onTap: () => onSuffixClick?.call(), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: suffixIcon!))
              : const SizedBox()
        ]));
  }
}

class GenreField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hint;
  final TextInputType textInputType;
  final bool isError;
  final TextInputAction textInputAction;
  final bool isObscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool readOnly;
  final Function()? onSuffixClick;

  const GenreField(
      {super.key,
      required this.hint,
      required this.textInputType,
      required this.isError,
      this.controller,
      this.onChanged,
      this.isObscure = false,
      this.readOnly = false,
      this.suffixIcon,
      this.onSuffixClick,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
            color: Constants.colorPrimaryVariant, borderRadius: BorderRadius.circular(10), border: Border.all(color: isError ? Constants.colorError : Constants.colorOnBorder)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: TextFormField(
                  enabled: false,
                  obscureText: isObscure,
                  controller: controller,
                  readOnly: true,
                  onChanged: onChanged,
                  keyboardType: textInputType,
                  textInputAction: textInputAction,
                  style: const TextStyle(color: Constants.colorOnSurface, fontFamily: Constants.montserratRegular, fontSize: 14),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: const TextStyle(color: Constants.colorText, fontFamily: Constants.montserratRegular, fontSize: 13)))),
          suffixIcon != null
              ? GestureDetector(onTap: () => onSuffixClick?.call(), child: Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5), child: suffixIcon!))
              : const SizedBox()
        ]));
  }
}
