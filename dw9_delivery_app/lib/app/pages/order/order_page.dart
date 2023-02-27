import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:validatorless/validatorless.dart";

import "package:dw9_delivery_app/app/core/extensions/formatter_extension.dart";
import "package:dw9_delivery_app/app/core/ui/base_state/base_state.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/payment_type_model.dart";
import "package:dw9_delivery_app/app/pages/order/order_controller.dart";
import "package:dw9_delivery_app/app/pages/order/order_state.dart";
import "package:dw9_delivery_app/app/pages/order/widget/order_field.dart";
import "package:dw9_delivery_app/app/pages/order/widget/order_product_tile.dart";
import "package:dw9_delivery_app/app/pages/order/widget/payments_types_field.dart";

class OrderPage extends StatefulWidget {
  const OrderPage({ super.key });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController addressEC = TextEditingController();
  final TextEditingController documentEC = TextEditingController();
  int? paymentTypeId;
  final ValueNotifier<bool> paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final List<OrderProductDto> products = ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    this.controller.load(products);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Deseja excluir o produto ${state.orderProduct.product.name}"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              this.controller.cancelDeleteProcess();
            },
            child: Text("Cancelar", style: context.textStyles.textBold.copyWith(color: Colors.red))
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.controller.decrementProduct(state.index);
            },
            child: Text("Confirmar", style: context.textStyles.textBold)
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (BuildContext context, OrderState state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            this.hideLoader();
            this.showError(state.errorMessage ?? "Erro desconhecido");
          },
          confirmRemoveProduct: () {
            this.hideLoader();
            if (state is OrderConfirmDeleteProductState)
              this._showConfirmProductDialog(state);
          },
          emptyBag: () {
            this.showInfo("Sua sacola está vazia, por favor selecione um produto para realizar seu pedido");
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            this.hideLoader();
            Navigator.of(context).popAndPushNamed("/order/completed", result: <OrderProductDto>[]);
          }
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(this.controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: this.formKey,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Text("Carrinho", style: context.textStyles.textTitle),
                        IconButton(
                          onPressed: () => this.controller.emptyBag(),
                          icon: Image.asset("assets/images/trashRegular.png")
                        )
                      ]
                    )
                  )
                ),
                BlocSelector<OrderController, OrderState, List<OrderProductDto>>(
                  selector: (OrderState  state) => state.orderProducts,
                  builder: (BuildContext context, List<OrderProductDto> orderProducts) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: orderProducts.length,
                      (BuildContext context, int index) => Column(
                        children: <Widget>[
                          OrderProductTile(
                            index: index,
                            orderProduct: orderProducts[index]
                          ),
                          const Divider(color: Colors.grey)
                        ]
                      )
                    )
                  )
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Total do pedido",
                              style: context.textStyles.textExtraBold.copyWith(fontSize: 16)
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (OrderState state) => state.totalOrder,
                              builder: (BuildContext context, double totalOrder) => Text(
                                totalOrder.currencyPTBR,
                                style: context.textStyles.textExtraBold.copyWith(fontSize: 20)
                              )
                            )
                          ]
                        )
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "Endereço de entrega",
                        controller: this.addressEC,
                        validator: Validatorless.required("Endereço obrigatório"),
                        hintText: "Digite um endereço"
                      ),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "CPF",
                        controller: this.documentEC,
                        validator: Validatorless.required("CPF obrigatóirio"),
                        hintText: "Digite o CPF"
                      ),
                      const SizedBox(height: 20),
                      BlocSelector<OrderController, OrderState, List<PaymentTypeModel>>(
                        selector: (OrderState state) => state.paymentsTypes,
                        builder: (BuildContext context, List<PaymentTypeModel> paymentsTypes) => ValueListenableBuilder<bool>(
                          valueListenable: this.paymentTypeValid,
                          builder: (BuildContext context, dynamic paymentTypeValidValue, Widget? child) {
                            return PaymentsTypesField(
                              paymentTypes: paymentsTypes,
                              valueChanged: (int value) => this.paymentTypeId = value,
                              isValid: paymentTypeValidValue,
                              valueSelected: this.paymentTypeId.toString()
                            );
                          }
                        )
                      )
                    ]
                  )
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DeliveryButton(
                          width: double.infinity,
                          heigth: 48,
                          label: "FINALIZAR",
                          onPressed: () {
                            final bool valid = this.formKey.currentState?.validate() ?? false;
                            final bool paymentTypeSelected = this.paymentTypeId != null;
                            this.paymentTypeValid.value = paymentTypeSelected;
                            if (valid && paymentTypeSelected) {
                              this.controller.saveOrder(
                                address: this.addressEC.text,
                                document: this.documentEC.text,
                                paymentMethodId: paymentTypeId!
                              );
                            }
                          }
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}