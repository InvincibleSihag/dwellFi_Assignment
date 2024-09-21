import 'package:dwell_fi_assignment/features/auth/domain/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.login(event.userLogin);
    result.fold(
      (failure) => emit(AuthUnauthenticated(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
