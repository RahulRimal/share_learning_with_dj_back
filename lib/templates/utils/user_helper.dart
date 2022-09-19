import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

class UserHelper {
  static String userDisplayName(User user) {
    return user.firstName + " " + user.lastName;
  }

  static String userProfileImage(User user) {
    // String firstNameInLower = user.firstName.toLowerCase();
    String username = user.username.toString();
    // return user.image ?? 'https://cdn.pixabay.com/photo/2017/02/04/12/25/
    // return RemoteManager.PROFILE_POOL + '/' + user.firstName + '/' + user.image as String;
    // return "${RemoteManager.PROFILE_POOL}/${user.firstName}/${user.image}";
    return "${RemoteManager.PROFILE_POOL}/$username/${user.image}";
  }
}
