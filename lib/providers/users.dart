import 'package:flutter/cupertino.dart';
import 'package:share_learning/data/session_api.dart';
import 'package:share_learning/data/user_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';

class Users with ChangeNotifier {
  Users(this._session);
  // List<User> _users = [
  //   User(
  //     id: '0',
  //     firstName: 'Rahul',
  //     lastName: 'Rimal',
  //     userName: 'RahulR',
  //     password: '123',
  //     image:
  //         'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
  //   ),
  //   User(
  //     id: '1',
  //     firstName: 'Surendra',
  //     lastName: 'Jha',
  //     userName: 'SJha',
  //     password: '123',
  //     image:
  //         'https://cdn.pixabay.com/photo/2021/08/10/18/32/cat-6536684__340.jpg',
  //   ),
  //   User(
  //     id: '2',
  //     firstName: 'Krishna Pd.',
  //     lastName: 'Rimal',
  //     userName: 'KrishR',
  //     password: '123',
  //     image:
  //         'https://cdn.pixabay.com/photo/2021/06/25/17/51/ladybug-6364312__340.jpg',
  //   ),
  // ];

  List<User> _users = [];

  // final Session _session;

  Session? _session;

  // late User _user;
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
    // notifyListeners();
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
}
