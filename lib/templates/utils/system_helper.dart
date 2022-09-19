import 'package:share_learning/templates/managers/api_values_manager.dart';

class SystemHelper {
  static String postImage(String bookId, String imageName) {
    return "${RemoteManager.POST_POOL}/$bookId/$imageName";
  }
}
