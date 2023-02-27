import "dart:developer";

import "package:bloc/bloc.dart";
import "package:dw9_delivery_app/app/pages/auth/register/register_state.dart";
import "package:dw9_delivery_app/app/repositories/auth/auth_repository.dart";

class RegisterController extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterController(this._authRepository) : super(const RegisterState.initial());

  Future<void> register(String name, String email, String password) async {
    try {
      this.emit(this.state.copyWith(status: RegisterStatus.register));
      await this._authRepository.register(name, email, password);
      this.emit(this.state.copyWith(status: RegisterStatus.success));
    } catch (e, s) {
      log("Erro ao registrar o usuário", error: e, stackTrace: s);
      this.emit(this.state.copyWith(status: RegisterStatus.error));
    }
  }
}