import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";

import "package:flutter/material.dart";

class OrderField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final String hintText;

  const OrderField({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    const UnderlineInputBorder defaultBorder = UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                this.title,
                style: context.textStyles.textRegular.copyWith(overflow: TextOverflow.ellipsis, fontSize: 16)
              )
            )
          ),
          TextFormField(
            controller: this.controller,
            validator: this.validator,
            decoration: InputDecoration(
              hintText: this.hintText,
              border: defaultBorder,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder
            )
          )
        ]
      )
    );
  }
}