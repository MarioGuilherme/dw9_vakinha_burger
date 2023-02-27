import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dw9_delivery_app/app/core/extensions/formatter_extension.dart";
import "package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/pages/home/home_controller.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";

class ShoppingBagWidget extends StatelessWidget {
  final List<OrderProductDto> bag;

  const ShoppingBagWidget({
    super.key,
    required this.bag
  });

  Future<void> _goOrder(BuildContext context) async {
    final HomeController controller = context.read<HomeController>();
    final NavigatorState navigator = Navigator.of(context);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (!sp.containsKey("accessToken")) {
      final dynamic loginResult = await navigator.pushNamed("/auth/login");
      if (loginResult == null || loginResult == false)
        return;
    }
    final dynamic updateBag = await navigator.pushNamed("/order", arguments: bag);
    controller.updateBag(updateBag as List<OrderProductDto>);
  }

  @override
  Widget build(BuildContext context) {
    String totalBag = this.bag.fold<double>(0.0, (double total, OrderProductDto element) => total += element.totalPrice).currencyPTBR;

    return Container(
      width: context.screenWidth,
      height: 90,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black26, blurRadius: 5)
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      child: ElevatedButton(
        onPressed: () => this._goOrder(context),
        child: Stack(
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.shopping_cart_outlined)
            ),
            Align(
              alignment: Alignment.center,
              child: Text("Ver Sacola", style: context.textStyles.textExtraBold.copyWith(fontSize: 14))
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(totalBag, style: context.textStyles.textExtraBold.copyWith(fontSize: 11))
            )
          ]
        )
      )
    );
  }
}