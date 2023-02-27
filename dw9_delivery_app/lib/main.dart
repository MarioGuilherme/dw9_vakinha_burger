import "package:flutter/material.dart";

import "package:dw9_delivery_app/app/core/config/env/env.dart";
import "package:dw9_delivery_app/app/dw9_delivery_app.dart";

void main() async {
  await Env.instance.load();
  runApp(Dw9DeliveryApp());
}