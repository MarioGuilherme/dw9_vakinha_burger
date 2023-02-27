import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dw9_delivery_app/app/core/extensions/formatter_extension.dart";
import "package:dw9_delivery_app/app/core/ui/styles/colors_app.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/product_model.dart";
import "package:dw9_delivery_app/app/pages/home/home_controller.dart";

class DeliveryProductTile extends StatelessWidget {
  final ProductModel product;
  final OrderProductDto? orderProduct;

  const DeliveryProductTile({
    super.key,
    required this.product,
    required this.orderProduct
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final HomeController controller = context.read<HomeController>();
        final dynamic orderProductResult = await Navigator.of(context).pushNamed("/productDetail", arguments: <String, Object?>{
          "product": this.product,
          "order": this.orderProduct
        });
        if (orderProductResult != null)
          controller.addOrUpdateBag(orderProductResult as OrderProductDto);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      this.product.name,
                      style: context.textStyles.textExtraBold.copyWith(fontSize: 16)
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      this.product.description,
                      style: context.textStyles.textRegular.copyWith(fontSize: 12)
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      this.product.price.currencyPTBR,
                      style: context.textStyles.textMedium.copyWith(fontSize: 12, color: context.colors.secondary)
                    )
                  )
                ]
              )
            ),
            FadeInImage.assetNetwork(
              placeholder: "assets/images/loading.gif",
              image: product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover
            )
          ]
        )
      )
    );
  }
}