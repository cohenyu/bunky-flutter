import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bunky/models/task.dart';
import 'package:bunky/widgets/drop_down_category_tasks.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  List<TasksItem> tasksList = [
    TasksItem('yuval','wash','every week'),
    TasksItem('yuval','clean','every week'),
    TasksItem('yuval','living roon organize','every day')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavyBar(),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 25,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.5, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.insert_chart,
                          color: Colors.black.withOpacity(0.7),
                          size: 30.0,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Tasks',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      width: double.infinity,
                      height: 250.0,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0.0, 0.3),
                                blurRadius: 15.0
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    //defult home task that need to be in every week
                                    Text(
                                      'Tasks for this week:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 15.0,),
                                    Text(
                                      'Wash dishes\n' 'Clean the home\n''Take off garbage\n',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.today,
                                  ),
                                  onPressed: (){

                                  },
                                  color: Colors.white,
                                  iconSize: 30.0,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  tasksList.isEmpty ? Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
                    child: Text(
                      'No Tasks yet',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ): Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
                    child: Text(
                      'Scedual Appartment Tasks:',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
                    child: Column(
                      children: tasksList,
                    ),
                  ),
                  SizedBox(height: 70,)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(
                      Icons.add
                  ),
                  onPressed: (){
                    setState(() {
                      showAddDialog();
                    });
                  },
                  backgroundColor: Colors.pink.withOpacity(0.9),
                ),
              ),
            ),
          ],
        )
    );
  }



  void showAddDialog(){
    TextEditingController performerController = new TextEditingController();
    TextEditingController frequencyController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            backgroundColor: Colors.teal[100],
            content: Container(
              height: 250,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text(
                    'Add new Task',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  MyDropDown(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: TextField(
                        controller: performerController,
                        decoration: InputDecoration(
                            hintText: 'preformer',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: TextField(
                        controller: frequencyController,
                        decoration: InputDecoration(
                            hintText: 'frequency',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.pink[800],
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.pink[800],
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0
                          ),
                        ),
                        onPressed: (){
                          if(performerController.text != ''){
                            addTask(performerController.text,'Clean', frequencyController.text );
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  void addTask(String performer, String category,String frequency){
//    http post
    setState(() {
      tasksList.add(TasksItem(performer,category,frequency));
    });
  }

}


class TasksItem extends StatelessWidget {
  final Task task;

  TasksItem(String performer,String name,String frequency) : task = Task(performer: performer,name: name,frequency:frequency);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.teal.withOpacity(0.2),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    this.task.performer,
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SizedBox(width: 25.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.task.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                  this.task.frequency,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  )
              )
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
