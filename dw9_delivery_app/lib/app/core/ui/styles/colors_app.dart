import "package:flutter/material.dart";

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get instance {
    ColorsApp._instance ??= ColorsApp._();
    return ColorsApp._instance!;
  }

  Color get primary => const Color(0xFF007D21);
  Color get secondary => const Color(0xFFF88B0C);
}

extension ColorsAppExtensions on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}