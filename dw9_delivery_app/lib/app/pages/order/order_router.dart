import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dw9_delivery_app/app/pages/order/order_controller.dart";
import "package:dw9_delivery_app/app/pages/order/order_page.dart";
import "package:dw9_delivery_app/app/repositories/order/order_repository.dart";
import "package:dw9_delivery_app/app/repositories/order/order_repository_impl.dart";

class OrderRouter {
  OrderRouter._();

  static Widget get page => MultiProvider(
    providers: <Provider<Object>>[
      Provider<OrderRepository>(create: (BuildContext context) => OrderRepositoryImpl(dio: context.read())),
      Provider<OrderController>(create: (BuildContext context) => OrderController(context.read()))
    ],
    child: const OrderPage()
  );
}