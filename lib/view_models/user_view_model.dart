import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/view_models/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_status.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/managers/color_manager.dart';
import '../templates/managers/font_manager.dart';
import '../templates/managers/style_manager.dart';
import '../templates/screens/home_screen_new.dart';
import '../templates/screens/login_screen.dart';
import '../templates/screens/user_interests_screen.dart';
import '../templates/utils/alert_helper.dart';
import '../templates/utils/system_helper.dart';

mixin UserProfileScreenViewModel on BaseViewModel {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool userProfileScreenUserDeletionConfirmed = false;
  bool userProfileScreenShowConfirmButton = false;
  User userProfileScreenEdittedUser = User(
    id: '',
    firstName: null,
    lastName: null,
    email: null,
    phone: null,
    image: null,
    description: null,
    userClass: null,
    username: null,
    followers: null,
    createdDate: null,
  );

  userProfileScreenLogOut(BuildContext context) async {
    SharedPreferences prefs = await prefences;
    bookProvider.setBooks([]);

    userProvider.logoutUser('1');
    commentProvider.setComments([]);
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  userProfileScreenDeleteUserAccount(String password) async {
    bool value = await userProvider.deleteAccount(
        sessionProvider.session as Session, password);
    if (value) {
      AlertHelper.showToastAlert('Account deleted successfully');
    } else
      AlertHelper.showToastAlert('Something went wrong, Please try again!');
  }

  bindUserProfileScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unbindUserProfileScreenViewModel() {}
}

mixin UserProfileEditScreenViewModel on BaseViewModel {
  XFile? userProfileScreenAddedImage;

  late FocusNode userProfileScreenFirstNameFocusNode;
  late FocusNode userProfileScreenLastNameFocusNode;
  late FocusNode userProfileScreenDescriptionFocusNode;
  late FocusNode userProfileScreenClassFocusNode;

  bool userProfileScreenShowLoading = false;
  ImagePicker userProfileScreenImagePicker = ImagePicker();

  bool userProfileScreenImageAdded = false;

  User userProfileScreenEdittedUser = User(
    id: '',
    firstName: null,
    lastName: null,
    email: null,
    phone: null,
    image: null,
    description: null,
    userClass: null,
    username: null,
    followers: null,
    createdDate: null,
  );

  bindUserProfileScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    userProfileScreenFirstNameFocusNode = FocusNode();
    userProfileScreenLastNameFocusNode = FocusNode();
    userProfileScreenDescriptionFocusNode = FocusNode();
    userProfileScreenClassFocusNode = FocusNode();
    if (userProvider.user != null)
      userProfileScreenEdittedUser = userProvider.user!;
  }

  unbindUserProfileScreenViewModel() {}

  Future<void> userProfileScreenGetPicture() async {
    final imageFiles = await userProfileScreenImagePicker.pickImage(
      maxWidth: 770,
      imageQuality: 100,
      source: ImageSource.gallery,
    );

    if (imageFiles == null) return;

    userProfileScreenAddedImage = imageFiles;

    // setState(() {
    // userProfileScreenSetImageAdded(true);
    userProfileScreenImageAdded = true;
    notifyListeners();
    // });
  }

  Future<bool> userProfileScreenUpdateProfile(
    GlobalKey<FormState> form,
  ) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    var oldUserMap = userProvider.user!.toMap();
    var edittedUserMap = userProfileScreenEdittedUser.toMap();

    Map<String, dynamic> changedValues =
        SystemHelper.getChangedValues(oldUserMap, edittedUserMap);

    changedValues['id'] = userProfileScreenEdittedUser.id;

    if (await userProvider.updateUserInfo(
        sessionProvider.session as Session, changedValues)) {
      if (userProfileScreenImageAdded) {
        if (!await userProvider.updateProfilePicture(
            sessionProvider.session as Session,
            userProfileScreenEdittedUser.id,
            userProfileScreenAddedImage as XFile)) {
          AlertHelper.showToastAlert('Something went worng, please try again');
        }
      }
      AlertHelper.showToastAlert(
        'Profile has been successfully updated',
      );

      return true;
    }

    if (userProvider.userError != null) {
      AlertHelper.showToastAlert(
        userProvider.userError!.message.toString(),
      );
    }
    AlertHelper.showToastAlert(
      'Something went wrong, please try again',
    );

    return true;
  }
}

mixin LoginScreenViewModel on BaseViewModel {
  FocusNode loginScreenPasswordFocusNode = FocusNode();
  // late FocusNode loginScreenPasswordFocusNode;

  var loginScreenUsernameOrEmail;
  var loginScreenUserpassword;
  bool loginScreenVisible = false;
  var loginScreenShowSpinner = false;

  String loginScreenLoginErrorText = '';

  bindLoginScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    // loginScreenPasswordFocusNode = FocusNode();
  }

  unbindLoginScreenViewModel() {
    loginScreenPasswordFocusNode.dispose();
  }

  loginScreenGoogleSignIn(BuildContext context) async {
    loginScreenShowSpinner = true;
    notifyListeners();
    // final users = Provider.of<UserProvider>(context, listen: false);
    // final sessions = Provider.of<SessionProvider>(context, listen: false);
    var response = await userProvider.googleSignIn();
    if (response is Success) {
      sessionProvider.setSession((response.response as Map)['session']);

      SharedPreferences prefs = await prefences;

      prefs.setString('accessToken', sessionProvider.session!.accessToken);
      prefs.setString('refreshToken', sessionProvider.session!.refreshToken);

      if (!prefs.containsKey('cartId')) {
        if (await cartProvider.createCart(sessionProvider.session as Session)) {
          prefs.setString('cartId', cartProvider.cart!.id.toString());
        } else {
          print('here');
        }
      } else {
        print('here');
      }

      loginScreenShowSpinner = false;
      notifyListeners();

      if (await userProvider.haveProvidedData(userProvider.user!.id)) {
        Navigator.of(context)
            .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
          'authSession': sessionProvider.session,
        });
      } else {
        Navigator.of(context)
            .pushReplacementNamed(UserInterestsScreen.routeName);
      }
    }
  }

  void loginScreenSaveForm(
      BuildContext context, GlobalKey<FormState> form, bool mounted) async {
    final isValid = form.currentState!.validate();

    if (isValid) {
      loginScreenShowSpinner = true;
      notifyListeners();

      form.currentState!.save();
      loginScreenPasswordFocusNode.unfocus();

      if (await sessionProvider.createSession(
          loginScreenUsernameOrEmail, loginScreenUserpassword)) {
        if (mounted) {
          loginScreenShowSpinner = false;
          // notifyListeners();
          SharedPreferences prefs = await prefences;

          prefs.setString('accessToken', sessionProvider.session!.accessToken);
          prefs.setString(
              'refreshToken', sessionProvider.session!.refreshToken);

          await userProvider
              .getUserByToken(sessionProvider.session!.accessToken);

          if (!prefs.containsKey('cartId')) {
            if (await cartProvider
                .createCart(sessionProvider.session as Session)) {
              prefs.setString('cartId', cartProvider.cart!.id.toString());
            } else {
              cartProvider.getCartInfo(prefs.getString('cartId') as String);
            }
          } else {
            if (cartProvider.cart == null) {
              cartProvider.getCartInfo(prefs.getString('cartId') as String);
            }
          }

          wishlistProvider
              .getWishlistedBooks(sessionProvider.session as Session);
          categoryProvider.getCategories(sessionProvider.session as Session);
          orderRequestProvider
              .getOrderRequestsByUser(sessionProvider.session as Session);

          if (prefs.containsKey('isFirstTime') &&
              prefs.getBool('isFirstTime') == false) {
            Navigator.of(context)
                // .pushReplacementNamed(HomeScreen.routeName, arguments: {
                .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
              'authSession': sessionProvider.session,
            });
          } else {
            if (await userProvider.haveProvidedData(userProvider.user!.id)) {
              prefs.setBool('isFirstTime', false);
              Navigator.of(context)
                  // .pushReplacementNamed(HomeScreen.routeName, arguments: {
                  .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
                'authSession': sessionProvider.session,
              });
            } else {
              Navigator.of(context).pushReplacementNamed(
                  UserInterestsScreen.routeName,
                  arguments: {
                    'authSession': sessionProvider.session,
                  });
            }
          }
        }
      } else {
        // setState(() {
        loginScreenShowSpinner = false;
        notifyListeners();
        // });
        if (sessionProvider.sessionError != null) {
          List<String> data = [];
          if (sessionProvider.sessionError!.message is String) {
            data.add(sessionProvider.sessionError!.message.toString());
          } else {
            (sessionProvider.sessionError!.message as Map)
                .forEach((key, value) {
              if (value is List) {
                value.forEach((item) => {data.add(item.toString())});
              } else {
                data.add(value.toString());
              }
            });
          }

          // Show notifications one by one with a delay
          int delay = 0;
          for (String element in data) {
            Future.delayed(Duration(milliseconds: delay), () {
              AlertHelper.showToastAlert(element);
              BotToast.showCustomNotification(
                duration: Duration(seconds: 3),
                toastBuilder: (cancelFunc) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      element,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            });
            delay += 1500; // increase delay for next notification
          }
        } else {
          AlertHelper.showToastAlert("Something went wrong, please try again");
        }
      }
    }
  }
}

mixin SignUpScreenViewModel on BaseViewModel {
  FocusNode signUpScreenPasswordFocusNode = FocusNode();
  FocusNode signUpScreenEmailFocusNode = FocusNode();
  var signUpScreenUserpassword;
  bool signUpScreenVisible = false;
  var signUpScreenShowSpinner = false;

  var signUpScreenNewUser = User(
    id: 'tempUser',
    firstName: 'tempFirstName',
    lastName: 'tempLastName',
    username: 'tempUsername',
    email: 'temp@mail.com',
    phone: 'tempPhone',
    image: null,
    description: 'This is a temp user',
    userClass: 'tempClass',
    followers: '',
    createdDate: NepaliDateTime.now(),
  );

  signUpScreenGoogleSignIn() async {
    // final users = Provider.of<Users>(context, listen: false);
    // final sessions = Provider.of<SessionProvider>(context, listen: false);
    // var response = await users.googleSignIn();
    // if (response is Success) {
    //   sessions.setSession((response.response as Map)['session']);
    //   SharedPreferences prefs = await _prefs;
    //   Users users = Provider.of<Users>(context, listen: false);
    //   prefs.setString('accessToken', sessions.session!.accessToken);
    //   prefs.setString('refreshToken', sessions.session!.refreshToken);
    //   if (!prefs.containsKey('cartId')) {
    //     if (await Provider.of<Carts>(context, listen: false)
    //         .createCart(sessions.session as Session)) {
    //       prefs.setString('cartId',
    //           Provider.of<Carts>(context, listen: false).cart!.id.toString());
    //     } else {
    //       print('here');
    //     }
    //   } else {
    //     print('here');
    //   }
    //   Navigator.of(context)
    //       .pushReplacementNamed(HomeScreen.routeName, arguments: {
    //     'authSession': sessions.session,
    //   });
    // }
  }

  void signUpScreenSaveForm(
      BuildContext context, GlobalKey<FormState> form, bool mounted) async {
    final isValid = form.currentState!.validate();

    if (isValid) {
      // setState(() {
      signUpScreenShowSpinner = true;
      notifyListeners();
      // });
      form.currentState!.save();

      // UserProvider users = UserProvider(null);

      if (await userProvider.createNewUser(
          signUpScreenNewUser, signUpScreenUserpassword)) {
        // setState(() {
        if (mounted) {
          signUpScreenShowSpinner = false;
          notifyListeners();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Welcome!'),
            content: Text(
              'You have been registered, please log in to continue',
              style: getRegularStyle(
                fontSize: FontSize.s16,
                color: ColorManager.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Go to login',
                  style: getBoldStyle(
                    fontSize: FontSize.s16,
                    // color: ColorManager.primary,
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
              ),
            ],
          ),
        );
        // });
      } else {
        // setState(() {
        signUpScreenShowSpinner = false;
        notifyListeners();
        // });
        if (userProvider.userError != null) {
          List<String> data = [];
          (userProvider.userError!.message as Map).forEach((key, value) {
            if (value is List) {
              value.forEach((item) => {data.add(item.toString())});
            } else {
              data.add(value.toString());
            }
          });

          // Show notifications one by one with a delay
          int delay = 0;
          for (String element in data) {
            Future.delayed(Duration(milliseconds: delay), () {
              AlertHelper.showToastAlert(element);
              BotToast.showCustomNotification(
                duration: Duration(seconds: 3),
                toastBuilder: (cancelFunc) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      element,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            });
            delay += 1500; // increase delay for next notification
          }
        } else {
          AlertHelper.showToastAlert("Something went wrong, please try again");
        }
      }
    }
  }
}