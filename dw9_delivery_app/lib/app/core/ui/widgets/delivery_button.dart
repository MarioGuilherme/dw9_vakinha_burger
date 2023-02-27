import "package:flutter/material.dart";

class DeliveryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final double? heigth;

  const DeliveryButton({
    required this.label,
    required this.onPressed,
    this.width,
    this.heigth = 50,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      height: this.heigth,
      child: ElevatedButton(
        onPressed: this.onPressed,
        child: Text(this.label)
      )
    );
  }
}