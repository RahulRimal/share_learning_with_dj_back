import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

class UserHelper {
  static String userDisplayName(User user) {
    return user.firstName + " " + user.lastName;
  }

  static String userProfileImage(User user) {
    // String username = user.username.toString();

    // return "${RemoteManager.PROFILE_POOL}/$username/${user.image}";
    return user.image == null? RemoteManager.IMAGE_PLACEHOLDER: user.image!.contains('http://') ? user.image as String : RemoteManager.BASE_URI + user.image! as String;
  }

  static String userClass(User user) {
    String? grade = user.userClass;

  for (int i = 1; i < 13; i++) {
    if(grade == i.toString()){
      return "Class " + i.toString();
    }
  }
  return user.userClass as String;
  }

}
