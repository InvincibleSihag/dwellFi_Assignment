import 'package:dwell_fi_assignment/core/common/models/user_model.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/auth/domain/entities/user_login.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(UserLogin userLogin);
}
