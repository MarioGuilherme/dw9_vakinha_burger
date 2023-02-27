import "package:dio/dio.dart";
import "package:dio/native_imp.dart";

import "package:dw9_delivery_app/app/core/config/env/env.dart";
import "package:dw9_delivery_app/app/core/rest_client/interceptors/auth_interceptor.dart";

class CustomDio extends DioForNative {
  late final AuthInterceptor _authInterceptor;

  CustomDio() : super(BaseOptions(
    baseUrl: Env.instance["backend_base_url"] ?? "",
    connectTimeout: 5000,
    receiveTimeout: 60000
  )) {
    this.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true
    ));
    this._authInterceptor = AuthInterceptor(this);
  }

  CustomDio auth() {
    this.interceptors.add(this._authInterceptor);
    return this;
  }

  CustomDio unauth() {
    this.interceptors.remove(this._authInterceptor);
    return this;
  }
}