import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dw9_delivery_app/app/pages/auth/register/register_controller.dart";
import "package:dw9_delivery_app/app/pages/auth/register/register_page.dart";

class RegisterRouter {
  RegisterRouter._();

  static Widget get page => MultiProvider(
    providers: <Provider<RegisterController>>[
      Provider<RegisterController>(create: (BuildContext context) => RegisterController(context.read()))
    ],
    child: const RegisterPage()
  );
}