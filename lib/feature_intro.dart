library feature_intro;

import 'dart:async';

import 'package:flutter/material.dart';

part 'feature_intro_controller.dart';
part 'feature_intro_overlay_widget.dart';
part 'feature_intro_step.dart';
part 'feature_intro_widget.dart';

class FeatureIntro extends InheritedWidget {
  ///
  /// FeatureIntro.of(context)
  ///
  static FeatureIntro of(BuildContext context) {
    final instance = context.dependOnInheritedWidgetOfExactType<FeatureIntro>();
    if (instance == null) {
      throw ArgumentError("Can't get instance of Intro. "
          "Make sure you have defined a `Intro` widget in the widget tree "
          "before current widget and after MaterialApp.");
    }
    return instance;
  }

  final FeatureIntroController controller;

  FeatureIntro({
    super.key,
    required this.controller,
    required Widget child,
  }) : super(child: _FeatureIntroWidget(controller: controller, child: child));

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      child != oldWidget.child;

  ///
  ///  To start using feature intro, this function should called before next() / previous()
  ///
  void start({required List<FeatureIntroStepKey> keys}) {
    if (keys.isEmpty) {
      throw ArgumentError("Can't get any IntroStepKey. "
          "Please insert at least one IntroStepKey.");
    }
    controller._setRenderIntroStepKeys(keys);
  }
}

///
///  This enum used to be control content aligment
///
enum FeatureIntroContentAligment {
  auto,
  left,
  right,
  top,
  bottom,
  leftTop,
  leftBottom,
  rightTop,
  rightBottom;
}
