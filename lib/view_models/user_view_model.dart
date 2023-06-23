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
import '../templates/managers/enum_managers.dart';
import '../templates/managers/font_manager.dart';
import '../templates/managers/routes_manager.dart';
import '../templates/managers/style_manager.dart';
import '../templates/screens/add_post_screen.dart';
import '../templates/screens/cart_screen.dart';
import '../templates/screens/home_screen_new.dart';
import '../templates/screens/login_screen.dart';
import '../templates/screens/order_details_screen.dart';
import '../templates/screens/order_request_screen.dart';
import '../templates/screens/order_requests_screen_for_seller.dart';
import '../templates/screens/orders_screen_new.dart';
import '../templates/screens/user_interests_screen.dart';
import '../templates/screens/user_posts_screen.dart';
import '../templates/screens/user_profile_screen.dart';
import '../templates/utils/alert_helper.dart';
import '../templates/utils/system_helper.dart';
import '../templates/widgets/app_drawer.dart';

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
    SharedPreferences prefs = await preferences;
    bookProvider.setBooks([]);

    userProvider.logoutUser('1');
    commentProvider.setComments([]);
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    Navigator.pushReplacementNamed(context, RoutesManager.loginScreenRoute);
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

  late FocusNode userProfileEditScreenFirstNameFocusNode;
  late FocusNode userProfileEditScreenLastNameFocusNode;
  late FocusNode userProfileEditScreenDescriptionFocusNode;
  late FocusNode userProfileEditScreenClassFocusNode;

  bool userProfileEditScreenShowLoading = false;
  ImagePicker userProfileEditScreenImagePicker = ImagePicker();

  bool userProfileEditScreenImageAdded = false;

  User userProfileEditScreenEdittedUser = User(
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

  bindUserProfileEditScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    userProfileEditScreenFirstNameFocusNode = FocusNode();
    userProfileEditScreenLastNameFocusNode = FocusNode();
    userProfileEditScreenDescriptionFocusNode = FocusNode();
    userProfileEditScreenClassFocusNode = FocusNode();
    if (userProvider.user != null)
      userProfileEditScreenEdittedUser = userProvider.user!;
  }

  unbindUserProfileEditScreenViewModel() {}

  Future<void> userProfileEditScreenGetPicture() async {
    final imageFiles = await userProfileEditScreenImagePicker.pickImage(
      maxWidth: 770,
      imageQuality: 100,
      source: ImageSource.gallery,
    );

    if (imageFiles == null) return;

    userProfileScreenAddedImage = imageFiles;

    // setState(() {
    // userProfileScreenSetImageAdded(true);
    userProfileEditScreenImageAdded = true;
    notifyListeners();
    // });
  }

  Future<bool> userProfileEditScreenUpdateProfile(
    GlobalKey<FormState> form,
  ) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    var oldUserMap = userProvider.user!.toMap();
    var edittedUserMap = userProfileEditScreenEdittedUser.toMap();

    Map<String, dynamic> changedValues =
        SystemHelper.getChangedValues(oldUserMap, edittedUserMap);

    changedValues['id'] = userProfileEditScreenEdittedUser.id;

    if (await userProvider.updateUserInfo(
        sessionProvider.session as Session, changedValues)) {
      if (userProfileEditScreenImageAdded) {
        if (!await userProvider.updateProfilePicture(
            sessionProvider.session as Session,
            userProfileEditScreenEdittedUser.id,
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
    loginScreenPasswordFocusNode = FocusNode();
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

      SharedPreferences prefs = await preferences;

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
            .pushReplacementNamed(RoutesManager.homeScreenNewRoute, arguments: {
          'authSession': sessionProvider.session,
        });
      } else {
        Navigator.of(context)
            .pushReplacementNamed(RoutesManager.userInterestsScreenRoute);
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
          SharedPreferences prefs = await preferences;

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
                .pushReplacementNamed(RoutesManager.homeScreenNewRoute,
                    arguments: {
                  'authSession': sessionProvider.session,
                });
          } else {
            if (await userProvider.haveProvidedData(userProvider.user!.id)) {
              prefs.setBool('isFirstTime', false);
              Navigator.of(context)
                  // .pushReplacementNamed(HomeScreen.routeName, arguments: {
                  .pushReplacementNamed(RoutesManager.homeScreenNewRoute,
                      arguments: {
                    'authSession': sessionProvider.session,
                  });
            } else {
              Navigator.of(context).pushReplacementNamed(
                  RoutesManager.userInterestsScreenRoute,
                  arguments: {
                    'authSession': sessionProvider.session,
                  });
            }
          }
        }
      } else {
        // setState(() {
        if (mounted) {
          loginScreenShowSpinner = false;
          // notifyListeners();
        }
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
  // FocusNode signUpScreenPasswordFocusNode = FocusNode();
  // FocusNode signUpScreenEmailFocusNode = FocusNode();
  late FocusNode signUpScreenPasswordFocusNode;
  late FocusNode signUpScreenEmailFocusNode;
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

  bindSignUpScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    signUpScreenPasswordFocusNode = FocusNode();
    signUpScreenEmailFocusNode = FocusNode();
  }

  unBindSignUpScreenViewModel() {
    signUpScreenPasswordFocusNode.dispose();
    signUpScreenEmailFocusNode.dispose();
  }

  signUpScreenGoogleSignIn() async {
    // final users = Provider.of<Users>(context, listen: false);
    // final sessions = Provider.of<SessionProvider>(context, listen: false);
    // var response = await userProvider.googleSignIn();
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
                      .pushReplacementNamed(RoutesManager.loginScreenRoute);
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

mixin UserInterestsScreenViewModel on BaseViewModel {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = false;

  List<String> _interests = [
    'Cooking',
    'Sports',
    'Traveling',
    'Music',
    'Art',
    'Reading',
    'Writing',
    'Gardening',
    'Fashion',
    'Dancing',
  ];

  List<String> _hobbies = [
    'Video games',
    'Watching TV',
    'Playing sports',
    'Photography',
    'Baking',
    'Watching movies',
    'Painting',
    'Gardening',
    'Collecting',
    'Listening to music',
  ];

  List<String> _selectedInterests = [];
  List<String> _selectedHobbies = [];

  bool get userInterestsScreenViewModelIsLoading => _isLoading;

  set userInterestsScreenViewModelIsLoading(bool value) {
    _isLoading = value;
  }

  List<String> get userInterestsScreenViewModelInterests => _interests;

  set userInterestsScreenViewModelInterests(List<String> value) =>
      _interests = value;

  List<String> get userInterestsScreenViewModelHobbies => _hobbies;

  set userInterestsScreenViewModelHobbies(List<String> value) =>
      _hobbies = value;

  List<String> get userInterestsScreenViewModelSelectedInterests =>
      _selectedInterests;

  set userInterestsScreenViewModelSelectedInterests(List<String> value) =>
      _selectedInterests = value;

  List<String> get userInterestsScreenViewModelSelectedHobbies =>
      _selectedHobbies;
  set userInterestsScreenViewModelSelectedHobbies(List<String> value) =>
      _selectedHobbies = value;

  bindUserInterestsScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unBindUserInterestsScreenViewModel() {}

  void userInterestsScreenViewModelHandleInterestSelect(String interest) async {
    // setState(() {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }
    notifyListeners();
    // });
  }

  void userInterestsScreenViewModelHandleHobbySelect(String hobby) {
    // setState(() {
    if (_selectedHobbies.contains(hobby)) {
      _selectedHobbies.remove(hobby);
    } else {
      _selectedHobbies.add(hobby);
    }
    notifyListeners();
    // });
  }

  // Future<bool> _handleNextButtonPress() {
  userInterestsScreenViewModelHandleNextButtonPress(
      BuildContext context, bool mounted) async {
    // setState(() {
    _isLoading = true;
    notifyListeners();
    // });

    SharedPreferences prefs = await preferences;

    Map<String, List<String>> userData = {
      'interests': _selectedInterests,
      'hobbies': _selectedHobbies,
    };

    userData.forEach((key, value) async {
      if (userProvider.user == null) {
        await userProvider
            .getUserByToken((sessionProvider.session as Session).accessToken);
      }
      var response =
          await userProvider.updateUserData(userProvider.user!.id, key, value);
      // print(response);
      if (response is Success) {
        AlertHelper.showToastAlert(response.response.toString());

        prefs.setBool('isFirstTime', false);
        if (mounted) {
          // setState(() {
          _isLoading = false;
          notifyListeners();
          // });
        }
        if (mounted) {
          Navigator.pushReplacementNamed(
              context, RoutesManager.homeScreenNewRoute);
        }
      }
      if (response is Failure) {
        // setState(() {
        _isLoading = false;
        notifyListeners();
        // });
        AlertHelper.showToastAlert(response.errorResponse.toString());
      }
    });
  }
}

mixin AppDrawerViewModel on BaseViewModel {
  final List<DrawerItem> _drawerItems = [
    DrawerItem(
      icon: Icons.add_circle,
      title: 'Add Post',
      route: RoutesManager.addPostScreenRoute,
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Your Posts',
      route: RoutesManager.userPostsScreenRoute,
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Your Profile',
      route: RoutesManager.userProfileScreenRoute,
    ),
    DrawerItem(
      title: 'Your Cart',
      icon: Icons.shop_rounded,
      route: RoutesManager.cartScreenRoute,
    ),
    DrawerItem(
      title: 'Your Requests',
      icon: Icons.shop_rounded,
      route: RoutesManager.orderRequestScreenRoute,
    ),
    DrawerItem(
      title: 'Requests for your books',
      icon: Icons.shop_rounded,
      route: RoutesManager.orderRequestsScreenForSellerRoute,
    ),
    DrawerItem(
        title: 'Your Orders',
        icon: Icons.carpenter,
        route: RoutesManager.ordersScreenNewRoute),
    DrawerItem(
      title: 'Your Interests',
      icon: Icons.carpenter,
      route: RoutesManager.userInterestsScreenRoute,
    ),
  ];

  List<DrawerItem> get appDrawerViewModelDrawerItems => _drawerItems;

  bindAppDrawerViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unbindAppDrawerViewModel() {}

  AppDrawerViewModelLogOut(BuildContext context) async {
    bookProvider.setBooks([]);

    commentProvider.setComments([]);

    SharedPreferences prefs = await preferences;

    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    prefs.remove('isFirstTime');

    Navigator.pushReplacementNamed(context, RoutesManager.loginScreenRoute);
  }
}

mixin BillingInfoViewModel on BaseViewModel {
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _sideNoteFocusNode = FocusNode();

  late PaymentMethod _paymentMethod;

  get billingInfoViewModelFirstNameFocusNode => _firstNameFocusNode;
  get billingInfoViewModelLastNameFocusNode => _lastNameFocusNode;
  get billingInfoViewModelPhoneNumberFocusNode => _phoneNumberFocusNode;
  get billingInfoViewModelEmailFocusNode => _emailFocusNode;
  get billingInfoViewModelSideNoteFocusNode => _sideNoteFocusNode;

  PaymentMethod get billingInfoViewModelPaymentMethod => _paymentMethod;
  set billingInfoViewModelPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  bindBillingInfoViewModel(BuildContext context) {
    bindBaseViewModal(context);
    _paymentMethod = PaymentMethod.Khalti;

    if (userProvider.user != null) setBillingInfo();
  }

  unBindBillingInfoViewModel() {}
}
