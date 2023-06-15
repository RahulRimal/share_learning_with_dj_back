import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_learning/view_models/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../models/user.dart';
import '../templates/screens/login_screen.dart';
import '../templates/utils/alert_helper.dart';
import '../templates/utils/system_helper.dart';

mixin UserProfileScreenViewModel on BaseViewModel {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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
    SharedPreferences prefs = await _prefs;
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
