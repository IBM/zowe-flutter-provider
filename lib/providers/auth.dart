
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:zowe_flutter/models/user.dart';
import 'package:zowe_flutter/services/api.dart';

enum AuthStatus { Unauthenticated, Authenticating, Authenticated }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.Unauthenticated;
  User _user = User.initial();

  AuthProvider.instance();

  AuthStatus get status => _status;
  User get user => _user;

  Future<bool> login(String userId, String password) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();

    // Data that will be sent
    var data = {'username': userId.toUpperCase(), 'password': password};

    // Tell the server we are sending a json body
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Send credentials as JSON and asnyc wait for the response.
    var response = await ApiService.ioClient.post(ApiService.AUTH_ENDPOINT,
        headers: headers, body: jsonEncode(data));

    // Parse success field to determine if auth was succeeded.
    bool success = json.decode(response.body)['success'];
    if (!success) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return false;
    }

    // Create auth token and create User object.
    String rawUser = userId + ':' + password;
    List<int> bytes = utf8.encode(rawUser);
    String base64User = base64.encode(bytes);

    _user = User(userId: userId.toUpperCase(), token: base64User);
    _status = AuthStatus.Authenticated;
    notifyListeners();
    return true;
  }

  bool logout() {
    // Clear user data
    _user = null;
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
    return true;
  }
}