import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.yellow,
          secondary: Colors.yellowAccent,
          background: Colors.black,
          surface: Colors.black,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.lightGreen,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
          primaryVariant: Colors.amber,
          secondaryVariant: Colors.amberAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
