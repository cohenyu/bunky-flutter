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

// Yuval - 20.5 14:10
//miriel 02/06 23:32

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/': (context) => Loading(),
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
