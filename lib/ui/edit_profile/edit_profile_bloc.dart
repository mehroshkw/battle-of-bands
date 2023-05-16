import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../backend/shared_web_services.dart';
import '../../backend/server_response.dart';
import '../../data/exception.dart';
import '../../data/meta_data.dart';
import '../../helper/shared_preference_helper.dart';
import 'edit_profile_state.dart';


class EditProfileBloc extends Cubit<EditProfileState> {
  EditProfileBloc() : super(const EditProfileState.initial()){getProfileData();}
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();

  void updateEmailError(bool value, String errorText) => emit(state.copyWith(emailError: value, errorText: errorText));

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));

// get user from shared preferences
  getProfileData() async {
    final user = await sharedPreferenceHelper.user;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.emailAddress;
      dobController.text = user.dateOfBirth;
      emit(state.copyWith(imageUrl: user.imagePath));
    }
  }

  void handleImageSelection(XFile file) =>
      emit(state.copyWith(fileDataEvent: Data(data: file)));

  Future<IBaseResponse> updateProfile() async {
    final previousUser = await sharedPreferenceHelper.user;
    if (previousUser == null) throw const IdNotFoundException();
    final name = nameController.text;
    final email = emailController.text;
    final dob = dobController.text;
    final imageDataEvent = state.fileDataEvent;
    String imagePath = '';
    if (imageDataEvent is Data) {
      XFile file = imageDataEvent.data as XFile;
      imagePath = file.path;
    }
    final response = await _sharedWebService.updateProfile(previousUser.id.toString(),name,email, dob, imagePath);
    if (response.status && response.user != null) {
      await sharedPreferenceHelper.insertUser(response.user!);
    }
    return response;
  }


  @override
  Future<void> close() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    return super.close();
  }
}



