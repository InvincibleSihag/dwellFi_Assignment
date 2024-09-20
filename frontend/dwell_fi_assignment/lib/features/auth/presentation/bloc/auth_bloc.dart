import 'package:bloc/bloc.dart';
import 'package:dwell_fi_assignment/features/auth/data/auth_repository_impl.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:dwell_fi_assignment/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authRepository;

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
