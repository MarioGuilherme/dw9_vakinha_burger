import "package:bloc/bloc.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dw9_delivery_app/app/core/ui/helpers/loader.dart";
import "package:dw9_delivery_app/app/core/ui/helpers/messages.dart";

abstract class BaseState<T extends StatefulWidget, C extends BlocBase<dynamic>> extends State<T> with Loader<T>, Messages<T> {
  late final C controller;

  @override
  void initState() {
    super.initState();
    this.controller = context.read<C>();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) => this.onReady());
  }

  void onReady() {}
}