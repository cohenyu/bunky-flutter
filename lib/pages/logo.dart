import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo{
  String title;

  Logo({this.title});


  Widget getLogo(){
    return Container(
      height: 250.0,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            left: 15.0,
            top: 110.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Bunky',
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -20.0,
                          left: 20,
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 120.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[300]
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20.0,
                          left: 20.0,
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 100.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink
                            ),
                          ),
                        ),
                        Positioned(
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 120.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20.0,
                          left: 3.0,
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 100.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[600]
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20.0,
                          left: 0.0,
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 120.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[300]
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '.',
                    style: TextStyle(
                        fontSize: 120.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 195,
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
