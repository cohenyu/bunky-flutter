import 'package:flutter/material.dart';

class Logo{
  String title;

  Logo({this.title});

  Widget getLogo(){
    return Container(
      height: 230.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 15.0,
            top: 110.0,
            child: Text(
              'Bunky',
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 190,
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 227.0,
            top: 90.0,
            child: Container(
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: 120.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[300]
                ),
              ),
            ),
          ),
          Positioned(
            left: 230.0,
            top: 90.0,
            child: Container(
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink
                ),
              ),
            ),
          ),
          Positioned(
            left: 247.0,
            top: 90.0,
            child: Container(
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: 120.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[300]
                ),
              ),
            ),
          ),
          Positioned(
            left: 249.0,
            top: 90.0,
            child: Container(
              child: Text(
                '.',
                style: TextStyle(
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[600]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
