import 'package:flutter/material.dart';

import '../util/constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function? onClick;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final double fontSize;
  final bool isEnabled;
  final String fontFamily;

  const AppButton(
      {super.key,
      required this.text,
      required this.onClick,
      this.borderRadius = 30,
      this.color,
      this.fontFamily = Constants.montserratMedium,
      this.textColor,
      this.fontSize = 19,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: const BoxConstraints(minHeight: 44, maxHeight: 44),
        onPressed: isEnabled ? () => onClick?.call() : null,
        fillColor: isEnabled ? color : Colors.white54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Text(text,
            style: TextStyle(
                color: Constants.colorOnSurface,
                fontFamily: Constants.montserratRegular,
                fontSize: fontSize)));
  }
}

class IconAppButton extends StatelessWidget {
  final Widget? prefixIcon;
  final String text;
  final Function? onClick;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final double fontSize;
  final bool isEnabled;
  final String fontFamily;

  const IconAppButton(
      {super.key,
      required this.text,
      required this.onClick,
      this.borderRadius = 8,
      this.color,
      this.fontFamily = Constants.montserratMedium,
      this.textColor,
      this.fontSize = 15,
      this.isEnabled = true,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: const BoxConstraints(minHeight: 44, maxHeight: 44),
        onPressed: isEnabled ? () => onClick?.call() : null,
        fillColor: isEnabled ? color : Colors.white54,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              prefixIcon != null ? prefixIcon! : const SizedBox(),
              SizedBox(width: prefixIcon != null ? 15 : 0),
              Text(text,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: fontFamily,
                      fontSize: fontSize))
            ]));
  }
}
