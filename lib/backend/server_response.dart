const String BASE_URL_DATA = 'http://battleofbands.triaxo.com';

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

  factory LoginAuthenticationResponse.fromJson(Map<String, dynamic> json) {
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

class AddSongResponse extends StatusMessageResponse {
  final Song? songs;

  AddSongResponse(this.songs, bool status, String message)
      : super(status: status, message: message);

  factory AddSongResponse.fromJson(Map<String, dynamic> json) {
    final statusMessageResponse = StatusMessageResponse.fromJson(json);
    final songsJson =
        json.containsKey('data') ? json['data'] as Map<String, dynamic>? : null;
    return songsJson == null
        ? AddSongResponse(
            null, statusMessageResponse.status, statusMessageResponse.message)
        : AddSongResponse(Song.fromJson(songsJson),
            statusMessageResponse.status, statusMessageResponse.message);
  }
}

class LoginResponse {
  final int id;
  final String imagePath;
  final String name;
  final String dateOfBirth;
  final String emailAddress;

  LoginResponse(
      {required this.id,
      required this.imagePath,
      required this.name,
      required this.dateOfBirth,
      required this.emailAddress});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] : 0;
    final String imagePath =
        json.containsKey('imagePath') ? json['imagePath'] ?? '' : '';
    final String name =
        json.containsKey('fullName') ? json['fullName'] ?? '' : '';
    final String dateOfBirth = json.containsKey('dob') ? json['dob'] : '';
    final String emailAddress =
        json.containsKey('email') ? json['email'] ?? '' : '';
    return LoginResponse(
        id: id,
        imagePath: imagePath,
        name: name,
        dateOfBirth: dateOfBirth,
        emailAddress: emailAddress);
  }

  LoginResponse.empty()
      : this(id: 0, imagePath: '', name: '', dateOfBirth: '', emailAddress: '');

  LoginResponse copyWith(
          {String? imagePath,
          String? name,
          String? dateOfBirth,
          String? emailAddress}) =>
      LoginResponse(
          id: id,
          imagePath: imagePath ?? this.imagePath,
          name: name ?? this.name,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          emailAddress: emailAddress ?? this.emailAddress);

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'fullName': name,
        'dob': dateOfBirth,
        'email': emailAddress
      };
}

class Statistics {
  final int totalUploads;
  final int totalWins;
  final int totalLoses;
  final int totalBattles;

  Statistics(
      {required this.totalUploads,
      required this.totalWins,
      required this.totalBattles,
      required this.totalLoses});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    final int totalUploads =
        json.containsKey('totalUploads') ? json['totalUploads'] : 0;
    final int totalWins = json.containsKey('totalWins') ? json['totalWins'] : 0;
    final int totalLoses =
        json.containsKey('totalLosses') ? json['totalLosses'] : 0;
    final int totalBattles =
        json.containsKey('totalBattles') ? json['totalBattles'] : 0;

    return Statistics(
        totalBattles: totalBattles,
        totalLoses: totalLoses,
        totalUploads: totalUploads,
        totalWins: totalWins);
  }
}

class Song {
  final int id;
  final String title;
  final Genre genre;
  final String fileUrl;
  final String date;
  final int votesCount;
  final String bandName;
  final num duration;
  final Duration seekbar;
  final LoginResponse user;
  final bool isVoted;

  Song(
      {required this.id,
      required this.title,
      required this.genre,
      required this.date,
      required this.votesCount,
      required this.user,
      required this.bandName,
      required this.fileUrl,
      required this.duration,
        this.seekbar =const Duration(seconds: 0),
      required this.isVoted});

  factory Song.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] ?? 0 : 0;
    final String title = json.containsKey('title') ? json['title'] ?? '' : '';
    final String date = json.containsKey('date') ? (json['date']) ?? '' : '';
    final int votesCount =
        json.containsKey('votesCount') ? json['votesCount'] ?? 0 : 0;
    final String fileUrl =
        json.containsKey('fileUrl') ? json['fileUrl'] ?? '' : '';
    final String bandName =
        json.containsKey('bandName') ? json['bandName'] ?? '' : '';
    final num duration =
        json.containsKey('duration') ? json['duration'] ?? 0.0 : 0.0;
    final bool isVoted =
        json.containsKey('isVoted') ? json['isVoted'] ?? false : false;
    final Genre genre = json.containsKey('genre')
        ? Genre.fromJson(json['genre'] ?? Genre.empty())
        : Genre.empty();
    final LoginResponse user = LoginResponse.empty();
    return Song(
        id: id,
        title: title,
        votesCount: votesCount,
        date: date,
        genre: genre,
        fileUrl: fileUrl,
        user: user,
        bandName: bandName,
        duration: duration,
        isVoted: isVoted);
  }

  Song copyWith({int? votesCount, bool? isVoted, Duration? seekbar}) => Song(
      id: id,
      fileUrl: fileUrl,
      user: user,
      title: title,
      genre: genre,
      date: date,
      votesCount: votesCount ?? this.votesCount,
      bandName: bandName,
      duration: duration,
      isVoted: isVoted ?? this.isVoted,
      seekbar: seekbar ?? this.seekbar);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'votesCount': votesCount,
        'fileUrl': fileUrl,
        'bandName': bandName,
        'appUser': user,
        'duration': duration
      };
}

class Genre {
  final int id;
  final String title;
  final bool isActive;

  Genre({required this.id, required this.title, required this.isActive});

  Genre.empty() : this(id: 0, title: '', isActive: false);

  factory Genre.fromJson(Map<String, dynamic> json) {
    final int id = json.containsKey('id') ? json['id'] ?? -1 : -1;
    final String title = json.containsKey('title') ? json['title'] ?? '' : '';
    final bool isActive =
        json.containsKey('isActive') ? json['isActive'] ?? true : true;

    return Genre(id: id, title: title, isActive: isActive);
  }
}
