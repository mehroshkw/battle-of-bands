import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';

import '../common/app_button.dart';
import '../util/constants.dart';
import 'material_dialogue_content.dart';

class MaterialDialogHelper {
  static MaterialDialogHelper? _instance;

  MaterialDialogHelper._();

  static MaterialDialogHelper instance() {
    _instance ??= MaterialDialogHelper._();
    return _instance!;
  }

  BuildContext? _context;

  void injectContext(BuildContext context) => _context = context;

  void dismissProgress() {
    final context = _context;
    if (context == null) return;
    Navigator.pop(context);
  }

  void showProgressDialog(String text) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              child: Dialog(
                  backgroundColor: Constants.colorBackground,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const CircularProgressIndicator(backgroundColor: Constants.colorOnPrimary, strokeWidth: 3),
                        const SizedBox(width: 10),
                        Flexible(child: Text(text, style: const TextStyle(color: Constants.colorOnPrimary, fontFamily: Constants.montserratMedium, fontSize: 14)))
                      ]))),
              onWillPop: () async => false);
        });
  }

  void showMaterialDialogWithContent(MaterialDialogContent content, Function positiveClickListener, {Function? negativeClickListener}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  backgroundColor: Constants.scaffoldColor,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Constants.colorSecondary)),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(content.title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: Constants.montserratMedium, fontSize: 22, color: Constants.colorOnSurface))),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(content.message, style: TextStyle(color: Constants.colorOnSurface.withOpacity(0.7), fontSize: 14, fontFamily: Constants.montserratMedium))),
                      const SizedBox(height: 20),
                      IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(
                                height: 35,
                                width: 100,
                                child: AppButton(
                                    onClick: () => Navigator.pop(context),
                                    text: content.negativeText,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorPrimaryVariant,
                                    borderRadius: 10.0,
                                    fontSize: 16,
                                    color: Constants.colorOnSurface)),
                            const SizedBox(width: 20),
                            SizedBox(
                                height: 35,
                                width: 100,
                                child: AppButton(
                                    onClick: () {
                                      Navigator.pop(context);
                                      positiveClickListener.call();
                                    },
                                    text: content.positiveText,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorOnSurface,
                                    borderRadius: 10.0,
                                    fontSize: 16,
                                    color: Constants.colorPrimaryVariant))
                          ])),
                      const SizedBox(height: 25)
                    ]),
                  )),
              onWillPop: () async => false);
        });
  }

  void showVoteDialogue( {Function? positiveClickListener,Function? negativeClickListener}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  backgroundColor: Constants.colorPrimaryVariant.withOpacity(0.9),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Constants.scaffoldColor)),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        alignment: Alignment.center,
                        child: Image.asset('assets/vote_big.png', height: 60, width: 60,),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: Divider( color: Constants.colorOnSurface,),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Are You Sure you want to", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 20, color: Constants.colorOnSurface))),
                       Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Vote for ", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 20, color: Constants.colorOnSurface)),
                              Text("Designer's ", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 20, color: Constants.colorPrimary)),
                            ],
                          )),
                      const SizedBox(height: 40),
                      IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                                height: 35,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Constants.colorPrimary,
                                    )
                                ),
                                child: AppButton(
                                    onClick: () => Navigator.pop(context),
                                    text: AppText.NO,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorOnSurface,
                                    borderRadius: 20.0,
                                    fontSize: 16,
                                    color: Constants.colorPrimaryVariant)),
                            const SizedBox(width: 20),
                            SizedBox(
                                height: 35,
                                width: 120,
                                child: AppButton(
                                    onClick: () {
                                      Navigator.pop(context);
                                      positiveClickListener!.call();
                                    },
                                    text: AppText.YES,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorOnSurface,
                                    borderRadius: 20.0,
                                    fontSize: 16,
                                    color: Constants.colorPrimary))
                          ])),
                      const SizedBox(height: 25)
                    ]),
                  )),
              onWillPop: () async => false);
        });
  }

  void showLogOutDialogue( {Function? positiveClickListener,Function? negativeClickListener}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  backgroundColor: Constants.colorPrimaryVariant.withOpacity(0.9),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Constants.scaffoldColor)),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        alignment: Alignment.center,
                        child: Image.asset('assets/logout.png', height: 60, width: 60,),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: Divider( color: Constants.colorOnSurface,),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Are You Sure you want to\nLog Out", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 20, color: Constants.colorOnSurface))),

                      const SizedBox(height: 40),
                      IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                                height: 35,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Constants.colorPrimary,
                                    )
                                ),
                                child: AppButton(
                                    onClick: () => Navigator.pop(context),
                                    text: AppText.CANCEL,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorOnSurface,
                                    borderRadius: 20.0,
                                    fontSize: 16,
                                    color: Constants.colorPrimaryVariant)),
                            const SizedBox(width: 20),
                            Container(
                                height: 35,
                                width: 120,

                                child: AppButton(
                                    onClick: () {
                                      Navigator.pop(context);
                                      positiveClickListener!.call();
                                    },
                                    text: AppText.LOG_oUT,
                                    fontFamily: Constants.montserratRegular,
                                    textColor: Constants.colorOnSurface,
                                    borderRadius: 20.0,
                                    fontSize: 16,
                                    color: Constants.colorPrimary))
                          ])),
                      const SizedBox(height: 25)
                    ]),
                  )),
              onWillPop: () async => false);
        });
  }

  // void showMaterialDialogWithImageContent(String imagePath, String buttonText, MaterialDialogContent content, Function positiveClickListener, {Function? negativeClickListener, Widget? richText}) {
  //   final context = _context;
  //   if (context == null) return;
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return WillPopScope(
  //             child: AlertDialog(
  //                 insetPadding: const EdgeInsets.symmetric(horizontal: 25),
  //                 contentPadding: const EdgeInsets.only(bottom: 0),
  //                 shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
  //                 content: Container(
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
  //                   child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
  //                     const SizedBox(height: 30),
  //                     Image(image: AssetImage(imagePath), width: MediaQuery.of(context).size.width - 150),
  //                     const SizedBox(height: 20),
  //                     Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20),
  //                         child: Text(content.title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: Constants.montserratMedium, fontSize: 18, color: Constants.colorPrimary))),
  //                     const SizedBox(height: 10),
  //                     Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 45),
  //                         child: richText ?? Text(content.message, textAlign: TextAlign.center, style: const TextStyle(color: Constants.colorSurface, fontSize: 16, fontFamily: Constants.montserratMedium))),
  //                     const SizedBox(height: 20),
  //                     IntrinsicHeight(
  //                         child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
  //                           SizedBox(
  //                               height: 35,
  //                               width: 100,
  //                               child: AppButton(
  //                                   onClick: () {
  //                                     Navigator.pop(context);
  //                                     positiveClickListener.call();
  //                                   },
  //                                   text: buttonText,
  //                                   fontFamily: Constants.montserratRegular,
  //                                   textColor: Constants.colorOnSurface,
  //                                   borderRadius: 10.0,
  //                                   fontSize: 16,
  //                                   color: Constants.colorPrimary))
  //                         ])),
  //                     const SizedBox(height: 25)
  //                   ]),
  //                 )),
  //             onWillPop: () async => false);
  //       });
  // }
}