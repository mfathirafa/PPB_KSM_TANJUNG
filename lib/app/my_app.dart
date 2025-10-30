import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const whatsappGreen = Color(0xFF25D366);

    return MaterialApp(
      title: 'KSM Tanjung Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: whatsappGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: whatsappGreen,
          primary: whatsappGreen,
          secondary: whatsappGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: whatsappGreen,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: whatsappGreen,
            side: const BorderSide(color: whatsappGreen),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: whatsappGreen,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
