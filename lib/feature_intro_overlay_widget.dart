part of 'feature_intro.dart';

class _FeatureIntroOverlayWidget extends StatefulWidget {
  const _FeatureIntroOverlayWidget({required this.controller});

  final FeatureIntroController controller;

  @override
  State<_FeatureIntroOverlayWidget> createState() =>
      _FeatureIntroOverlayWidgetState();
}

class _FeatureIntroOverlayWidgetState extends State<_FeatureIntroOverlayWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final ValueNotifier<bool> _isOverlayRebuild = ValueNotifier(false);

  bool _isChangeMetrics = false;

  int _currentStepIndex = 0;

  Timer? _rebuildTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller._isNext.addListener(_controllerNextStepIndexListener);
    widget.controller._isPrevious
        .addListener(_controllerPreviousStepIndexListener);
    widget.controller._isRender.addListener(_controllerIsRenderListener);
  }

  @override
  void didChangeMetrics() {
    if (widget.controller._isRender.value) {
      if (_rebuildTimer != null && _rebuildTimer!.isActive) {
        _rebuildTimer!.cancel();
      }
      _isChangeMetrics = true;
      _rebuildTimer = Timer(const Duration(milliseconds: 1), () {
        _isOverlayRebuild.value = !_isOverlayRebuild.value;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller._isNext.removeListener(_controllerNextStepIndexListener);
    widget.controller._isPrevious
        .removeListener(_controllerPreviousStepIndexListener);
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller._isRender,
      builder: (context, value, child) {
        return Visibility(
            visible: value,
            child: MaterialApp(
              theme: Theme.of(context),
              home: Material(
                type: MaterialType.transparency,
                child: SafeArea(
                  child: ValueListenableBuilder(
                      valueListenable: _isOverlayRebuild,
                      builder: (context, value, child) {
                        final _FeatureIntroStepState step =
                            widget.controller._renderSteps[_currentStepIndex];
                        return Stack(
                          children: [
                            if (step.widget.nextStepWhenClickedOutbound) ...[
                              _outBoundNextWidget(),
                            ],
                            _highlightWidget(),
                            _contentWidget(),
                          ],
                        );
                      }),
                ),
              ),
            ));
      },
    );
  }

  Widget _highlightWidget() {
    final _FeatureIntroStepState step =
        widget.controller._renderSteps[_currentStepIndex];

    return StatefulBuilder(builder: (context, setState) {
      return ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedPositioned(
              duration: _isChangeMetrics
                  ? const Duration(microseconds: 0)
                  : step.widget.highlightAnimatedPositionDuration,
              top: step._currentIntroStepOffset.dy -
                  step.widget.highlightInnerPadding,
              left: step._currentIntroStepOffset.dx -
                  step.widget.highlightInnerPadding,
              width: step._currentIntroStepSize.width +
                  (step.widget.highlightInnerPadding * 2),
              height: step._currentIntroStepSize.height +
                  (step.widget.highlightInnerPadding * 2),
              child: IgnorePointer(
                ignoring: true,
                child: widget
                    .controller._renderSteps[_currentStepIndex].widget.child,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _contentWidget() {
    final Size screenSize = MediaQuery.of(context).size;

    final ValueNotifier<bool> isVisible = ValueNotifier(false);

    final _FeatureIntroStepState step =
        widget.controller._renderSteps[_currentStepIndex];

    return StatefulBuilder(
      builder: (context, setState) {
        double contentDx = 0;
        double contentDy = 0;

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Size contentSize = context.size!;

          contentDy = _calculateContentDy(contentSize, screenSize);
          contentDx = _calculateContentDx(contentSize, screenSize);

          isVisible.value = true;
        });

        return ValueListenableBuilder(
            valueListenable: isVisible,
            builder: (context, value, child) => value
                ? Stack(
                    children: [
                      Positioned(
                          top: contentDy,
                          left: contentDx,
                          child: widget.controller
                              ._renderSteps[_currentStepIndex].widget.content),
                    ],
                  )
                : Opacity(opacity: 0, child: step.widget.content));
      },
    );
  }

  Widget _outBoundNextWidget() {
    return InkWell(
      onTap: () => widget.controller.next(),
      splashFactory: NoSplash.splashFactory,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      child: Container(
        color: Colors.transparent,
        width: double.maxFinite,
        height: double.maxFinite,
      ),
    );
  }

  void _controllerNextStepIndexListener() {
    if (_currentStepIndex != widget.controller._renderSteps.length - 1) {
      _currentStepIndex += 1;
      _isChangeMetrics = false;
      _isOverlayRebuild.value = !_isOverlayRebuild.value;
    } else {
      widget.controller._isRender.value = false;
    }
  }

  void _controllerPreviousStepIndexListener() {
    if (_currentStepIndex != 0) {
      _currentStepIndex -= 1;
      _isChangeMetrics = false;
      _isOverlayRebuild.value = !_isOverlayRebuild.value;
    } else {
      widget.controller._isRender.value = false;
    }
  }

  void _controllerIsRenderListener() {
    if (!widget.controller._isRender.value) {
      _isChangeMetrics = true;
      _currentStepIndex = 0;
    }
  }

  double _calculateContentDx(Size contentSize, Size screenSize) {
    double contentDx = 0;

    _FeatureIntroStepState step =
        widget.controller._renderSteps[_currentStepIndex];

    double calculateLeft() {
      return contentDx = step._currentIntroStepOffset.dx -
          step.widget.highlightInnerPadding -
          step.widget.contentOffset.dx -
          contentSize.width -
          step.widget.contentOffset.dx;
    }

    double calculateRight() {
      return contentDx = step._currentIntroStepOffset.dx +
          step.widget.highlightInnerPadding +
          step.widget.contentOffset.dx +
          step._currentIntroStepSize.width;
    }

    double calculateCenter() {
      return contentDx = step._currentIntroStepOffset.dx -
          (contentSize.width / 2) +
          (step._currentIntroStepSize.width / 2);
    }

    switch (step.widget.contentAlignment) {
      case FeatureIntroContentAligment.auto:
        if (calculateCenter() < 0) {
          contentDx = 0;
        } else if (calculateCenter() > screenSize.width) {
          contentDx = screenSize.width;
        }
        break;
      case FeatureIntroContentAligment.bottom:
      case FeatureIntroContentAligment.top:
        calculateCenter();
        break;
      case FeatureIntroContentAligment.leftBottom:
      case FeatureIntroContentAligment.leftTop:
      case FeatureIntroContentAligment.left:
        calculateLeft();
        break;
      case FeatureIntroContentAligment.right:
      case FeatureIntroContentAligment.rightBottom:
      case FeatureIntroContentAligment.rightTop:
        calculateRight();
        break;
    }
    return contentDx;
  }

  double _calculateContentDy(Size contentSize, Size screenSize) {
    double contentDy = 0;

    _FeatureIntroStepState step =
        widget.controller._renderSteps[_currentStepIndex];

    double calculateBottom() {
      return contentDy = step._currentIntroStepOffset.dy +
          step.widget.highlightInnerPadding +
          step.widget.contentOffset.dy +
          step._currentIntroStepSize.height;
    }

    double calculateTop() {
      return contentDy = step._currentIntroStepOffset.dy -
          step.widget.highlightInnerPadding -
          step.widget.contentOffset.dy -
          contentSize.height;
    }

    double calculateCenter() {
      return contentDy = ((step._currentIntroStepOffset.dy -
          (contentSize.height / 2) +
          (step._currentIntroStepSize.height / 2)));
    }

    switch (step.widget.contentAlignment) {
      case FeatureIntroContentAligment.auto:
        if (calculateBottom() + contentSize.height > screenSize.height) {
          calculateTop();
        }
        if (contentDy <= 0) {
          calculateCenter();
        }
        break;
      case FeatureIntroContentAligment.leftBottom:
      case FeatureIntroContentAligment.rightBottom:
      case FeatureIntroContentAligment.bottom:
        calculateBottom();
        break;
      case FeatureIntroContentAligment.left:
      case FeatureIntroContentAligment.right:
        calculateCenter();
        break;
      case FeatureIntroContentAligment.leftTop:
      case FeatureIntroContentAligment.rightTop:
      case FeatureIntroContentAligment.top:
        calculateTop();
        break;
    }
    return contentDy;
  }
}
