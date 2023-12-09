part of '../main.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.title});

  final String title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("Back to First Page")),
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
                  child: const Text("Press me 3!")),
            ),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero))),
            child: const Text("My Test 3 Button"),
          ),
        ),
      ]),
    );
  }
}
