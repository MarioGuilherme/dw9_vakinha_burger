import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";

mixin Loader<T extends StatefulWidget> on State<T> {
  bool isOpen = false;

  void showLoader() {
    if (!this.isOpen) {
      this.isOpen = true;
      showDialog(
        context: context,
        builder: (BuildContext context) => LoadingAnimationWidget.threeArchedCircle(
          color: Colors.white,
          size: 60
        )
      );
    }
  }

  void hideLoader() {
    if (this.isOpen) {
      this.isOpen = false;
      Navigator.of(context).pop();
    }
  }
}