part of 'feature_intro.dart';

///
/// FeatureIntroStepKey should declared as custom enums
///
class FeatureIntroStepKey {
  final Key key;
  final bool initStepAfterStart;

  const FeatureIntroStepKey(
      {required this.key, this.initStepAfterStart = false});
}

///
/// FeatureIntroStep is a widget to bind related feature_intro object. For example: FeatureIntroStepKey, FeatureIntroController, FeatureIntro display content, etc.
///
class FeatureIntroStep extends StatefulWidget {
  const FeatureIntroStep({
    super.key,
    required this.controller,
    required this.stepKey,
    this.highlightInnerPadding = 0,
    this.highlightAnimatedPositionDuration = const Duration(milliseconds: 300),
    this.contentAlignment = FeatureIntroContentAligment.auto,
    this.contentOffset = const Offset(0, 0),
    this.nextStepWhenClickedOutbound = false,
    required this.content,
    required this.child,
  });

  final FeatureIntroController controller;
  final FeatureIntroStepKey stepKey;
  final int highlightInnerPadding;
  final Duration highlightAnimatedPositionDuration;
  final FeatureIntroContentAligment contentAlignment;
  final Offset contentOffset;
  final bool nextStepWhenClickedOutbound;
  final Widget content;
  final Widget child;

  @override
  State<FeatureIntroStep> createState() => _FeatureIntroStepState();
}

class _FeatureIntroStepState extends State<FeatureIntroStep>
    with WidgetsBindingObserver {
  late Offset _currentIntroStepOffset;
  late Size _currentIntroStepSize;

  bool _finishInit = false;

  Timer? _rebuildTimer;

  @override
  void initState() {
    super.initState();
    if (widget.controller._steps.any((element) =>
        element.widget.stepKey.key.hashCode == widget.stepKey.key.hashCode)) {
      throw Exception("IntroStep preset stepKey should unique.");
    }
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _currentIntroStepOffset = renderBox.localToGlobal(Offset.zero);
      _currentIntroStepSize = context.size!;
      _finishInit = true;
      if (widget.stepKey.initStepAfterStart && widget.controller._isRender.value) {
        widget.controller._isOverlayRebuild.value =
            !widget.controller._isOverlayRebuild.value;
      }
    });
    widget.controller._steps.add(this);
  }

  @override
  void didChangeMetrics() {
    if (_rebuildTimer != null && _rebuildTimer!.isActive) {
      _rebuildTimer!.cancel();
    }
    _rebuildTimer = Timer(const Duration(milliseconds: 1), () {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      _currentIntroStepOffset = renderBox.localToGlobal(Offset.zero);
      _currentIntroStepSize = context.size!;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller._steps.remove(this);
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
