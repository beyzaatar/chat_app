import 'package:chat_app/feature/auth/data/models/user_model.dart';
import 'package:chat_app/feature/auth/domain/entities/user.dart';
import 'package:chat_app/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login({
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final response = {
      "id": "1",
      "phoneNumber": phoneNumber,
    }; //fake api response
    return UserModel.fromJson(response);
  }
}
