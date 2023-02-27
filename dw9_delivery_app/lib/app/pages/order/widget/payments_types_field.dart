import "package:flutter/material.dart";
import "package:flutter_awesome_select/flutter_awesome_select.dart";

import "package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/models/payment_type_model.dart";

class PaymentsTypesField extends StatelessWidget {
  final List<PaymentTypeModel> paymentTypes;
  final ValueChanged<int> valueChanged;
  final bool isValid;
  final String valueSelected;

  const PaymentsTypesField({
    super.key,
    required this.paymentTypes,
    required this.valueChanged,
    required this.isValid,
    required this.valueSelected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Formas de Pagamento", style: context.textStyles.textRegular.copyWith(fontSize: 16)),
          SmartSelect<String>.single(
            title: "",
            selectedValue: this.valueSelected,
            modalType: S2ModalType.bottomSheet,
            groupCounter: false,
            onChange: (S2SingleSelected<String> selected) => this.valueChanged(int.parse(selected.value)),
            tileBuilder: (BuildContext context, S2SingleState<String> state) => InkWell(
              onTap: state.showModal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: context.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          state.selected.title ?? "",
                          style: context.textStyles.textRegular
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ]
                    )
                  ),
                  Visibility(
                    visible: !this.isValid,
                    child: const Divider(color: Colors.red)
                  ),
                  Visibility(
                    visible: !this.isValid,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Selecione uma forma de pagamento",
                        style: context.textStyles.textRegular.copyWith(
                          fontSize: 13,
                          color: Colors.red
                        )
                      )
                    )
                  )
                ]
              )
            ),
            choiceItems: S2Choice.listFrom(
              source: this.paymentTypes.map((PaymentTypeModel paymentType) => <String, String>{
                "value": paymentType.id.toString(),
                "title": paymentType.name
              }).toList(),
              title: (int index, Map<String, String> item) => item["title"] ?? "",
              value: (int index, Map<String, String> item) => item["value"] ?? "",
              group: (int index, Map<String, String> item) => "Selecione uma forma de pagamento"
            ),
            choiceType: S2ChoiceType.radios,
            choiceGrouped: true,
            placeholder: "",
            modalFilter: true
          )
        ]
      )
    );
  }
}