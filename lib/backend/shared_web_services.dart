import 'dart:convert';
import 'dart:io';
import '../data/exception.dart';
import '../helper/shared_preference_helper.dart';
import 'server_response.dart';
import 'package:http/http.dart' as http;

class SharedWebService {
  // final String BASE_URL = "http://reekrootsapi.triaxo.com/api";
  final String BASE_URL = "http://192.168.1.34:5069/api/";
  final HttpClient _client = HttpClient();
  final Duration _timeoutDuration = const Duration(seconds: 20);

  final SharedPreferenceHelper _sharedPrefHelper =
      SharedPreferenceHelper.instance();

  Future<LoginResponse?> get _loginResponse => _sharedPrefHelper.user;

  static SharedWebService? _instance;

  SharedWebService._();

  static SharedWebService instance() {
    _instance ??= SharedWebService._();
    return _instance!;
  }

  Future<HttpClientResponse> _responseFrom(
          Future<HttpClientRequest> Function(Uri) toCall,
          {required Uri uri,
          Map<String, dynamic>? body,
          Map<String, String>? headers}) =>
      toCall(uri).then((request) {
        if (headers != null) {
          headers.forEach((key, value) => request.headers.add(key, value));
        }
        if (request.method == 'POST' && body != null) {
          request.headers.contentType =
              ContentType('application', 'json', charset: 'utf-8');
          request.add(utf8.encode(json.encode(body)));
        }
        return request.close();
      }).timeout(_timeoutDuration);

  Future<HttpClientResponse> _get(Uri uri, [Map<String, String>? headers]) =>
      _responseFrom(_client.getUrl, uri: uri, headers: headers);

  Future<HttpClientResponse> _post(Uri uri,
          [Map<String, dynamic>? body, Map<String, String>? headers]) =>
      _responseFrom(_client.postUrl, uri: uri, body: body, headers: headers);

  /// Login user
  Future<LoginAuthenticationResponse> login(
      String email, String password) async {
    final response = await _post(Uri.parse("$BASE_URL/Accounts/Login"),
        {'email': email, 'password': password});

    final responseBody = await response.transform(utf8.decoder).join();
    final data =
        LoginAuthenticationResponse.fromJson(json.decode(responseBody));

    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  /// Change Password
  Future<IBaseResponse> changePassword(
      String currentPassword, String newPassword) async {
    final loginResponse = await _loginResponse;
    if (loginResponse == null) throw const IdNotFoundException();
    final response =
        await _post(Uri.parse('$BASE_URL/Accounts/ChangePassword'), {
      'userId': loginResponse.id,
      'currentPassword': currentPassword,
      'newPassword': newPassword
    });
    final responseBody = await response.transform(utf8.decoder).join();
    return StatusMessageResponse.fromJson(json.decode(responseBody));
  }

  /// Edit Profile
  Future<LoginAuthenticationResponse> editProfile(
      String? id,
      String name,
      String schoolName,
      String email,
      String userName,
      String password,
      String imagePath) async {
    final body = {
      'id': id,
      'name': name,
      'schoolName': schoolName,
      'email': email,
      'userName': userName,
      'password': password,
      'imagePath': imagePath,
    };
    final uri = Uri.parse('$BASE_URL/Accounts/UpdateUser');
    final response = await _post(uri, body);
    final responseBody = await response.transform(utf8.decoder).join();
    return LoginAuthenticationResponse.fromJson(json.decode(responseBody));
  }

  Future<Statistics> getStatistics(int userId) async {
    final uri = Uri.parse('${BASE_URL}Dashboard/GetStatistics?appUserId=$userId');
    final response = await _get(uri);
    final responseBody=json.decode(await response.transform(utf8.decoder).join());
    print('responsebody==========>$responseBody');
    return Statistics.fromJson(responseBody);
  }
}


