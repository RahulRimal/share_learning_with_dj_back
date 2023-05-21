import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

class UserHelper {
  static String userDisplayName(User user) {
    return user.firstName.toString() + " " + user.lastName.toString();
  }

  static String userProfileImage(User user) {
    // String data = user.image == null
    return user.image == null
        ? RemoteManager.IMAGE_PLACEHOLDER
        : user.image!.contains('http://')
            // : user.image!.contains('https://')
            ? user.image as String
            : RemoteManager.BASE_URI + user.image! as String;
    // print(data);
    // return data;
  }

  static String userClass(User user) {
    // if (user.userClass == null) return "Undefined Class";
    if (user.userClass == null) return "";
    String? grade = user.userClass;

    for (int i = 1; i < 13; i++) {
      if (grade == i.toString()) {
        return "Class " + i.toString();
      }
    }
    return user.userClass as String;
  }

  static String userDescription(User user) {
    if (user.description == null) return "No description";

    return user.description as String;
  }
}
