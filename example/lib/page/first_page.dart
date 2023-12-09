part of '../main.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.title});

  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            onPressed: () {
              context.push("/second");
            },
            child: const Text("Go to Second Page")),
        OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              FeatureIntro.of(context).start(keys: [
                AppFeatureIntro.firstStep.key,
                AppFeatureIntro.secondStep.key,
                AppFeatureIntro.thirdStep.key
              ]);
            },
            child: const Text("Trigger intro")),
        Container(
            height: 100,
            color: Colors.red,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: FeatureIntroStep(
                    controller: FeatureIntro.of(context).controller,
                    stepKey: AppFeatureIntro.firstStep.key,
                    highlightInnerPadding: 5,
                    contentOffset: const Offset(0, 10),
                    content: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              FeatureIntro.of(context).controller.next();
                            },
                            child: const Text("Press me!")),
                      ),
                    ),
                    nextStepWhenClickedOutbound: true,
                    child: TextButton(
                      onPressed: () {},
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      child: const Text("Test"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FeatureIntroStep(
                    controller: FeatureIntro.of(context).controller,
                    stepKey: AppFeatureIntro.secondStep.key,
                    highlightInnerPadding: 5,
                    contentOffset: const Offset(0, 10),
                    content: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              FeatureIntro.of(context).controller.next(
                                beforeStepInExecute: () {
                                  context.push("/second");
                                },
                              );
                            },
                            child: const Text("Press me 2!")),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero))),
                      child: const Text("Test twice longer text"),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
