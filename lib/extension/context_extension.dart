import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {

  Size get screenSize => MediaQuery.of(this).size;

  bool get isHaveBottomNotch => window.viewPadding.bottom > 0 && Platform.isIOS;

  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;

  double get bottomNotchHeight => MediaQuery.of(this).viewPadding.bottom;
  void unfocus() => FocusScope.of(this).unfocus();

}
extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}