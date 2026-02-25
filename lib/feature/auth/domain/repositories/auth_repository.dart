import 'package:chat_app/feature/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String phoneNumber, required String password});
}
