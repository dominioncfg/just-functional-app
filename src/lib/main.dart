import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pages.dart';
import 'providers/providers.dart';

void main() {
  runApp(const JustFuncionalApp());
}

class JustFuncionalApp extends StatelessWidget {
  static const String title = "Just Functional";
  const JustFuncionalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiProvider(
        child: MaterialApp(
          title: title,
          theme: ThemeData(
              colorScheme: const ColorScheme.light().copyWith(
                primary: Colors.indigo,
                secondary: Colors.orangeAccent,
              ),
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    button: const TextStyle(color: Colors.white),
                  ),
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
          routes: {
            ExpressionListPage.route: (context) => const ExpressionListPage(
                  title: title,
                ),
            ExpressionDetailsPage.route: (context) =>
                const ExpressionDetailsPage(),
            ExpressionEditPage.route: (context) => const ExpressionEditPage(),
          },
        ),
        providers: [
          ChangeNotifierProvider(
            create: (_) => Expressions(),
          ),
        ],
      ),
    );
  }
}
