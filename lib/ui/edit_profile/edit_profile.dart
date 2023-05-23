import 'dart:io';
import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/common/custom_appbar.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile_bloc.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile_state.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../util/constants.dart';
import '../../data/meta_data.dart';
import '../../data/snackbar_message.dart';
import '../../helper/dilogue_helper.dart';
import '../../helper/material_dialogue_content.dart';
import '../../helper/snackbar_helper.dart';

class EditProfile extends StatelessWidget {
  static const String route = 'edit_profile_screen';

  const EditProfile({Key? key}) : super(key: key);

  Future<void> _updatedProfile(
      BuildContext context, EditProfileBloc bloc) async {
    final dialogHelper = MaterialDialogHelper.instance()
      ..injectContext(context)
      ..showProgressDialog(AppText.UPDATING_PROFILE);
    try {
      final response = await bloc.updateProfile();
      dialogHelper.dismissProgress();
      final snackbarHelper = SnackbarHelper.instance..injectContext(context);
      if (!response.status) {
        snackbarHelper.showSnackbar(
            snackbar: SnackbarMessage.error(message: response.message));
        return;
      }
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(message: AppText.PROFILE_UPDATED));
      Navigator.pop(context, true);
    } catch (_) {
      dialogHelper
        ..dismissProgress()
        ..showMaterialDialogWithContent(MaterialDialogContent.networkError(),
            () => _updatedProfile(context, bloc));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<EditProfileBloc>();

    return Scaffold(
        appBar: const CustomAppbar(screenName: AppText.EDIT_PROFILE),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(children: [
                    BlocBuilder<EditProfileBloc, EditProfileState>(
                        buildWhen: (previous, current) =>
                            previous.fileDataEvent != current.fileDataEvent ||
                            previous.imageUrl != current.imageUrl,
                        builder: (_, state) {
                          final eventData = state.fileDataEvent;
                          ImageProvider image;
                          if (eventData is! Data) {
                            if (state.imageUrl.isNotEmpty) {
                              image = NetworkImage(
                                  '$BASE_URL_DATA/${state.imageUrl}');
                            } else {
                              image = const AssetImage('assets/profile.png');
                            }
                          } else {
                            final imageData = eventData.data as XFile;
                            image = FileImage(File(imageData.path));
                          }
                          return Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Constants.colorPrimary),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: image, fit: BoxFit.cover)));
                        }),
                    Positioned(
                        right: 3,
                        bottom: 0,
                        child: GestureDetector(
                            onTap: () async {
                              final selectedImage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage == null) return;
                              bloc.handleImageSelection(selectedImage);
                            },
                            child: Container(
                                height: 30,
                                width: 30,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Constants.colorPrimary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Constants.colorPrimary,
                                        width: 1)),
                                child: const Icon(Icons.camera_alt,
                                    color: Constants.colorOnPrimary,
                                    size: 16))))
                  ])),
              const SizedBox(height: 30),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.FULL_NAME,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratRegular,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                      hint: "Diana Agron",
                      controller: bloc.nameController,
                      textInputType: TextInputType.text,
                      isError: false)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.DOB,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratRegular,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (previous, current) =>
                      previous.dobError != current.dobError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          hint: AppText.Enter_DOB,
                          readOnly: true,
                          enabled: false,
                          controller: bloc.dobController,
                          textInputType: TextInputType.datetime,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.dobError) {
                              bloc.updateDOBError(false, '');
                            }
                          },
                          isError: state.dobError,
                          // isError: false,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset('assets/3x/calendar.png',
                                height: 20, width: 20),
                          ),
                          onSuffixClick: () async {
                            context.unfocus();
                            final currentDatetime = DateTime.now();
                            if (Platform.isAndroid) {
                              final dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1980),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                      data: Theme.of(context), child: child!));
                              if (dateTime == null) return;
                              bloc.handleDateFromDate(dateTime);
                            } else {
                              showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  builder: (_) => CupertinoDatePicker(
                                      backgroundColor: Constants.scaffoldColor,
                                      onDateTimeChanged:
                                          bloc.handleDateFromDate,
                                      maximumDate: DateTime(
                                          currentDatetime.year,
                                          currentDatetime.month,
                                          currentDatetime.day - 1),
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime:
                                          DateTime(currentDatetime.year - 2)));
                            }
                          },
                          textInputAction: TextInputAction.done))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.EMAIL_ADDRESS,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratRegular,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.USER_EMAIL,
                    textInputType: TextInputType.emailAddress,
                    controller: bloc.emailController,
                    isError: false,
                    readOnly: true,
                    enabled: false,
                  )),
              const SizedBox(height: 20),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (previous, current) =>
                  previous.errorText != current.errorText,
                  builder: (_, state) {
                    if (state.errorText.isEmpty) return const SizedBox();
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Constants.colorError)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Constants.colorError),
                              const SizedBox(width: 5),
                              Text(state.errorText,
                                  style: const TextStyle(
                                      color: Constants.colorError,
                                      fontFamily: Constants.montserratRegular,
                                      fontSize: 12))
                            ]));
                  }),
              const SizedBox(height: 20),
              SizedBox(
                  height: 50,
                  width: size.width,
                  child: AppButton(
                      text: AppText.SAVE,
                      onClick: () {
                        context.unfocus();
                        final name = bloc.nameController.text;
                        if (name.isEmpty) {
                          bloc.updateEmailError(
                              true, AppText.EMAIL_FIELD_CANNOT_BE_EMPTY);
                          return;
                        }
                        if (bloc.dobController.text.isEmpty) {
                          bloc.updateDOBError(true, AppText.DOB_EMPTY);
                          return;
                        }

                        _updatedProfile(context, bloc);
                      },
                      color: Constants.colorPrimary))
            ])));
  }

  Future<void> getImg() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
  }
}
