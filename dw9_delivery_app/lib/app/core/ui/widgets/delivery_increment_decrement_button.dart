import "package:flutter/material.dart";

import "package:dw9_delivery_app/app/core/ui/styles/colors_app.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";

class DeliveryIncrementDecrementButton extends StatelessWidget {
  final bool _compact;
  final int amout;
  final VoidCallback incrementTap;
  final VoidCallback decrementTap;

  const DeliveryIncrementDecrementButton({
    super.key,
    required this.amout,
    required this.incrementTap,
    required this.decrementTap,
  }) : this._compact = false;

  const DeliveryIncrementDecrementButton.compact({
    super.key,
    required this.amout,
    required this.incrementTap,
    required this.decrementTap,
  }) : this._compact = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this._compact ? const EdgeInsets.all(5) : null,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: this.decrementTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("-", style: context.textStyles.textMedium.copyWith(
                fontSize: this._compact ? 10 : 22,
                color: Colors.grey
              ))
            )
          ),
          Text(
            this.amout.toString(),
            style: context.textStyles.textRegular.copyWith(
              fontSize: this._compact ? 13 : 17,
              color: context.colors.secondary
            )
          ),
          InkWell(
            onTap: this.incrementTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "+",
                style: context.textStyles.textMedium.copyWith(
                  fontSize: this._compact ? 10 : 22,
                  color: context.colors.secondary
                )
              )
            )
          )
        ]
      )
    );
  }
}