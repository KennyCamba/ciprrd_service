import 'package:ciprrd_service/sql/models.dart';

class Session {
  final User user = getUser() as User;

  static Session active = new Session();

  Session();

  static Session getActiveSession(){
    return active;
  }

  static Future<User> getUser() async {
    List<User> users = await User.objects();
    return users.length > 0 ? users[0] : null;
  }

  bool isUserLogin(){
    return false;
  }

  bool login(String username, String password){
    return true;
  }
}