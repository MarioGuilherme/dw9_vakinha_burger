import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:dw9_delivery_app/app/core/ui/base_state/base_state.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/product_model.dart";
import "package:dw9_delivery_app/app/pages/home/home_controller.dart";
import "package:dw9_delivery_app/app/pages/home/home_state.dart";
import "package:dw9_delivery_app/app/pages/home/widgets/shopping_bag_widget.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart";
import "package:dw9_delivery_app/app/pages/home/widgets/delivery_product_tile.dart";

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() => controller.loadProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: BlocConsumer<HomeController, HomeState>(
        listener: (BuildContext context, HomeState state) {
          state.status.matchAny(
            any: () => hideLoader(),
            loading: () => showLoader(),
            error: () {
              hideLoader();
              showError(state.errorMessage ?? "Erro não informado");
            }
          );
        },
        buildWhen: (HomeState previous, HomeState current) => current.status.matchAny(
          any: () => false,
          initial: () => true,
          loaded: () => true
        ),
        builder: (BuildContext context, HomeState state) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProductModel product = state.products[index];
                    final Iterable<OrderProductDto> orders = state.shoppingBag.where((OrderProductDto order) => order.product == product);
                    return DeliveryProductTile(
                      product: product,
                      orderProduct: orders.isNotEmpty ? orders.first : null
                    );
                  }
                )
              ),
              Visibility(
                visible: state.shoppingBag.isNotEmpty,
                child: ShoppingBagWidget(bag: state.shoppingBag)
              )
            ]
          );
        }
      )
    );
  }
}