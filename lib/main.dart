import 'package:apis/paginas/list_page.dart';
import 'package:apis/paginas/savePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ListPage.ROUTE,
      routes: {
        ListPage.ROUTE: (_) => ListPage(),
        SavePage.ROUTE: (_) => SavePage()
      },
    );
  }
}
