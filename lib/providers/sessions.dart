import 'package:flutter/material.dart';
import 'package:share_learning/data/session_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';

class SessionProvider with ChangeNotifier {
  // List<Session> _sessions = [];
  bool _loading = false;
  // late Session _session;
  Session? _session;
  CustomSessionError? _sessionError;

  bool get loading => _loading;

  Session? get session => _session;

  CustomSessionError? get sessionError => _sessionError;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setSession(Session session) {
    _session = session;
    // notifyListeners();
  }

  setSessionError(CustomSessionError sessionError) {
    _sessionError = sessionError;
  }

  Future<bool> createSession(String userName, String password) async {
    setLoading(true);
    var response = await SessionApi.postSession(userName, password);
    if (response is Success) {
      // setSession(response.response as Session);
      setSession(response.response as Session);
      setLoading(false);
      return true;
    }
    if (response is Failure) {
      CustomSessionError sessionError = CustomSessionError(
        code: response.code,
        message: response.errorResponse,
      );
      setSessionError(sessionError);
      // setSessionError(sessionError as CustomSessionError);
      // sessionError.showErrorMessage();
      setLoading(false);
      return false;
    }
    return false;
  }

  Future<bool> getPreviousSession(String accessToken) async {
    setLoading(true);
    var response = await SessionApi.getPreviousSession(accessToken);
    if (response is Success) {
      setSession(response.response as Session);
      setLoading(false);
      return true;
    }
    if (response is Failure) {
      CustomSessionError sessionError = CustomSessionError(
        code: response.code,
        message: response.errorResponse,
      );
      setSessionError(sessionError);
      // setSessionError(sessionError as CustomSessionError);
      // sessionError.showErrorMessage();
      setLoading(false);
      return false;
    }
    return false;
  }
}
