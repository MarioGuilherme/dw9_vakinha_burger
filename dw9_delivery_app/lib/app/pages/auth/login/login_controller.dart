import "dart:developer";
import "package:bloc/bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dw9_delivery_app/app/core/exceptions/unauthorized_exception.dart";
import "package:dw9_delivery_app/app/models/auth_model.dart";
import "package:dw9_delivery_app/app/pages/auth/login/login_state.dart";
import "package:dw9_delivery_app/app/repositories/auth/auth_repository.dart";

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginController(this._authRepository) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      this.emit(this.state.copyWith(status: LoginStatus.login));
      final AuthModel authModel = await this._authRepository.login(email, password);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("accessToken", authModel.accessToken);
      sp.setString("refreshToken", authModel.refreshToken);
      this.emit(this.state.copyWith(status: LoginStatus.suceess));
    } on UnauthorizedException catch (e, s) {
      log("E-mail o usenha inválidos", error: e, stackTrace: s);
      this.emit(this.state.copyWith(status: LoginStatus.error, errorMessage: "E-mail ou senha inválidos!"));
    } catch (e, s) {
      log("Erro ao realiar login", error: e, stackTrace: s);
      this.emit(this.state.copyWith(status: LoginStatus.error, errorMessage: "Erro ao realizar login!"));
    }
  }
}