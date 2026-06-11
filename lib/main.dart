import 'package:flutter/material.dart';
import 'package:inventflow/view_model/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00695C),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00695C),
            brightness: Brightness.dark,
          ),
        ),
        home: OnboardViewModel(),
      ),
    ),
  );
}
