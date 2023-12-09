part of 'feature_intro.dart';

class FeatureIntroController {
  final List<_FeatureIntroStepState> _steps = [];
  final List<FeatureIntroStepKey> _renderStepKeys = [];

  final ValueNotifier _isRender = ValueNotifier(false);
  final ValueNotifier<bool> _isNext = ValueNotifier(false);
  final ValueNotifier<bool> _isPrevious = ValueNotifier(false);
  final ValueNotifier<bool> _isOverlayRebuild = ValueNotifier(false);
  final ValueNotifier<int> _currentStepIndex = ValueNotifier(0);

  void Function()? _beforeStepInExecute;
  void Function()? _afterStepInExecute;

  FeatureIntroController();

  void _setRenderIntroStepKeys(List<FeatureIntroStepKey> stepKeys) {
    if (_steps.isEmpty) {
      throw Exception("No IntroStep intialized.");
    }
    _renderStepKeys.clear();
    _renderStepKeys.addAll(stepKeys);
    _isRender.value = true;
  }

  void next(
      {void Function()? beforeStepInExecute,
      void Function()? afterStepInExecute}) {
    _beforeStepInExecute = beforeStepInExecute;
    _afterStepInExecute = afterStepInExecute;
    _isNext.value = !_isNext.value;
  }

  void previous(
      {void Function()? beforeStepInExecute,
      void Function()? afterStepInExecute}) {
    _beforeStepInExecute = beforeStepInExecute;
    _afterStepInExecute = afterStepInExecute;
    _isPrevious.value = !_isPrevious.value;
  }

  void close(
      {void Function()? beforeStepInExecute,
      void Function()? afterStepInExecute}) {
    _beforeStepInExecute = beforeStepInExecute;
    _afterStepInExecute = afterStepInExecute;
    _isRender.value = false;
  }
}
