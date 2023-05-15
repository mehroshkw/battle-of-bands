import 'dart:io';
import 'package:battle_of_bands/extension/primitive_extension.dart';

// const String BASE_URL_IMAGE = "http://reekrootsapi.triaxo.com";
const String BASE_URL_IMAGE = 'http://192.168.1.2:5069';

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
  StatusMessageResponse({required bool status, required String message}) : super(status, message);

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

  LoginAuthenticationResponse(this.user, bool status, String message) : super(status: status, message: message);

  factory LoginAuthenticationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final userJson = json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return userJson == null
        ? LoginAuthenticationResponse(null, statusMessageResponse.status, statusMessageResponse.message)
        : LoginAuthenticationResponse(LoginResponse.fromJson(userJson), statusMessageResponse.status, statusMessageResponse.message);
  }
}

class AddSongResponse extends StatusMessageResponse {
  final SongResponse? songs;

  AddSongResponse(this.songs, bool status, String message)
      : super(status: status, message: message);

  factory AddSongResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final notesJson =
    json.containsKey('dataList') ? json['dataList'] as Map<String, dynamic>? : null;
    return notesJson == null
        ? AddSongResponse(
        null, statusMessageResponse.status, statusMessageResponse.message)
        : AddSongResponse(SongResponse.fromJson(notesJson),
        statusMessageResponse.status, statusMessageResponse.message);
  }
}

class LoginResponse {
  final int id;
  final String imagePath;
  final String name;
  final String dateOfBirth;
  final String emailAddress;

  LoginResponse({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.dateOfBirth,
    required this.emailAddress,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] : 0;
    final String imagePath = json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String name = json.containsKey('fullName') ? json['fullName'] ?? '' : '';
    final String dateOfBirth = json.containsKey('dob') ? json['dob'] : '';
    final String emailAddress = json.containsKey('email') ? json['email'] ?? '' : '';

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

class Statistics {
  final int totalUploads;
  final int totalWins;
  final int totalLoses;
  final int totalBattles;

  Statistics({required this.totalUploads, required this.totalWins, required this.totalBattles, required this.totalLoses});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    final int totalUploads = json.containsKey('totalUploads') ? json['totalUploads'] : 0;
    final int totalWins = json.containsKey('totalWins') ? json['totalWins'] : 0;
    final int totalLoses = json.containsKey('totalLosses') ? json['totalLosses'] : 0;
    final int totalBattles = json.containsKey('totalBattles') ? json['totalBattles'] : 0;

    return Statistics(totalBattles: totalBattles, totalLoses: totalLoses, totalUploads: totalUploads, totalWins: totalWins);
  }
}

class SongResponse {
  final int id;
  final String title;
  final String bandName;
  final String audioFile;
  final DateTime date;
  final File fileUrl;
  final String externalUrl;
  final String genreIds;
  final int votesCount;
  final dynamic playerId;

  SongResponse({
    required this.audioFile,
    required this.id,
    required this.title,
    required this.bandName,
    required this.date,
    required this.fileUrl,
    required this.externalUrl,
    required this.genreIds,
    required this.playerId,
    required this.votesCount,
  });

  factory SongResponse.fromJson(Map<String, dynamic> json) {

    final int id = json.containsKey('id') ? json['id'] : -1;
    final String title = json.containsKey('title') ? json['title'] ?? '' : '';
    final String bandName = json.containsKey('bandName') ? json['bandName'] ?? '' : '';
    final String audioFile = json.containsKey('audioFile') ? json['audioFile'] ?? '' : '';
    final String date = json.containsKey('date') ? json['date'] ?? '' : '';
    final String audioUrl = json.containsKey('fileUrl') ? json['fileUrl'] ?? '' : '';
    final String externalUrl = json.containsKey('externalUrl') ? json['externalUrl'] ?? '' : '';
    final String genreIds = json.containsKey('genreIds') ? json['genreIds'] ?? '' : '';
    final int votesCount = json.containsKey('votesCount') ? json['votesCount'] ?? '' : '';
    final dynamic playerId = json.containsKey('playerId') ? json['playerId'] ?? '' : '';

    final File fileUrl = audioUrl.isNotEmpty ? File(audioUrl) : File('');

    return SongResponse(
      id: id,
      title: title,
      audioFile: audioFile,
      externalUrl: externalUrl,
      bandName: bandName,
      date: date.isNotEmpty?date.parsedDatetime:DateTime(2020),
      genreIds: genreIds,
      votesCount: votesCount,
      playerId: playerId,
      fileUrl: fileUrl,
    );
  }

  SongResponse copyWith({
    int? id,
    String? title,
    String? bandName,
    String? audioFile,
    String? externalUrl,
    File? fileUrl,
    String? genreIds,
    int? votesCount,
    dynamic playerId,
  }) =>
      SongResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        bandName: bandName ?? this.bandName,
        audioFile: audioFile ?? this.audioFile,
        externalUrl: externalUrl ?? this.externalUrl,
        date: date,
        fileUrl: fileUrl! ?? fileUrl,
        genreIds: genreIds ?? this.genreIds,
        votesCount: votesCount ?? this.votesCount,
        playerId: playerId ?? this.playerId,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'bandName': bandName,
    'audioFile': audioFile,
    'fileUrl': fileUrl,
    'externalUrl': externalUrl,
    'date': date,
    'genreIds': genreIds,
    'votesCount': votesCount,
    'playerId': playerId,
  };
}
