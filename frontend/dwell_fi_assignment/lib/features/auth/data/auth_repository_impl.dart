import 'package:dwell_fi_assignment/core/common/models/user_model.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/auth/domain/auth_repository.dart';
import 'package:dwell_fi_assignment/features/auth/domain/entities/user_login.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<Failure, User>> login(UserLogin userLogin) async {
    return right(User(
        id: '1',
        email: 'test@gmail.com',
        name: 'test',
        countryCode: '91',
        phoneNumber: '9876543210'));
  }
}
