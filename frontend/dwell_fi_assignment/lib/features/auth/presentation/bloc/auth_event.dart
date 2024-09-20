import 'package:dwell_fi_assignment/features/auth/domain/entities/user_login.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final UserLogin userLogin;

  const LoginRequested(this.userLogin);
  
  @override
  List<Object> get props => [userLogin];
}

class LogoutRequested extends AuthEvent {}
