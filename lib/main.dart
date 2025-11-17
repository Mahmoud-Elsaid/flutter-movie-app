import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/core/widgets/Movie_model.dart';
import 'dart:ui' as ui;

import 'package:movie_app/features/splash/presentation/ui_screens/splash_screen.dart';

class HiveServices {
  static late Box movieBox;
  static Future<void> initBox() async {
    movieBox = await Hive.openBox<MovieModel>('movies');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovieModelAdapter());

  await Hive.openBox('watchlistBox');

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, widget) {
        return Directionality(
          textDirection: context.locale.languageCode == "ar"
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: widget!,
        );
      },
      home: SplashScreen(),
    );
  }
}
