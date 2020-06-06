import 'package:bunky/pages/balancing.dart';
import 'package:bunky/pages/connectApartment.dart';
import 'package:bunky/pages/home.dart';
import 'package:bunky/pages/loading.dart';
import 'package:bunky/pages/login.dart';
import 'package:bunky/pages/newApartment.dart';
import 'package:bunky/pages/notifications.dart';
import 'package:bunky/pages/settings.dart';
import 'package:bunky/pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:bunky/pages/createApartment.dart';
import 'package:bunky/pages/expenses.dart';
import 'package:bunky/pages/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Yuval - 4.6 19:50
//miriel 02/06 23:32
//miriel 6/6 21:46

void main() => runApp(MaterialApp(
//  localizationsDelegates: [
//    // ... app-specific localization delegate[s] here
//    GlobalMaterialLocalizations.delegate,
//    GlobalWidgetsLocalizations.delegate,
//  ],
//  supportedLocales: [
//    const Locale('en', 'US'), // English
//    const Locale('he'), // Hebrew
//    const Locale('zh'), // Chinese
//    // ... other locales the app supports
//  ],
  initialRoute: '/login',
  routes: {
//    '/': (context) => Loading(),
    '/login': (context) => Login(),
    '/newApartment': (context) => NewApartment(),
    '/createApartment': (context) => CreateApartment(),
    '/connectApartment': (context) => ConnectApartment(),
    '/home': (context) => Home(),
    '/expenses': (context) => Expenses(),
    '/tasks': (context)=> Tasks(),
    '/settings': (context)=> Settings(),
    '/balancing': (context) => Balancing(),
    '/register': (context) => Register(),
    '/notifications': (context) => Notifications(),
  },
));
