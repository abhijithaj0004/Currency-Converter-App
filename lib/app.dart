
import 'package:currency_converter/presentation/screens/auth/login_screen.dart';
import 'package:currency_converter/presentation/screens/home/home_screen.dart';
import 'package:currency_converter/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    // Hide splash after a minimum duration
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: _showSplash
          ? const SplashScreen()
          : BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                switch (state.status) {
                  case AppStatus.authenticated:
                    return const HomeScreen();
                  case AppStatus.unauthenticated:
                    return const LoginScreen();
                  case AppStatus.unknown:
                  default:
                    return const SplashScreen();
                }
              },
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
