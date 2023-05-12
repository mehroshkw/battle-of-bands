import 'dart:io';

import 'package:battle_of_bands/extension/primitive_extension.dart';
 const String BASE_URL_IMAGE = "http://reekrootsapi.triaxo.com";

abstract class IBaseResponse {
  final bool status;
  final String message;

  IBaseResponse(this.status, this.message);

  @override
  String toString() {
    return 'IBaseResponse{status: $status, message: $message}';
  }
}

class StatusMessageResponse extends IBaseResponse {
  StatusMessageResponse({required bool status, required String message})
      : super(status, message);

  factory StatusMessageResponse.fromJson(Map<String, dynamic> json) {
    final bool status = json.containsKey('status') ? json['status'] : false;
    final String message = json.containsKey('message') ? json['message'] : '';
    return StatusMessageResponse(status: status, message: message);
  }

  @override
  String toString() {
    return 'StatusMessageResponse: {status: $status, message: $message}';
  }
}

class LoginAuthenticationResponse extends StatusMessageResponse {
  final LoginResponse? user;

  LoginAuthenticationResponse(this.user, bool status, String message)
      : super(status: status, message: message);

  factory LoginAuthenticationResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson =
    json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? LoginAuthenticationResponse(
        null, statusMessageResponse.status, statusMessageResponse.message)
        : LoginAuthenticationResponse(LoginResponse.fromJson(userJson),
        statusMessageResponse.status, statusMessageResponse.message);
  }
}

// class AddNotesResponse extends StatusMessageResponse {
//   final NotesResponse? notes;
//
//   AddNotesResponse(this.notes, bool status, String message)
//       : super(status: status, message: message);
//
//   factory AddNotesResponse.fromJson(
//       Map<String, dynamic> json,
//       ) {
//     final statusMessageResponse = StatusMessageResponse.fromJson(json);
//     final notesJson =
//     json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
//     return notesJson == null
//         ? AddNotesResponse(
//         null, statusMessageResponse.status, statusMessageResponse.message)
//         : AddNotesResponse(NotesResponse.fromJson(notesJson),
//         statusMessageResponse.status, statusMessageResponse.message);
//   }
// }
//
// class UserResponse extends StatusMessageResponse {
//   final Rekroot? rekroot;
//
//   UserResponse(this.rekroot, bool status, String message)
//       : super(status: status, message: message);
//
//   factory UserResponse.fromJson(Map<String, dynamic> json) {
//     final statusMessageResponse = StatusMessageResponse.fromJson(json);
//     final userJson = json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
//     return userJson == null
//         ? UserResponse(
//         null, statusMessageResponse.status, statusMessageResponse.message)
//         : UserResponse(Rekroot.fromJson(userJson),
//         statusMessageResponse.status, statusMessageResponse.message);
//   }
// }

class LoginResponse {
  final int id;
  final String imagePath;
  final String name;
  final String dateOfBirth;
  final String emailAddress;


  LoginResponse(
      {
        required this.id,
        required this.imagePath,
        required this.name,
        required this.dateOfBirth,
        required this.emailAddress,
      });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    print("id === -----------------------");

    final int id = json.containsKey('id') ? json['id'] : 0;
    print("id === $id");
    final String imagePath = json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String name = json.containsKey('fullName') ? json['fullName'] ?? '' : '';
    print("name === $name");
    final String dateOfBirth = json.containsKey('dob') ? json['dob'] : '';
    print("dob === $dateOfBirth");

    final String emailAddress = json.containsKey('email') ? json['email'] ?? '' : '';
    print("email === $emailAddress");



    return LoginResponse(
        id: id,
      imagePath: imagePath,
        name: name,
        dateOfBirth: dateOfBirth,
        emailAddress: emailAddress,
       );
  }

  LoginResponse copyWith(
      {
        String? imagePath,
        String? name,
        String? dateOfBirth,
        String? emailAddress,
      }) =>
      LoginResponse(
          id: id,
        imagePath: imagePath ?? this.imagePath,
          name: name ?? this.name,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          emailAddress: emailAddress ?? this.emailAddress,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'fullName': name,
    'dob': dateOfBirth,
    'email': emailAddress,
  };
}

class Singer {
  final int id;
  final String imagePath;
  final String firstName;
  final String lastName;
  final String position1;
  final String votes;
  final String emailAddress;
  final String performerName;
  final String bandName;
  final int zipCode;
  final String cityName;
  final String stateName;
  final String dateOfBirth;
  final String highSchool;
  final dynamic gpa;
  final dynamic height;
  final dynamic weight;
  final String dominantFoot;
  final String gender;
  final String socialMediaLink;
  dynamic rating;

  Singer({
    required this.id,
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.position1,
    required this.votes,
    required this.emailAddress,
    required this.performerName,
    required this.bandName,
    required this.zipCode,
    required this.cityName,
    required this.stateName,
    required this.dateOfBirth,
    required this.highSchool,
    required this.gpa,
    required this.height,
    required this.weight,
    required this.dominantFoot,
    required this.gender,
    required this.socialMediaLink,
    required this.rating
  });

  factory Singer.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] : 0;
    final String imagePath = json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String firstName = json.containsKey('firstName') ? json['firstName'] ?? '' : '';
    final String lastName = json.containsKey('lastName') ? json['lastName'] ?? '' : '';
    final String position1 = json.containsKey('position1') ? json['position1'] ?? '' : '';
    final String votes = json.containsKey('position2') ? json['position2'] ?? '' : '';
    final String emailAddress = json.containsKey('emailAddress') ? json['emailAddress'] ?? '' : '';
    final String performerName = json.containsKey('phoneNumber') ? json['phoneNumber'] ?? '' : '';
    final String bandName = json.containsKey('graduationYear') ? json['graduationYear'] ?? '' : '';
    final int zipCode = json.containsKey('zipCode') ? json['zipCode'] ?? 0.0 : '';
    final String cityName = json.containsKey('cityName') ? json['cityName'] ?? '' : '';
    final String stateName = json.containsKey('stateName') ? json['stateName'] ?? '' : '';
    final String dateOfBirth = json.containsKey('dateOfBirth') ? json['dateOfBirth'] ?? '' : '';
    final String highSchool = json.containsKey('highSchool') ? json['highSchool'] ?? '' : '';
    final dynamic gpa = json.containsKey('gpa') ? json['gpa'] ?? '' : 0.0;
    final dynamic height = json.containsKey('height') ? json['height'] ?? '' : 0.0;
    final dynamic weight = json.containsKey('weight') ? json['weight'] ?? '' : 0.0;
    final String dominantFoot = json.containsKey('dominantFoot') ? json['dominantFoot'] ?? '' : '';
    final String gender = json.containsKey('gender') ? json['gender'] ?? '' : '';
    final String socialMediaLink = json.containsKey('socialMediaLink') ? json['socialMediaLink'] ?? '' : '';
    final dynamic rating = json.containsKey('rating') ? json['rating'] ?? 0.0 : 0.0;


    return Singer(
      id: id,
      imagePath: imagePath,
      firstName: firstName,
      lastName: lastName,
      position1: position1,
      votes: votes,
      emailAddress: emailAddress,
      performerName: performerName,
      bandName: bandName,
      zipCode: zipCode,
      cityName: cityName,
      stateName: stateName,
      dateOfBirth:dateOfBirth,
      highSchool: highSchool,
      gpa: gpa,
      height: height,
      weight: weight,
      dominantFoot: dominantFoot,
      gender: gender,
      socialMediaLink: socialMediaLink,
      rating: rating,
    );
  }

  Singer copyWith(
      { String? image,
        String? firstName,
        String? lastName,
        String? position1,
        String? votes,
        String? emailAddress,
        String? performerName,
        String? bandName,
        String? cityName,
        String? stateName,
        String? dateOfBirth,
        String? highSchool,
        String? dominantFoot,
        String? gender,
        String? socialMediaLink,
        dynamic rating,
      }) =>
      Singer(
        id: id,
        imagePath: imagePath,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        position1: position1 ?? this.position1,
        votes: votes ?? this.votes,
        emailAddress: emailAddress ?? this.emailAddress,
        performerName: performerName ?? this.performerName,
        bandName: bandName ?? this.bandName,
        zipCode: zipCode,
        cityName: cityName ?? this.cityName,
        stateName: stateName ?? this.stateName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        highSchool: highSchool ?? this.highSchool,
        gpa:gpa,
        height: height ,
        weight: weight,
        dominantFoot: dominantFoot ?? this.dominantFoot,
        gender: gender ?? this.gender,
        socialMediaLink: socialMediaLink ?? this.socialMediaLink,
        rating: rating ?? this.rating,
      );

  Map<String, dynamic> toJson() => {
    'productId': id,
    'imagePath': imagePath,
    'firstName': firstName,
    'lastName': lastName,
    'position1': position1,
    'emailAddress': emailAddress,
    'performerName': performerName,
    'graduationYear': bandName,
    'zipCode': zipCode,
    'cityName': cityName,
    'stateName': stateName,
    'dateOfBirth': dateOfBirth,
    'location': highSchool,
    'gpa': gpa,
    'height': height,
    'weight': weight,
  };
}

class Song {
  final int id;
  final String imagePath;
  final String songName;
  final String genreName;
  final DateTime date;
  final String votes;
  final String emailAddress;
  final String performerName;
  final String bandName;
  final int zipCode;
  final String cityName;
  final String stateName;
  final String dateOfBirth;
  final String highSchool;
  final dynamic gpa;
  final dynamic height;
  final dynamic weight;
  final String dominantFoot;
  final String gender;
  final String socialMediaLink;
  dynamic rating;

  Song({
    required this.id,
    required this.imagePath,
    required this.songName,
    required this.genreName,
    required this.date,
    required this.votes,
    required this.emailAddress,
    required this.performerName,
    required this.bandName,
    required this.zipCode,
    required this.cityName,
    required this.stateName,
    required this.dateOfBirth,
    required this.highSchool,
    required this.gpa,
    required this.height,
    required this.weight,
    required this.dominantFoot,
    required this.gender,
    required this.socialMediaLink,
    required this.rating
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] : 0;
    final String imagePath = json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String songName = json.containsKey('songName') ? json['songName'] ?? '' : '';
    final String genreName = json.containsKey('genreName') ? json['genreName'] ?? '' : '';
    final String date = json.containsKey('position1') ? json['position1'] ?? '' : '';
    final String votes = json.containsKey('position2') ? json['position2'] ?? '' : '';
    final String emailAddress = json.containsKey('emailAddress') ? json['emailAddress'] ?? '' : '';
    final String performerName = json.containsKey('phoneNumber') ? json['phoneNumber'] ?? '' : '';
    final String bandName = json.containsKey('graduationYear') ? json['graduationYear'] ?? '' : '';
    final int zipCode = json.containsKey('zipCode') ? json['zipCode'] ?? 0.0 : '';
    final String cityName = json.containsKey('cityName') ? json['cityName'] ?? '' : '';
    final String stateName = json.containsKey('stateName') ? json['stateName'] ?? '' : '';
    final String dateOfBirth = json.containsKey('dateOfBirth') ? json['dateOfBirth'] ?? '' : '';
    final String highSchool = json.containsKey('highSchool') ? json['highSchool'] ?? '' : '';
    final dynamic gpa = json.containsKey('gpa') ? json['gpa'] ?? '' : 0.0;
    final dynamic height = json.containsKey('height') ? json['height'] ?? '' : 0.0;
    final dynamic weight = json.containsKey('weight') ? json['weight'] ?? '' : 0.0;
    final String dominantFoot = json.containsKey('dominantFoot') ? json['dominantFoot'] ?? '' : '';
    final String gender = json.containsKey('gender') ? json['gender'] ?? '' : '';
    final String socialMediaLink = json.containsKey('socialMediaLink') ? json['socialMediaLink'] ?? '' : '';
    final dynamic rating = json.containsKey('rating') ? json['rating'] ?? 0.0 : 0.0;


    return Song(
      id: id,
      imagePath: imagePath,
      songName: songName,
      genreName: genreName,
      date: date.isNotEmpty?date.parsedDatetime:DateTime(2020),
      votes: votes,
      emailAddress: emailAddress,
      performerName: performerName,
      bandName: bandName,
      zipCode: zipCode,
      cityName: cityName,
      stateName: stateName,
      dateOfBirth:dateOfBirth,
      highSchool: highSchool,
      gpa: gpa,
      height: height,
      weight: weight,
      dominantFoot: dominantFoot,
      gender: gender,
      socialMediaLink: socialMediaLink,
      rating: rating,
    );
  }

  Song copyWith(
      { String? image,
        String? songName,
        String? genreName,
        // String? date,
        String? votes,
        String? emailAddress,
        String? performerName,
        String? bandName,
        String? cityName,
        String? stateName,
        String? dateOfBirth,
        String? highSchool,
        String? dominantFoot,
        String? gender,
        String? socialMediaLink,
        dynamic rating,
      }) =>
      Song(
        id: id,
        imagePath: imagePath,
        songName: songName ?? this.songName,
        genreName: genreName ?? this.genreName,
        date: date,
        votes: votes ?? this.votes,
        emailAddress: emailAddress ?? this.emailAddress,
        performerName: performerName ?? this.performerName,
        bandName: bandName ?? this.bandName,
        zipCode: zipCode,
        cityName: cityName ?? this.cityName,
        stateName: stateName ?? this.stateName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        highSchool: highSchool ?? this.highSchool,
        gpa:gpa,
        height: height ,
        weight: weight,
        dominantFoot: dominantFoot ?? this.dominantFoot,
        gender: gender ?? this.gender,
        socialMediaLink: socialMediaLink ?? this.socialMediaLink,
        rating: rating ?? this.rating,
      );

  Map<String, dynamic> toJson() => {
    'productId': id,
    'imagePath': imagePath,
    'songName': songName,
    'genreName': genreName,
    'date': date,
    'emailAddress': emailAddress,
    'performerName': performerName,
    'graduationYear': bandName,
    'zipCode': zipCode,
    'cityName': cityName,
    'stateName': stateName,
    'dateOfBirth': dateOfBirth,
    'location': highSchool,
    'gpa': gpa,
    'height': height,
    'weight': weight,
  };
}

// class PlayersResponse {
//   final int playerId;
//   final int id;
//   final int teamId;
//   final Singer player;
//
//   PlayersResponse({
//     required this.playerId,
//     required this.id,
//     required this.teamId,
//     required this.player,
//   });
//
//   factory PlayersResponse.fromJson(Map<String, dynamic> json) {
//
//     final int playerId = json.containsKey('playerId') ? json['playerId'] : -1;
//     final int id = json.containsKey('id') ? json['id']  : -1;
//     final int teamId = json.containsKey('teamId') ? json['teamId'] : -1;
//     final Singer player = Singer.fromJson(json['player']);
//
//
//     return PlayersResponse(
//       playerId: playerId,
//       id: id,
//       teamId: teamId,
//       player:player,
//     );
//   }
//
//   PlayersResponse copyWith(
//       { Singer? player,
//       }) =>
//       PlayersResponse(
//         id: id,
//         playerId:playerId,
//         teamId: teamId,
//         player: player??this.player
//       );
//
//   Map<String, dynamic> toJson() => {
//     'playerId': playerId,
//     'id': id,
//     'teamId': teamId,
//     'player': player,
//
//   };
// }

