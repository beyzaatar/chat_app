import 'package:chat_app/feature/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], phoneNumber: json['phoneNumber']);
  }
}
