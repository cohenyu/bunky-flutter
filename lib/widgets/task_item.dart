import 'package:flutter/material.dart';
import 'package:bunky/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem(this.task);


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      width: MediaQuery.of(context).size.width - 100,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0,),
                        child: Column(
                          children: <Widget>[
                            Text(
                              this.task.task_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Text(
                              '${this.task.frequency}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black.withOpacity(0.7),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      //"Next:Yuval",
                      "Next: "+this.task.nextUserTask.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.pink.withOpacity(0.7)
                      ),
                    )
                  ],
                ),
              ),
//              SizedBox(width: 25.0,),
//              Expanded(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(right: 8.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                  this.expanse.value % 1 == 0 ? '${this.expanse.value.toInt()}': '${this.expanse.value}',
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontWeight: FontWeight.bold
//                                  )
//                              ),
//                              SizedBox(width: 2,),
//                              Text(
//                                  '\$',
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 17.0,
//                                      fontWeight: FontWeight.bold
//                                  )
//                              ),
//                            ],
//                          ),
//                          Text(
//                            dateString,
//                            style: TextStyle(
//                              letterSpacing: 0.7,
//                              color: Colors.grey,
//                              fontSize: 14.0,
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    SizedBox(height: 5.0,),
//                    Row(
//
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          this.expanse.category,
//                          style: TextStyle(
//                              color: Colors.pink[300].withOpacity(0.7),
//                              fontSize: 19.0,
//                              fontWeight: FontWeight.bold
//                          ),
//                        ),
//                      ],
//                    ),
//                    this.expanse.title.isNotEmpty ? Text(
//                      this.expanse.title,
//                      softWrap: true,
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 17.0,
//                      ),
//                    ): SizedBox.shrink(),
//                  ],
//                ),
//              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Divider(),
        ),
      ],
    );
  }
}
