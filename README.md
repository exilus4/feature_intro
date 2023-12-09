## Features

A simple library for creating feature introduction.

## Getting started

Create a list of customized intro keys

```dart
enum AppFeatureIntro {
  firstStep(FeatureIntroStepKey(key: Key("firstStep"))),
  secondStep(FeatureIntroStepKey(key: Key("secondStep"))),
  thirdStep(FeatureIntroStepKey(key: Key("thirdStep")));

  final FeatureIntroStepKey key;

  const AppFeatureIntro(this.key);
}
```

Create a FeatureIntro widget

```dart
Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
        ),
        builder: (context, child) => FeatureIntro(controller: FeatureIntroController(), child: Container(child: child)));
}
```

## Usage

For example to start using the intro:

```dart
FeatureIntro.of(context).start(keys: [
    AppFeatureIntro.firstStep.key,
    AppFeatureIntro.secondStep.key,
    AppFeatureIntro.thirdStep.key
]);
```

For example to init step content:

```dart
FeatureIntroStep(
    controller: FeatureIntro.of(context).controller,
    stepKey: AppFeatureIntro.thirdStep.key,
    highlightInnerPadding: 5,
    contentOffset: const Offset(0, 10),
    content: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Center(
        child: TextButton(
            onPressed: () {
                FeatureIntro.of(context).controller.close();
            },
        child: const Text("Press me close!")),
    ),
    ),
    child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
        FeatureIntro.of(context).start(keys: [
            AppFeatureIntro.firstStep.key,
            AppFeatureIntro.secondStep.key,
            AppFeatureIntro.thirdStep.key
        ]);
        },
        child: const Text("Start intro")),
)
```

For example to next step:

```dart
FeatureIntro.of(context).controller.next();
```

For example to previous step:

```dart
FeatureIntro.of(context).controller.previous();
```

For example to close the intro:

```dart
FeatureIntro.of(context).controller.close();
```