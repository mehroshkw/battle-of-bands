import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../data/exception.dart';
import '../helper/shared_preference_helper.dart';
import 'server_response.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SharedWebService {
  static const String _BASE_URL = 'http://serverlink.com/api';

  final HttpClient _client = HttpClient();
  final Duration _timeoutDuration = const Duration(seconds: 20);
  final SharedPreferenceHelper _sharedPrefHelper = SharedPreferenceHelper.instance();

  Future<LoginResponse?> get _loginResponse => _sharedPrefHelper.user;
  static SharedWebService? _instance;

  SharedWebService._();

  static SharedWebService instance() {
    _instance ??= SharedWebService._();
    return _instance!;
  }

  Future<HttpClientResponse> _responseFrom(Future<HttpClientRequest> Function(Uri) toCall,
          {required Uri uri, Map<String, dynamic>? body, Map<String, String>? headers}) =>
      toCall(uri).then((request) {
        if (headers != null) {
          headers.forEach((key, value) => request.headers.add(key, value));
        }
        if (request.method == 'POST' && body != null) {
          request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
          request.add(utf8.encode(json.encode(body)));
        }
        return request.close();
      }).timeout(_timeoutDuration);

  Future<HttpClientResponse> _get(Uri uri, [Map<String, String>? headers]) => _responseFrom(_client.getUrl, uri: uri, headers: headers);

  Future<HttpClientResponse> _post(Uri uri, [Map<String, dynamic>? body, Map<String, String>? headers]) =>
      _responseFrom(_client.postUrl, uri: uri, body: body, headers: headers);

  Future<LoginAuthenticationResponse> signup(String name, String email, String password, String dob) async {
    final response = await _post(Uri.parse('$_BASE_URL/Account/SignUp'), {'fullName': name, 'email': email, 'password': password, 'dob': dob});
    final responseBody = await response.transform(utf8.decoder).join();
    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  /// Login user
  Future<LoginAuthenticationResponse> login(String email, String password) async {
    final response = await _post(Uri.parse('$_BASE_URL/Account/Login'), {'email': email, 'password': password});
    final responseBody = await response.transform(utf8.decoder).join();
    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  /// forget password
  Future<LoginAuthenticationResponse> forgetPassword(String email) async {
    final response = await _post(Uri.parse('$_BASE_URL/Account/ForgetPassword'), {'email': email});
    final responseBody = await response.transform(utf8.decoder).join();
    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  /// Change Password
  Future<IBaseResponse> changePassword(String currentPassword, String newPassword) async {
    final loginResponse = await _loginResponse;
    if (loginResponse == null) throw const IdNotFoundException();
    final response = await _post(
        Uri.parse('$_BASE_URL/Account/ChangePassword'), {'appUserId': loginResponse.id, 'oldPassword': currentPassword, 'newPassword': newPassword});
    final responseBody = await response.transform(utf8.decoder).join();
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  /// Edit Profile
  Future<LoginAuthenticationResponse> updateProfile(String id, String name, String email, String dob, String image) async {
    final headers = {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'};
    final body = {'id': id, 'fullName': name, 'email': email, 'dob': dob};
    final uri = Uri.parse('$_BASE_URL/Account/ProfileUpdate');
    final request = http.MultipartRequest('POST', uri);
    if (image.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('image', image);
      request.files.add(imageFile);
    }
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return LoginAuthenticationResponse.fromJson(json.decode(responseData));
  }

  /// get statistics
  Future<Statistics> getStatistics(int userId) async {
    final uri = Uri.parse('$_BASE_URL/Dashboard/GetStatistics?appUserId=$userId');
    final response = await _get(uri);
    final responseBody = json.decode(await response.transform(utf8.decoder).join());
    return Statistics.fromJson(responseBody);
  }

  /// get genre
  Future<List<Genre>> getAllGenre() async {
    final uri = Uri.parse('$_BASE_URL/Genre/GetAllGenre');
    final response = await _get(uri);
    final responseBody = json.decode(await response.transform(utf8.decoder).join());
    return (responseBody as List<dynamic>).map((e) => Genre.fromJson(e)).toList();
  }

  /// get Leaderboard/ winners
  Future<List<Song>> getLeaderboard(int genreId, int userId) async {
    final uri = Uri.parse('$_BASE_URL/Dashboard/GetLeaderboard?appUserId=$userId&genreId=$genreId');
    final response = await _get(uri);
    final responseBody = json.decode(await response.transform(utf8.decoder).join());
    return (responseBody as List<dynamic>).map((e) => Song.fromJson(e)).toList();
  }

  /// get all my songs
  Future<List<Song>> getAllMySongs(int genreId, int userId) async {
    final uri = Uri.parse('$_BASE_URL/Song/GetAllMySongs?appUserId=$userId&genreId=$genreId');
    final response = await _get(uri);
    final responseBody = json.decode(await response.transform(utf8.decoder).join());
    return (responseBody as List<dynamic>).map((e) => Song.fromJson(e)).toList();
  }

  /// get All Songs
  Future<List<Song>> getAllSongs(int genreId, int userId) async {
    print('userId: $userId, genrerId $genreId');
    final uri = Uri.parse('$_BASE_URL/Song/GetAllSongByGenreId?appUserId=$userId&genreId=$genreId');
    final response = await _get(uri);
    final responseBody = json.decode(await response.transform(utf8.decoder).join());
    final finalResponse = (responseBody as List<dynamic>).map((e) => Song.fromJson(e)).toList();
    print('responsebody ==========> $finalResponse');
    return (responseBody as List<dynamic>).map((e) => Song.fromJson(e)).toList();
  }

  /// vote song
  Future<void> voteSong(int songId, int userId, bool isVoted, int losserSongId) => _post(Uri.parse('$_BASE_URL/Song/Vote'), {
        'songId': songId,
        'appUse'
            'rId': userId,
        'isVoted': isVoted,
        'losserSongId': losserSongId
      });

  /// upload song
  Future<AddSongResponse> addSong(Map<String, String> body, String song) async {
    final headers = {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'};
    final uri = Uri.parse('$_BASE_URL/Song/AddSong');
    final request = http.MultipartRequest('POST', uri);
    final uploadSong = await http.MultipartFile.fromPath('AudioFile', song);
    request.files.add(uploadSong);
    request.headers.addAll(headers);
    request.fields.addAll(body);
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    print('upload song---------------->$uploadSong');
    return AddSongResponse.fromJson(json.decode(responseData));
  }
}
