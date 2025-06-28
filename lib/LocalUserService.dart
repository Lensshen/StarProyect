import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalUserService {
  static const _keyUserId = 'local_user_id';

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_keyUserId);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_keyUserId, id);
    }
    return id;
  }
}
