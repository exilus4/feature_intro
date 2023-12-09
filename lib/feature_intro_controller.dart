part of 'feature_intro.dart';

class FeatureIntroController {
  final List<_FeatureIntroStepState> _steps = [];
  final List<_FeatureIntroStepState> _renderSteps = [];

  final ValueNotifier _isRender = ValueNotifier(false);
  final ValueNotifier<bool> _isNext = ValueNotifier(false);
  final ValueNotifier<bool> _isPrevious = ValueNotifier(false);

  FeatureIntroController();

  void _setRenderIntroStepKeys(List<FeatureIntroStepKey> stepKeys) {
    if (_steps.isEmpty) {
      throw Exception("No IntroStep intialized.");
    }
    _renderSteps.clear();
    for (var stepKey in stepKeys) {
      try {
        _renderSteps
            .add(_steps.singleWhere((step) => step.widget.stepKey == stepKey));
      } catch (ex) {
        throw Exception("IntroStepKey is not found in IntroStep List.");
      }
    }
    _isRender.value = true;
  }

  void next() {
    _isNext.value = !_isNext.value;
  }

  void previous() {
    _isPrevious.value = !_isPrevious.value;
  }

  void close() {
    _isRender.value = false;
  }
}
