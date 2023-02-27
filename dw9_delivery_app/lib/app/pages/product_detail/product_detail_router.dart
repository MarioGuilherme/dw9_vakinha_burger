import "package:dw9_delivery_app/app/pages/product_detail/product_detail_controller.dart";
import "package:dw9_delivery_app/app/pages/product_detail/product_detail_page.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ProductDetailRouter {
  ProductDetailRouter._();

  static Widget get page => MultiProvider(
    providers: <Provider<ProductDetailController>>[
      Provider<ProductDetailController>(create: (BuildContext context) => ProductDetailController())
    ],
    builder: (BuildContext context, Widget? child) {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ProductDetailPage(
        product: args["product"],
        order: args["order"]
      );
    }
  );
}