import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

class UserHelper {
  static String userDisplayName(User user) {
    return user.firstName + " " + user.lastName;
  }

  static String userProfileImage(User user) {
    // String username = user.username.toString();

    // return "${RemoteManager.PROFILE_POOL}/$username/${user.image}";
    return user.image == null? RemoteManager.IMAGE_PLACEHOLDER: user.image as String;
  }
}
