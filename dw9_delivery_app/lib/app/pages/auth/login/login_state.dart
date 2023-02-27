import "package:equatable/equatable.dart";
import "package:match/match.dart";

part "login_state.g.dart";

@match
enum LoginStatus {
  initial,
  login,
  suceess,
  loginError,
  error
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    required this.status,
    this.errorMessage
  });

  const LoginState.initial()
    : this.status = LoginStatus.initial,
      this.errorMessage = null;

  @override
  List<Object?> get props => <Object?>[this.status, this.errorMessage];

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}