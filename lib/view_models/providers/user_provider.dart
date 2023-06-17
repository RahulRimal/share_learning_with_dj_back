import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_learning/data/session_api.dart';
import 'package:share_learning/data/user_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';

import '../base_view_model.dart';
import '../user_view_model.dart';

class UserProvider
    with
        ChangeNotifier,
        BaseViewModel,
        UserProfileScreenViewModel,
        UserProfileEditScreenViewModel,
        LoginScreenViewModel,
        SignUpScreenViewModel,
        UserInterestsScreenViewModel,
        AppDrawerViewModel,
        BillingInfoViewModel {
  UserProvider(this._session);

  List<User> _users = [];

  Session? _session;

  User? _user;
  bool _loading = false;
  UserError? _userError;

  bool get loading => _loading;

  User? get user {
    return _user;
  }

  List<User> get users => [..._users];

  Session? get session {
    return _session;
  }

  UserError? get userError {
    return _userError;
  }

  void setUser(User user) {
    _user = user;
  }

  void setUsers(List<User> users) {
    _users = users;
  }

  void setLoading(bool loading) {
    _loading = loading;
    // notifyListeners();
  }

  void setUserError(UserError? userError) {
    _userError = userError;
  }

  getUserByToken(String accessToken) async {
    setLoading(true);

    var response = await UserApi.getUserFromToken(accessToken);
    // print(response);
    if (response is Success) {
      setUser(response.response as User);
      return user;
    }
    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      return userError;
    }
    setLoading(false);
    notifyListeners();
  }

  Future<User?> getUserById(String uId) async {
    if (users.contains((user) => user.id == uId)) {
      setUser(user as User);
      return user;
    }

    var response = await UserApi.getUserFromId(uId);
    if (response is Success) {
      // setUser(response.response as User);
      return response.response as User;
    }

    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      return User(
        id: '0',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phone: null,
        image: null,
        description: '',
        userClass: '',
        followers: '',
        createdDate: DateTime.now(),
      );
    }

    return User(
      id: '0',
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      phone: null,
      image: null,
      description: '',
      userClass: '',
      followers: '',
      createdDate: DateTime.now(),
    );
  }

  Future<User?> getCommentUser(String userId) async {
    if (users.contains((user) => user.id == userId)) {
      return user as User;
    }

    var response = await UserApi.getUserFromId(userId);
    if (response is Success) {
      return response.response as User;
    }
    return null;
  }

  logoutUser(String sessionId) async {
    await SessionApi.deleteSession(sessionId);
    _session = null;
    _user = null;
    setUsers([]);
    notifyListeners();
  }

  Future<bool> createNewUser(User user, String password) async {
    setLoading(true);
    var response = await UserApi.createUser(user, password);
    // print(response);
    if (response is Success) {
      setUser(response.response as User);
      setLoading(false);
      return true;
    }
    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      setLoading(false);
      return false;
    }
    return false;
  }

  Future<bool> updatePicture(Session userSession, User user) async {
    setLoading(true);
    var response = await UserApi.postUserPic(userSession, user);
    if (response is Success) {
      setUser(response.response as User);
      setLoading(false);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      setLoading(false);
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> updateUserInfo(
      Session currentSession, Map<String, dynamic> edittedInfo) async {
    var response = await UserApi.updateUserInfo(currentSession, edittedInfo);
    // print(response);
    if (response is Success) {
      setUser(response.response as User);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<Object> updateUserData(
      String userId, String key, List<String> value) async {
    var response = await UserApi.updateUserData(userId, key, value);

    return response;
  }

  Future<bool> haveProvidedData(String userId) async {
    var response = await UserApi.haveProvidedData(userId);

    if (response is Success) {
      return true;
    }

    return false;
  }

  Future<bool> updateProfilePicture(
      Session userSession, String userId, XFile image) async {
    setLoading(true);
    var response = await UserApi.postUserPicture(userSession, userId, image);

    if (response is Success) {
      setUser(response.response as User);
      setLoading(false);
      notifyListeners();
      return true;
    }

    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      setLoading(false);
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<Object> googleSignIn() async {
    var response = await UserApi.googleSignIn();
    // print(response);
    if (response is Success) {
      setUser((response.response as Map)['user']);
      notifyListeners();
      return response;
    }
    if (response is Failure) {
      UserError userError = UserError(
        code: response.code,
        message: response.errorResponse,
      );
      setUserError(userError);
      notifyListeners();
      return userError;
    }
    return response;
  }

  Future<bool> deleteAccount(Session userSession, String password) async {
    var response = await UserApi.deleteUser(userSession, password);
    // print(response);
    if (response is Success) {
      // final postIndex = _cartItems
      //     .indexWhere((element) => element.id == int.parse(cartItemId));
      // // _cartItems.removeAt(postIndex);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      notifyListeners();
    }
    return false;
  }
}
