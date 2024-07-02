import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // TODO: button 'где искать'
          Align(
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
