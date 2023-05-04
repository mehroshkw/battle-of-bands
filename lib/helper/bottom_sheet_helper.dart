import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../common/app_button.dart';
import '../util/app_strings.dart';
import '../util/constants.dart';

class BottomSheetHelper {
  static BottomSheetHelper? _instance;

  BottomSheetHelper._();

  static BottomSheetHelper instance() {
    _instance ??= BottomSheetHelper._();
    return _instance!;
  }

  BuildContext? _context;

  void injectContext(BuildContext context) => _context = context;

  void hideSheet() {
    final context = _context;
    if (context == null) return;
    Navigator.pop(context);
  }

  void showDeleteBottomSheet(String text,Function() deleteClosure) {
    final context = _context;
    if (context == null) return;

    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
        shape: const OutlineInputBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(4),topLeft: Radius.circular(4))),
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Constants.colorTextLight,
                              offset: const Offset(0.0, 0.2),
                              blurRadius: 0.3,
                              spreadRadius: 0.3)
                        ],
                        border: Border.all(width: 1, color: Constants.colorPrimary.withAlpha(120)),
                        image: const DecorationImage(image: AssetImage('assets/2x/delete_swipe_icon.png')),
                        color: Constants.colorOnBackground,
                        shape: BoxShape.circle),
                  ),
                   Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontFamily: Constants.montserratRegular, height: 1),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                            height: 55,
                            child: AppButton(
                              onClick: () => Navigator.pop(context),
                              text: 'cancel',
                              textColor: Constants.colorOnSurface,
                              borderRadius: 5.0,
                              fontSize: 16,
                            )),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                            height: 55,
                            child: AppButton(
                              onClick:()=> deleteClosure.call(),
                              text: 'delete',
                              textColor: Constants.colorError,
                              borderRadius: 5.0,
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        backgroundColor: Constants.colorBackground);
  }

  void showBottomSheetWithList(List<BottomSheetListItem> items, Function(BottomSheetListItem) onSelection,
      {bool isLastError = false}) {
    final context = _context;
    if (context == null) return;


    final columnChildren = <Widget>[];

    columnChildren.addAll(items.mapIndexed((index, element) {
      return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onSelection.call(element);
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    element.prefixWidget,
                    const SizedBox(width: 10),
                    Text(element.text,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color:
                            (index == items.length - 1 && isLastError) ? Constants.colorError :Constants.colorOnSurface,
                            fontFamily: Constants.montserratRegular,
                            fontSize: 14))
                  ])));
    }));
    columnChildren.add(SizedBox(height: 20));

    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: columnChildren)));
  }
}

class BottomSheetListItem {
  final Widget prefixWidget;
  final String text;

  BottomSheetListItem({required this.prefixWidget, required this.text});
}