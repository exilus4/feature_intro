part of 'feature_intro.dart';

class _FeatureIntroWidget extends StatelessWidget {
  const _FeatureIntroWidget({required this.controller, required this.child});

  final FeatureIntroController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      _FeatureIntroOverlayWidget(controller: controller),
    ]);
  }
}
