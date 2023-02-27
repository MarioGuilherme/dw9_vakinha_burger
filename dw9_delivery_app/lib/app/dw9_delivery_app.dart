import "package:flutter/material.dart";

import "package:dw9_delivery_app/app/core/global/global_context.dart";
import "package:dw9_delivery_app/app/core/provider/application_binding.dart";
import "package:dw9_delivery_app/app/pages/auth/login/login_router.dart";
import "package:dw9_delivery_app/app/pages/auth/register/register_router.dart";
import "package:dw9_delivery_app/app/pages/home/home_router.dart";
import "package:dw9_delivery_app/app/pages/order/order_completed_page.dart";
import "package:dw9_delivery_app/app/pages/order/order_router.dart";
import "package:dw9_delivery_app/app/pages/product_detail/product_detail_router.dart";
import "package:dw9_delivery_app/app/core/ui/theme/theme_config.dart";
import "package:dw9_delivery_app/app/pages/splash/splash_page.dart";

class Dw9DeliveryApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Dw9DeliveryApp({super.key}) {
    GlobalContext.instance.navigatorKey = this._navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        navigatorKey: this._navigatorKey,
        title: "Delivery App",
        theme: ThemeConfig.theme,
        routes: <String, Widget Function(BuildContext)>{
          "/": (BuildContext context) => const SplashPage(),
          "/home": (BuildContext context) => HomeRouter.page,
          "/productDetail": (BuildContext context) => ProductDetailRouter.page,
          "/auth/login": (BuildContext context) => LoginRouter.page,
          "/auth/register": (BuildContext context) => RegisterRouter.page,
          "/order": (BuildContext context) => OrderRouter.page,
          "/order/completed": (BuildContext context) => const OrderCompletedPage()
        }
      )
    );
  }
}