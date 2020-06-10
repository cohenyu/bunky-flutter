//import 'package:flutter/material.dart';
//import 'package:bunky/models/task.dart';
//import 'package:bunky/widgets/bottom_navy_bar.dart';
//
//class WeekPage extends StatefulWidget {
//  @override
//  _WeekPageState createState() => _WeekPageState();
//}
//
//
////final List<Task>_taskList=[
////  Task(frequency: 'every day',performers:'yuval',task_name: 'claen the room',isFinish:true),
////  Task(frequency: 'every week',performers:'miriel',task_name: 'make food for dinner',isFinish:true),
////  Task(frequency: 'every day',performers:'or',task_name: 'claen the toilete',isFinish:true),
////  Task(frequency: 'every month',performers:'yuval',task_name: 'take the dog to trip',isFinish:false),
////];
//class _WeekPageState extends State<WeekPage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        bottomNavigationBar: BottomNavyBar(),
//        body: Stack(
//          children: <Widget>[
//            SingleChildScrollView(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  SizedBox(height: 25,),
//                  Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 25.5, vertical: 30.0),
//                    child: Row(
//                      children: <Widget>[
//                        Icon(
//                          Icons.insert_chart,
//                          color: Colors.black.withOpacity(0.7),
//                          size: 30.0,
//                        ),
//                        SizedBox(width: 10,),
//                        Text(
//                          'Tasks',
//                          style: TextStyle(
//                              color: Colors.black.withOpacity(0.7),
//                              fontWeight: FontWeight.bold,
//                              fontSize: 32.0
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  _button_icon(context),
//                  Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 5.0),
//                    child: Container(
//                      width: double.infinity,
//                      height: 400.0,
//                      decoration: BoxDecoration(
//                        color: Colors.amber[200],
//                        borderRadius: BorderRadius.all(Radius.circular(20)),
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.black.withOpacity(0.1),
//                              offset: Offset(0.0, 0.3),
//                              blurRadius: 15.0
//                          ),
//                        ],
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(height: 20,),
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(1, 0,170,0),
//                            child: Text("your Task for Today:",style: TextStyle(fontSize: 20.0,),),
//                          ),
//                          SizedBox(height: 10.0,),
//                        ],
//                      ),
////                      child: Column(
////                        children: <Widget>[
////                          Padding(
////                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
////                            child: Row(
////                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                              children: <Widget>[
////                                Column(
////                                  crossAxisAlignment: CrossAxisAlignment.start,
////                                  mainAxisSize: MainAxisSize.min,
////                                  children: <Widget>[
////                                    //defult home task that need to be in every week
////                                    Text(
////                                      'Tasks for this week:',
////                                      style: TextStyle(
////                                          color: Colors.black,
////                                          fontSize: 22.0,
////                                          fontWeight: FontWeight.bold
////                                      ),
////                                    ),
////                                    SizedBox(height: 15.0,),
////                                    Text(
////                                      'Wash dishes\n' 'Clean the home\n''Take off garbage\n',
////                                      style: TextStyle(
////                                          color: Colors.black,
////                                          fontSize: 18.0
////                                      ),
////                                    )
////                                  ],
////                                ),
//////                                IconButton(
//////                                  icon: Icon(
//////                                    Icons.today,
//////                                  ),
//////                                  onPressed: (){
//////
//////                                  },
//////                                  color: Colors.white,
//////                                  iconSize: 30.0,
//////                                )
////                              ],
////                            ),
////                          )
////                        ],
////                      ),
//                    ),
//                  ),
////                  tasksList.isEmpty ? Padding(
////                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
////                    child: Text(
////                      'No Tasks yet',
////                      style: TextStyle(
////                          color: Colors.black.withOpacity(0.7),
////                          fontSize: 20.0,
////                          fontWeight: FontWeight.bold
////                      ),
////                    ),
////                  ): Padding(
////                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
////                    child: Text(
////                      'Scedual Appartment Tasks:',
////                      style: TextStyle(
////                          color: Colors.black.withOpacity(0.7),
////                          fontSize: 20.0,
////                          fontWeight: FontWeight.bold
////                      ),
////                    ),
////                  ),
//                  SizedBox(height: 25.0),
//                  Padding(
//                    padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
//                  ),
//                  SizedBox(height: 70,)
//                ],
//              ),
//            ),
////            Padding(
////              padding: const EdgeInsets.all(10.0),
////              child: Align(
////                alignment: Alignment.bottomRight,
////                child: FloatingActionButton(
////                  child: Icon(
////                      Icons.add
////                  ),
////                  onPressed: (){
////                    setState(() {
////                      showAddDialog();
////                    });
////                  },
////                  backgroundColor: Colors.pink.withOpacity(0.9),
////                ),
////              ),
////            ),
//          ],
//        )
//    );
//  }
//
//  Widget _taskUncomlete(String task) {
//    return Padding(
//      padding: const EdgeInsets.only(left: 20.0, bottom: 24.0),
//      child: Row(
//        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.radio_button_unchecked,
//              color: Colors.teal,
//            ),
//            onPressed: () {
//              //to move to compelete and change icon
//              setState(() {
//
//              });
//            },
//          ),
////          Icon(
////            Icons.radio_button_unchecked,
//////            color:Theme.of(context).accentColor,
////            color: Colors.teal,
////            size: 30,
////          ),
//          SizedBox(
//            width: 2,
//          ),
//          Text(task, style: TextStyle(fontSize: 20,),),
//        ],
//      ),
//    );
//  }
//
//  Widget _taskComlete(String task) {
//    return Container(
//      foregroundDecoration: BoxDecoration(color: Color(0x60FD)),
//      child: Padding(
//        padding: const EdgeInsets.only(left: 20.0, top: 24.0),
//        child: Row(
//          children: <Widget>[
////            Icon(
////              Icons.radio_button_checked,
//////              color:Theme.of(context).accentColor,
////              color: Colors.teal,
////              size: 30,
////            ),
//            IconButton(
//              icon: Icon(Icons.radio_button_checked,
//                color: Colors.teal,
//              ),
//              onPressed: () {
//                //to move to compelete and change icon
//                setState(() {
////                  _taskList[1].isFinish=false;
//                });
//              },
//            ),
//            SizedBox(
//              width: 2,
//            ),
//            Text(task, style: TextStyle(fontSize: 20,),)
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _button_icon(BuildContext context){
//    return Row(
//      children: <Widget>[
//        Expanded(
//          child: RaisedButton.icon(
//            color: Colors.teal,
//            icon: Icon(Icons.playlist_add_check),
//            onPressed: (){
//              //dayShowDialog();
//            },
//            label: Text(
//              "Day",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        ),
//        Expanded(
//          child:RaisedButton.icon(
//            color: Colors.teal,
//            icon: Icon(Icons.view_week),
//            onPressed: (){
//              Navigator.pushNamed(context, '/week');
//            },
//            label: Text(
//              "Week",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        ),
//        Expanded(
//          child: RaisedButton.icon(
//            color: Colors.teal,
////          color: Colors.amber[200],
//            icon: Icon(Icons.today),
//            onPressed: (){
//
//            },
//            label: Text(
//              "Month",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        )
//      ],
//    );
//  }
//
//
////  void showAddDialog(){
////    TextEditingController performerController = new TextEditingController();
////    TextEditingController frequencyController = new TextEditingController();
////    showDialog(
////        context: context,
////        builder: (BuildContext context){
////          return AlertDialog(
////            shape: RoundedRectangleBorder(
////                borderRadius: BorderRadius.all(Radius.circular(20.0))
////            ),
////            backgroundColor: Colors.teal[100],
////            content: Container(
////              height: 250,
////              width: 500,
////              child: Column(
////                crossAxisAlignment: CrossAxisAlignment.center,
////                mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                children: <Widget>[
////                  SizedBox(height: 10,),
////                  Text(
////                    'Add new Task',
////                    style: TextStyle(
////                        fontWeight: FontWeight.bold,
////                        color: Colors.black,
////                        fontSize: 20
////                    ),
////                  ),
////                  SizedBox(height: 10,),
////                  Padding(
////                    padding: const EdgeInsets.only(left: 10, right: 10),
////                    child: Container(
////                      child: SizedBox(
////                        width: 500,
////                        height: 40,
////                        child: RaisedButton(
////                          //color:Colors.teal[100],
////                          color: Colors.teal.withOpacity(0.2),
////                          child:
//////                          TextField(
//////                            decoration: InputDecoration(
//////                                border: InputBorder.none,
//////                                hintText: "press to choose partisipans"
//////                            ),
//////                          ),
////                          Text("press to choose partisipans",
////                            style: TextStyle(
////                                color: Colors.black45,
////                                //fontWeight: FontWeight.bold,
////                                fontSize: 18.0
////                            ),
////                          ),
////                          onPressed: ()=> _showMultiSelect(context),
////                        ),
////                      ),
//////                      child: TextField(
//////                        controller: frequencyController,
//////                        decoration: InputDecoration(
//////                            hintText: 'preformer',
//////                            enabledBorder: UnderlineInputBorder(
//////                                borderSide: BorderSide(color: Colors.black)
//////                            )
//////                        ),
//////                      ),
////                    ),
////                  ),
////                  SizedBox(height: 10.0,),
////                  MyDropDown(),
////                  Padding(
////                    padding: const EdgeInsets.only(left: 10, right: 10),
////                    child: Container(
////                      child: TextField(
////                        controller: performerController,
////                        decoration: InputDecoration(
////                            hintText: 'task name',
////                            enabledBorder: UnderlineInputBorder(
////                                borderSide: BorderSide(color: Colors.black)
////                            )
////                        ),
////                      ),
////                    ),
////                  ),
////                  SizedBox(height: 10,),
////                  Row(
////                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                    children: <Widget>[
////                      RaisedButton(
////                        color: Colors.pink[800],
////                        child: Text(
////                          "Cancel",
////                          style: TextStyle(
////                              color: Colors.white,
////                              fontWeight: FontWeight.bold,
////                              fontSize: 15.0
////                          ),
////                        ),
////                        onPressed: (){
////                          Navigator.pop(context);
////                        },
////                      ),
////                      RaisedButton(
////                        color: Colors.pink[800],
////                        child: Text(
////                          "Add",
////                          style: TextStyle(
////                              color: Colors.white,
////                              fontWeight: FontWeight.bold,
////                              fontSize: 15.0
////                          ),
////                        ),
////                        onPressed: (){
////                          if(performerController.text != ''){
////                            addTask(frequencyController.text ,performerController.text,'Clean');
////                            Navigator.pop(context);
////                          }
////                        },
////                      )
////                    ],
////                  )
////                ],
////              ),
////            ),
////          );
////        }
////    );
////  }
//}