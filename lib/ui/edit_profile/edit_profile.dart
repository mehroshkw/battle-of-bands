import 'dart:io';

import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/common/custom_appbar.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile_bloc.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile_state.dart';
import 'package:battle_of_bands/util/app_strings.dart';
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
  static const String route = '/edit_profile_screen';

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
      response.status
          ? snackbarHelper.showSnackbar(
              snackbar:
                  SnackbarMessage.success(message: AppText.PROFILE_UPDATED))
          : snackbarHelper.showSnackbar(
              snackbar: SnackbarMessage.error(message: response.message));
      Navigator.pop(context, true);
    } catch (e, s) {
      print(e);
      print(s);
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
        appBar: const CustomAppbar(
          screenName: AppText.EDIT_PROFILE,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    children: [
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
                                    '$BASE_URL_IMAGE/${state.imageUrl}');
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
                                        width: 2,
                                        color: Constants.colorPrimary),
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
                                    color: Constants.colorOnPrimary, size: 16),
                              )))
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.FULL_NAME,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: "Diana Agron",
                    controller: bloc.nameController,
                    textInputType: TextInputType.text,
                    isError: false,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.DOB,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (_, state) =>  SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: '25 July 1996',
                    textInputType: TextInputType.datetime,
                    controller: bloc.dobController,
                    isError: false,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.EMAIL_ADDRESS,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (_, state) =>  SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.USER_EMAIL,
                    textInputType: TextInputType.emailAddress,
                    controller: bloc.emailController,
                    isError: false,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 50,
                width: size.width,
                child: AppButton(
                  text: AppText.SAVE,
                  onClick: () {
                    context.unfocus();
                    _updatedProfile(context, bloc);
                  },
                  color: Constants.colorPrimary,
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> getImg() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
  }
}
