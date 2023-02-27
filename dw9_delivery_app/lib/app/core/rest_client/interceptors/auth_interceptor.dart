import "dart:developer";
import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dw9_delivery_app/app/core/exceptions/expire_token_exception.dart";
import "package:dw9_delivery_app/app/core/global/global_context.dart";
import "package:dw9_delivery_app/app/core/rest_client/custom_dio.dart";

class AuthInterceptor extends Interceptor {
  final CustomDio dio;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? accessToken = sp.getString("accessToken");
    options.headers["Authorization"] = "Bearer $accessToken";
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != "/auth/refresh") {
          await this._refreshToken(err);
          await this._retryRequest(err, handler);
        } else {
          GlobalContext.instance.loginExpire();
        }
      } catch (e) {
        GlobalContext.instance.loginExpire();
      }
    } else
      handler.next(err);
  }
  
  Future<void> _refreshToken(DioError err) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final String? refreshToken = sp.getString("refreshToken");

      if (refreshToken == null) return;

      final Response<dynamic> resultRefresh = await this.dio.auth().put("/auth/refresh", data: <String, String>{
        "refresh_token": refreshToken
      });

      sp.setString("accessToken", resultRefresh.data["access_token"]);
      sp.setString("refreshToken", resultRefresh.data["refresh_token"]);
    } on DioError catch (e, s) {
      log("Erro ao realizar o refresh token", error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }
  
  Future<void> _retryRequest(DioError err, ErrorInterceptorHandler handler) async {
    final RequestOptions requestOptions = err.requestOptions;
    final Response<dynamic> result = await this.dio.request(
      requestOptions.path,
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method,
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters
    );
    handler.resolve(Response<dynamic>(
      requestOptions: requestOptions,
      data: result.data,
      statusCode: result.statusCode,
      statusMessage: result.statusMessage
    ));
  }
}