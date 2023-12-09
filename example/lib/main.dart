import 'package:feature_intro/feature_intro.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

part 'page/first_page.dart';
part 'page/second_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

enum AppFeatureIntro {
  firstStep(FeatureIntroStepKey(key: Key("firstStep"))),
  secondStep(FeatureIntroStepKey(key: Key("secondStep"))),
  thirdStep(
      FeatureIntroStepKey(key: Key("thirdStep"), initStepAfterStart: true));

  final FeatureIntroStepKey key;

  const AppFeatureIntro(this.key);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) =>
                  const FirstPage(title: 'My First Page'),
            ),
            GoRoute(
              path: "/second",
              builder: (context, state) =>
                  const SecondPage(title: 'My Second Page'),
            )
          ],
        ),
        builder: (context, child) => FeatureIntro(
              controller: FeatureIntroController(),
              child: Container(
                child: child,
              ),
            ));
  }
}
