import 'package:flutter/material.dart';

class Logo{
  Widget getLogo(){
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
            child: Text(
              'Bunky',
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 187.0, 0.0, 0.0),
            child: Text(
              'Singin',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(227.0, 90.0, 0.0, 0.0),
            child: Text(
              '.',
              style: TextStyle(
                  fontSize: 120.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[300]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(230.0, 90.0, 0.0, 0.0),
            child: Text(
              '.',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(247.0, 90.0, 0.0, 0.0),
            child: Text(
              '.',
              style: TextStyle(
                  fontSize: 120.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[300]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(249.0, 90.0, 0.0, 0.0),
            child: Text(
              '.',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[600]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
