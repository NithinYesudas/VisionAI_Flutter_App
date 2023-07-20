import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_ai/providers/auth_provider.dart';
import 'package:vision_ai/screens/audio_translation_screen.dart';
import 'package:vision_ai/screens/home_screen.dart';
import 'package:vision_ai/screens/login_screen.dart';
import 'package:vision_ai/screens/script_generator_screen.dart';
import 'package:vision_ai/screens/signup_screen.dart';
import 'package:vision_ai/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AuthProvider>(context, listen: false).checkAuthState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        SignUpScreen.routeName: (ctx) => const SignUpScreen(),
        AudioTranslationScreen.routeName: (ctx) => AudioTranslationScreen(),
        ScriptGenerationScreen.routeName: (ctx) => ScriptGenerationScreen(),
      },
      home: Consumer(
        builder: (context, AuthProvider auth, child) {
          if (auth.isAuthenticated == null) {
            return const SplashScreen();
          }
          if (auth.isAuthenticated == false) {
            return const LoginScreen();
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
