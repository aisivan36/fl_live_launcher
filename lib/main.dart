import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: "Launcher RiverPod",
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.red,
          colorScheme: const ColorScheme.dark(onSecondary: Colors.red),
        ),
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              switch (settings.name) {
                case "apps":
                  return const ShowHideAppBar();
                default:
                  return const HomePage();
              }
            },
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 70,
            child: Center(
                child: IconButton(
              icon: const Icon(Icons.apps, color: Colors.white, size: 35),
              onPressed: () => Navigator.pushNamed(context, 'apps'),
            )),
          ),
        ),
      ),
    );
  }
}
