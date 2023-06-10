import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

class UserHelper {
  static String userDisplayName(User user) {
    return user.firstName.toString() + " " + user.lastName.toString();
  }

  static String userProfileImage(User user) {
    // print(user);
    // String data = user.image == null
    if (user.image == null) {
      return RemoteManager.IMAGE_PLACEHOLDER;
    }
    if (user.image!.contains('googleusercontent.com')) {
      // : user.image!.contains('https://')
      return (user.image as String).replaceAll('/media/https%3A/', 'https://');
    }
    return RemoteManager.BASE_URI + user.image!;
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
