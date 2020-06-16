import 'package:bunky/pages/apt_settings.dart';
import 'package:bunky/pages/balancing.dart';
import 'package:bunky/pages/connectApartment.dart';
import 'package:bunky/pages/home.dart';
import 'package:bunky/pages/login.dart';
import 'package:bunky/pages/newApartment.dart';
import 'package:bunky/pages/notifications.dart';
import 'package:bunky/pages/settings.dart';
import 'package:bunky/pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:bunky/pages/createApartment.dart';
import 'package:bunky/pages/expenses.dart';
import 'package:bunky/pages/register.dart';

// Yuval - 11/6 18:00
// miriel 8/6 21:08
//miriel 16/6 11:40

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
//    '/': (context) => Loading(),
    '/login': (context) => Login(),
    '/newApartment': (context) => NewApartment(),
    '/createApartment': (context) => CreateApartment(),
    '/connectApartment': (context) => ConnectApartment(),
    '/home': (context) => Home(),
    '/expenses': (context) => Expenses(),
    '/duties': (context)=> Tasks(),
    '/settings': (context)=> Settings(),
    '/balancing': (context) => Balancing(),
    '/register': (context) => Register(),
    '/notifications': (context) => Notifications(),
    '/aptSettings': (context) => AptSettings(),
  },
));
