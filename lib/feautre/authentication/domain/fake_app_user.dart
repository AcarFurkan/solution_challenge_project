 
import 'app_user.dart';

class FakeAppUser extends AppUser {
  FakeAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });
  final String password;
}
