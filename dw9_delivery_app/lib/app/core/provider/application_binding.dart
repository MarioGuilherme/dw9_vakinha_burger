import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dw9_delivery_app/app/core/rest_client/custom_dio.dart";
import "package:dw9_delivery_app/app/repositories/auth/auth_repository.dart";
import "package:dw9_delivery_app/app/repositories/auth/auth_repository_impl.dart";

class ApplicationBinding extends StatelessWidget {
  final Widget child;

  const ApplicationBinding({
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider<Object>>[
        Provider<CustomDio>(create: (BuildContext context) => CustomDio()),
        Provider<AuthRepository>(create: (BuildContext context) => AuthRepositoryImpl(dio: context.read()))
      ],
      child: this.child
    );
  }
}