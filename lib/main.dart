import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kando/screens/home.dart';
import 'package:kando/models/db.dart';

Future<void> main(List<String> args) async {
  await Mongo.connect();
  WidgetsFlutterBinding.ensureInitialized();
  await SP.connect();
  runApp(KanDo());
}

GlobalKey<HomePageState> pageKey = GlobalKey();

class KanDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KanDo',
      debugShowCheckedModeBanner: false,
      theme: Themes.dark,
      home: HomePage(
        key: pageKey,
      ),
    );
  }
}

class Themes {
  static var dark = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xff070c17),
    textTheme: TextTheme(
      bodyText1: GoogleFonts.poppins(
        color: const Color(0xfff1554e),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: GoogleFonts.poppins(
        color: const Color(0xfff1554e),
        fontSize: 20,
        decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.bold,
      ),
      headline1: GoogleFonts.poppins(
        color: const Color(0xff95B2B8),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headline2: GoogleFonts.poppins(
        color: const Color(0xffFEB95F),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
