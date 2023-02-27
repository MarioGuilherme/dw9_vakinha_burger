import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:dw9_delivery_app/app/core/extensions/formatter_extension.dart";
import "package:dw9_delivery_app/app/core/ui/base_state/base_state.dart";
import "package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_increment_decrement_button.dart";
import "package:dw9_delivery_app/app/models/product_model.dart";
import "package:dw9_delivery_app/app/pages/product_detail/product_detail_controller.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? order;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.order,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends BaseState<ProductDetailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final int amount = this.widget.order?.amount ?? 1;
    this.controller.initial(amount, this.widget.order != null);
  }
  
  void _showConfirmDelete(int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Deseja excluir o produto"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar", style: context.textStyles.textBold.copyWith(color: Colors.red))
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pop(OrderProductDto(
                product: this.widget.product,
                amount: amount
              ));
            },
            child: Text("Confirmar", style: context.textStyles.textBold)
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: context.screenWidth,
            height: context.percentHeigth(.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(this.widget.product.image),
                fit: BoxFit.cover
              )
            )
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(this.widget.product.name, style: context.textStyles.textExtraBold.copyWith(fontSize: 22))
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(child: Text(this.widget.product.description))
            )
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Container(
                height: 68,
                padding: const EdgeInsets.all(8),
                width: context.percentWidth(.5),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (BuildContext context, int amount) {
                    return DeliveryIncrementDecrementButton(
                      decrementTap: () => controller.decrement(),
                      incrementTap: () => controller.increment(),
                      amout: amount
                    );
                  }
                )
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: 68,
                width: context.percentWidth(.5),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (BuildContext context, int amount) {
                    return ElevatedButton(
                      style: amount == 0
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.red)
                        : null,
                      onPressed: () {
                        if (amount == 0)
                          this._showConfirmDelete(amount);
                        else
                          Navigator.of(context).pop(OrderProductDto(
                            product: this.widget.product,
                            amount: amount
                          ));
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text("Excluir produto", style: context.textStyles.textExtraBold),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Adicionar", style: context.textStyles.textExtraBold.copyWith(fontSize: 13)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AutoSizeText(
                                (this.widget.product.price * amount).currencyPTBR,
                                textAlign: TextAlign.center,
                                maxFontSize: 13,
                                minFontSize: 5,
                                maxLines: 1,
                                style: context.textStyles.textExtraBold.copyWith(fontSize: 13)
                              )
                            )
                          ]
                        )
                      )
                    );
                  }
                )
              )
            ]
          )
        ]
      )
    );
  }
}