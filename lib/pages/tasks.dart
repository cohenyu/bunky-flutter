
import 'dart:convert';
import 'package:bunky/models/task.dart';
import 'package:bunky/models/user.dart';
import 'package:bunky/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bunky/widgets/drop_down_category_tasks.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:http/http.dart' as http;

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  bool day_pressed_button = true;
  bool week_pressed_button = false;
  bool month_pressed_button = false;
  List<User> usersList = [];
  List<User> usersInApprtment = [];
  List<User> usersInApprtmentToDelete = [];

  List<User> participensInTask = [];
  Map data = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = 'https://bunkyapp.herokuapp.com';
  bool start = true;
  bool choosePartisipansIsPressed = false;

//  List<TasksItem> tasksList = [
//    TasksItem('every week','yuval','wash'),
//    TasksItem('every week','yuval','clean'),
//    TasksItem('every day','yuval','living roon organize')
//  ];

  List<Task> _taskList = [];
  List<Task> _allAppartmentTasks = [];
  List<Task> _dayTaskList = [];
  List<Task> _weekTaskList = [];
  List<Task> _monthTaskList = [];
  List<TaskItem> _aptTasks = [];

//  List<Task>_taskList=[
//    Task(frequency: 'every day',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'claen the room',isFinish:false),
//    Task(frequency: 'every week',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'make food for dinner',isFinish:false),
//    Task(frequency: 'every day',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'claen the toilete',isFinish:true),
//    Task(frequency: 'every month',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'take the dog to trip',isFinish:true),
//  ];
//
//  List<Task> _dayTaskList = [
//    Task(frequency: 'every day',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'claen the room',isFinish:false),
//    Task(frequency: 'every day',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'claen the toilete',isFinish:true),
//  ];
//  List<Task> _weekTaskList = [
//    Task(frequency: 'every week',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'make food for dinner',isFinish:false),
//  ];
//  List<Task> _monthTaskList = [
//    Task(frequency: 'every month',performers:[User('miriel','miriel@gmail.com',1),User('yuval','yuval@gmail.com',2)],task_name: 'take the dog to trip',isFinish:true),
//  ];

  @override
  void initState() {
//    _taskList=_dayTaskList;
//    getTaskList();
//    splitTasks(_taskList,_dayTaskList,_weekTaskList,_monthTaskList);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = ModalRoute.of(context).settings.arguments;
      getTaskList();
      getAllDuties();
      setState(() {
        _taskList = _dayTaskList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
//    data  = ModalRoute.of(context).settings.arguments;
//    if(start==true) {
//      getTaskList();
//      start=false;
//    }
    // splitTasks(_taskList, _dayTaskList, _weekTaskList, _monthTaskList);
//    data  = ModalRoute.of(context).settings.arguments;
    //_taskList=_dayTaskList;
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavyBar(),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 25.5, vertical: 30.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Duties',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0),
                        ),
                      ],
                    ),
                  ),
                  _button_icon(context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      width: 390.0,
                      height: 400.0,
                      decoration: BoxDecoration(
                        color: Colors.amber[200],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0.0, 0.3),
                              blurRadius: 15.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                            child: day_pressed_button
                                ? Text(
                              "Your duties for this day:",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                                : week_pressed_button
                                ? Text(
                              "Your duties for this week:",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                                : Text(
                              "Your duties for this month:",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //youtube
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: _taskList.length,
                              itemBuilder: (context, index) {
                                return _taskList[index].isFinish
                                    ? _taskComlete(
                                    _taskList[index].task_name, index)
                                    : _taskUncomlete(
                                    _taskList[index].task_name, index);
                              },
                            ),
                          ),

//                          Expanded(child: TaskPage()),
                        ],
                      ),
//                      child: Column(
//                        children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisSize: MainAxisSize.min,
//                                  children: <Widget>[
//                                    //defult home task that need to be in every week
//                                    Text(
//                                      'Tasks for this week:',
//                                      style: TextStyle(
//                                          color: Colors.black,
//                                          fontSize: 22.0,
//                                          fontWeight: FontWeight.bold
//                                      ),
//                                    ),
//                                    SizedBox(height: 15.0,),
//                                    Text(
//                                      'Wash dishes\n' 'Clean the home\n''Take off garbage\n',
//                                      style: TextStyle(
//                                          color: Colors.black,
//                                          fontSize: 18.0
//                                      ),
//                                    )
//                                  ],
//                                ),
////                                IconButton(
////                                  icon: Icon(
////                                    Icons.today,
////                                  ),
////                                  onPressed: (){
////
////                                  },
////                                  color: Colors.white,
////                                  iconSize: 30.0,
////                                )
//                              ],
//                            ),
//                          )
//                        ],
//                      ),
                    ),
                  ),
//                  _tasksList.isEmpty ? Padding(
//                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
//                    child: Text(
//                      'No Tasks yet',
//                      style: TextStyle(
//                          color: Colors.black.withOpacity(0.7),
//                          fontSize: 20.0,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _aptTasks.isNotEmpty ? showTasks() : hideTasks(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
//                    child: Column(
//                      children: tasksList,
//                    ),
//                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (){
                    setState(() {
                      showAddDialog();
                      getUsers();
                    });
                  },
//                  onPressed: () {
//                    setState(() {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => AddTaskPage(callback: (frequency, performers, task_name, isFinish){
//                          setState(() {
//                            sendAddTak(frequency, performers, task_name, isFinish);
//                          });
//                        },user: data['user'],)),
//                      );
//                    });
//                  },
                  backgroundColor: Colors.pink.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ));
  }

//git 08/06
//  @override
//  Widget build(BuildContext context) {
////    data  = ModalRoute.of(context).settings.arguments;
////    if(start==true) {
////      getTaskList();
////      start=false;
////    }
//    // splitTasks(_taskList, _dayTaskList, _weekTaskList, _monthTaskList);
////    data  = ModalRoute.of(context).settings.arguments;
//    //_taskList=_dayTaskList;
//    return Scaffold(
//        key: _scaffoldKey,
//        bottomNavigationBar: BottomNavyBar(),
//        body: Stack(
//          children: <Widget>[
//            SingleChildScrollView(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  SizedBox(
//                    height: 25,
//                  ),
//                  Padding(
//                    padding:
//                    EdgeInsets.symmetric(horizontal: 25.5, vertical: 30.0),
//                    child: Row(
//                      children: <Widget>[
//                        Text(
//                          'Tasks',
//                          style: TextStyle(
//                              color: Colors.black.withOpacity(0.3),
//                              fontWeight: FontWeight.bold,
//                              fontSize: 35.0),
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
//                              blurRadius: 15.0),
//                        ],
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(
//                            height: 20,
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(1, 0, 170, 0),
//                            child: day_pressed_button
//                                ? Text(
//                              "your Task for Today:",
//                              style: TextStyle(
//                                fontSize: 20.0,
//                              ),
//                            )
//                                : week_pressed_button
//                                ? Text(
//                              "your Task for Week:",
//                              style: TextStyle(
//                                fontSize: 20.0,
//                              ),
//                            )
//                                : Text(
//                              "your Task for Month:",
//                              style: TextStyle(
//                                fontSize: 20.0,
//                              ),
//                            ),
//                          ),
//                          SizedBox(
//                            height: 10.0,
//                          ),
//                          //youtube
//                          Expanded(
//                            child: ListView.builder(
//                              padding: const EdgeInsets.all(0),
//                              itemCount: _taskList.length,
//                              itemBuilder: (context, index) {
//                                return _taskList[index].isFinish
//                                    ? _taskComlete(
//                                    _taskList[index].task_name, index)
//                                    : _taskUncomlete(
//                                    _taskList[index].task_name, index);
//                              },
//                            ),
//                          ),
//
////                          Expanded(child: TaskPage()),
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
////                  _tasksList.isEmpty ? Padding(
////                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top:30),
////                    child: Text(
////                      'No Tasks yet',
////                      style: TextStyle(
////                          color: Colors.black.withOpacity(0.7),
////                          fontSize: 20.0,
////                          fontWeight: FontWeight.bold
////                      ),
////                    ),
////                  ):
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: _aptTasks.isNotEmpty ? showTasks() : hideTasks(),
//                  ),
//                  SizedBox(
//                    height: 30,
//                  ),
////                  Padding(
////                    padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
////                    child: Column(
////                      children: tasksList,
////                    ),
////                  ),
//                  SizedBox(
//                    height: 70,
//                  )
//                ],
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: Align(
//                alignment: Alignment.bottomRight,
//                child: FloatingActionButton(
//                  child: Icon(Icons.add),
//                  onPressed: () {
//                    setState(() {
//                      showAddDialog();
//                      getUsers();
//                    });
//                  },
//                  backgroundColor: Colors.pink.withOpacity(0.9),
//                ),
//              ),
//            ),
//          ],
//        ));
//  }

  List<Widget> hideTasks() {
    return [
      Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
        child: Text(
          'No tasks yet',
          style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  List<Widget> showTasks() {
    return [
      Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
        child: Text(
          'All Appartment Tasks:',
          style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 15.0),
      _aptTasks.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
        child: ListView.builder(
          physics: PageScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _aptTasks.length,
          itemBuilder: (context, int index) {
            return Dismissible(
              key: Key('${_aptTasks[index].task.id}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      backgroundColor: Colors.teal[100],
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("Confirm"),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Are you sure you wish to delete this task?",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.pink[700],
                                  fontSize: 17.0),
                            )),
                        FlatButton(
                          onPressed: () =>
                              Navigator.of(context).pop(false),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.pink[700],
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                deleteTaskRequest(index);
                setState(() {
                  _aptTasks.removeAt(index);
                  showSnackBar('Task deleted');
                });
              },
              background: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Container(
                  color: Colors.redAccent,
                  child: Center(
                    child: ListTile(
                      trailing: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ),
              child: _aptTasks[index],
            );
          },
        ),
      )
          : SizedBox.shrink(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0),
        child: Divider(
          thickness: 4.0,
        ),
      ),
    ];
  }


  void ShowUsersDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 100,
            width: 100,
            child: ReorderableListView(
              header: Text(
                'Participans',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  User user = usersList[oldIndex];
                  usersList.removeAt(oldIndex);
                  usersList.insert(newIndex, user);
                });
              },
              children: <Widget>[
                for (final u in usersList)
                  Dismissible(
                    background: Container(
                      color: Colors.redAccent,
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        usersList.removeAt(usersList.indexOf(u));
                      });
                    },
                    key: ValueKey(u),
                    child: ListTile(
                      key: ValueKey(u),
                      title: Text('item #$u'),
                      leading: Text('${usersList.indexOf(u)}'),
                      trailing: Icon(Icons.list),
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _showParticipans() {
    print("here");
    return Container(
      height: 400,
      width: 200,
      child: ReorderableListView(
        header: Text(
          'Participans',
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            User user = usersInApprtment[oldIndex];
            usersInApprtment.removeAt(oldIndex);
            usersInApprtment.insert(newIndex, user);
          });
        },
        children: <Widget>[
          for (final u in usersInApprtment)
            Dismissible(
              background: Container(
                color: Colors.redAccent,
              ),
              onDismissed: (direction) {
                setState(() {
                  usersInApprtment.removeAt(usersInApprtment.indexOf(u));
                });
              },
              key: ValueKey(u),
              child: ListTile(
                key: ValueKey(u),
                title: Text('item #$u'),
                leading: Text('${usersInApprtment.indexOf(u)}'),
                trailing: Icon(Icons.list),
              ),
            ),
        ],
      ),
    );
  }

  void showAddDialog() {
    String frequency;
    TextEditingController taskNameController = new TextEditingController();
    TextEditingController frequencyController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.teal[100],
            content: Container(
              height: 300,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add new Task',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(),
//                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: 50,
                      width: 400,
//                        child: ReorderableListView(
//                          header: Text(
//                            'Participans',
//                            style: TextStyle(),
//                          ),
//                          onReorder: (oldIndex, newIndex) {
//                            setState(() {
//                              User user = usersInApprtment[oldIndex];
//                              usersInApprtment.removeAt(oldIndex);
//                              usersInApprtment.insert(newIndex, user);
//                            });
//                          },
//                          children: <Widget>[
//                            for (final u in usersInApprtment)
//                              Dismissible(
//                                background: Container(
//                                  color: Colors.redAccent,
//                                ),
//                                onDismissed: (direction) {
//                                  setState(() {
//                                    usersInApprtment.removeAt(usersInApprtment.indexOf(u));
//                                  });
//                                },
//                                key: ValueKey(u),
//                                child: ListTile(
//                                  key: ValueKey(u),
//                                  title: Text('item #$u'),
//                                  leading: Text('${usersInApprtment.indexOf(u)}'),
//                                  trailing: Icon(Icons.list),
//                                ),
//                              ),
//                          ],
//                        ),
                      child: RaisedButton(
                        //color:Colors.teal[100],
                        color: Colors.teal.withOpacity(0.2),
                        child:
//                          TextField(
//                            decoration: InputDecoration(
//                                border: InputBorder.none,
//                                hintText: "press to choose partisipans"
//                            ),
//                          ),
                        Text(
                          "Press to choose partisipans",
                          style: TextStyle(
                              color: Colors.black45,
                              //fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        // onPressed: () => _showMultiSelect(context),
                        onPressed: () {
                          //ShowUsersDialog();
                          _showMultiSelect(context);
                          //choosePartisipansIsPressed=true;
                          setState(() {
                            //_showParticipans();
                          });
                        },
                      ),
//                      child: TextField(
//                        controller: frequencyController,
//                        decoration: InputDecoration(
//                            hintText: 'preformer',
//                            enabledBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(color: Colors.black)
//                            )
//                        ),
//                      ),

                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  MyDropDown(callback: (val) {
                    setState(() {
                      frequency = val;
                    });
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Container(
                      child: TextField(
                        controller: taskNameController,
                        decoration: InputDecoration(
                            hintText: 'task name',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                              fontSize: 15.0),
                        ),
                        onPressed: () {
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
                              fontSize: 15.0),
                        ),
                        onPressed: () {
                          if (taskNameController.text != '') {
                            sendAddTak(frequency, this.participensInTask,
                                taskNameController.text, false);
                            Navigator.pop(context);
                            //send to or
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> deleteTaskRequest(int index) async {
    Task task = _aptTasks[index].task;

    try {
      final response = await http
          .put('$url/removeDuty',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            task.id,
          ))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          print('***************** yes!!! deleted');
          return;
        } else {
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_) {
      showSnackBar('No Internet Connection');
    }

//  In case of error we don't want to delete the task
    setState(() {
      _aptTasks.insert(index, TaskItem(task));
    });
  }

  Future<void> getAllDuties() async {
//    setState(() {
//      isLoading = true;
//    });
    User user = data['user'];

//    try{
    final response = await http.get(
      '$url/getAllAptDuties?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 7));
    List jsonData = jsonDecode(response.body);
    print("all apprtment duties");
    print(jsonDecode(response.body));

    List<TaskItem> tmpAptTasks = [];
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        for (var jsonItem in jsonData) {
          tmpAptTasks.add(TaskItem(Task.fromJson(jsonItem)));
        }
      }
    } else {
      print('ERROR');
    }
    setState(() {
      _aptTasks = List.from(tmpAptTasks.reversed);
    });
//
//    setState(() {
//      isLoading = false;
//    });
//    }catch(_){
//      print('point 1');
//      showSnackBar('No Internet Connection');
//    }
  }

  //this function add tsk to each list by frequency
  void showAddTask(String frequency, List<User> performers, String task_name,
      bool isFinish,int id) {
//    http post
    setState(() {
      //_taskList.add(Task(frequency:frequency,performer:performer,task_name:task_name,isFinish:isFinish));
      if (frequency == "daily") {
        print("add to day");
        _dayTaskList.add(Task(
            frequency: frequency,
            performers: performers,
            task_name: task_name,
            isFinish: isFinish,
            id:id
        ));
      } else if (frequency == "weekly") {
        print("add to week");
        _weekTaskList.add(Task(
            frequency: frequency,
            performers: performers,
            task_name: task_name,
            isFinish: isFinish,
            id:id
        ));
      } else {
        print("add to month");
        _monthTaskList.add(Task(
            frequency: frequency,
            performers: performers,
            task_name: task_name,
            isFinish: isFinish,
            id:id
        ));
      }
      print(task_name);
      print(frequency);
      print(isFinish);
      print(performers);
      print(id);
    });
    //(frequency =="evey month")
  }

  void showSnackBar(String title) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.pink[50],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Colors.pink),
          ),
        ],
      ),
    ));
  }

  // This function update the comppletness of task in the server
  Future<void> updateTaskComletness(Task task) async {
    //Task task = _allAppartmentTasks[index];
    print("updateTaskComletness");

    try {
      final response = await http.put('$url/flipIsExecuted',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(task))
          .timeout(const Duration(seconds: 7));

      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        print("200 OK updateTaskComletness ");

        if (response.body.isNotEmpty) {
//          todo refresh charts if the date is between the range
          return;
        } else {
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_) {
      print('point 2');
      showSnackBar('No Internet Connection');
    }
  }

  Future<void> sendAddTak(String frequency, List<User> performers,
      String task_name, bool isFinish) async {
    setState(() {});
    try {
      //    http post
      User user = data['user'];
      for (User u in performers) {
        print("yuval check");
        print(u.name);
      }
      final response = await http
          .post('$url/addDuty',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'name': task_name,
            'participants': performers,
            'frequency': changeFrequencyNameToServer(frequency),
            'isExecuted': isFinish,
          }))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        print("200 OK Task");
        print("BODY RESPONSE");
        print(jsonDecode(response.body));
        print(jsonDecode(response.body)['participants'].runtimeType);
        Task task = Task.fromJson(jsonDecode(response.body));
        print(task.task_name);
        print(task.frequency);
        print(task.isFinish);
        print(task.performers);

        //showAddTask(frequency, performers, task_name, isFinish);
        setState(() {
          showAddTask(frequency, performers, task_name, isFinish,task.id);
          _aptTasks.insert(0, TaskItem(task));
        });
      } else {
        // showSnackBar('Error');
        print('somthing went worng');
      }
    } //end try
    catch (_) {
      print('point 3');
      showSnackBar('No Internet Connection');
    }
  } //end function

  Future<void> getUsers() async {
    try {
      User user = data['user'];
      final response = await http.get(
        'https://bunkyapp.herokuapp.com/allUsersOfAptByUser?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        print("get users");
        print("200 OK");
        if (response.body.isNotEmpty) {
          List jsonData = jsonDecode(response.body);
          List<User> usersNames = [];
          for (var jsonUser in jsonData) {
            User roommate = User.fromJson(jsonUser);
            usersNames.add(roommate);
          }
          setState(() {
            usersList = usersNames;
            usersInApprtment=usersNames;
          });
        }
      } else {
        print('Error');
      }
    } catch (_) {
      print('No Internet Connection');
    }
  }

  //this function bring all the user tasks
  Future<void> getTaskList() async {
    List<Task> listOfTaskFromServer = [];
    print("in all duty");
//    try{
    // data['user'].
    User user = data['user'];
    print(user.name);
    print(user.userId);
    print(user.mail);
    final response = await http.get(
      'https://bunkyapp.herokuapp.com/getMyDuties?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 6));

    print("the body response");
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      print("all task 200 OK");
      if (response.body.isNotEmpty) {
        List jsonData = jsonDecode(response.body);

        for (var jsonTask in jsonData) {
          Task userTask = Task.fromJson(jsonTask);
          setState(() {
            listOfTaskFromServer.add(userTask);
          });
        }
        print("listOfTaskFromServer");
        _allAppartmentTasks = listOfTaskFromServer;
        splitTasks(listOfTaskFromServer);
      }
    } else {
      print('Error');
    }
//    } catch (_){
//      print('No Internet Connection');
//    }
  }

  Widget _button_icon(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: RaisedButton.icon(
            color: day_pressed_button == true ? Colors.teal : Colors.teal[300],
            icon: Icon(Icons.playlist_add_check),
            onPressed: () {
//              day_pressed_button = true;
//              week_pressed_button = false;
//              month_pressed_button = false;
//              print(day_pressed_button);
//              print(week_pressed_button);
//              print(month_pressed_button);
              _taskList = _dayTaskList;

              setState(() {
                day_pressed_button = true;
                week_pressed_button = false;
                month_pressed_button = false;
              });
            },
            label: Text(
              "Day",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: RaisedButton.icon(
            color: week_pressed_button == true ? Colors.teal : Colors.teal[300],
            icon: Icon(Icons.view_week),
            onPressed: () {
//              day_pressed_button = false;
//              week_pressed_button = true;
//              month_pressed_button = false;
//              print(day_pressed_button);
//              print(week_pressed_button);
//              print(month_pressed_button);
              _taskList = _weekTaskList;
              setState(() {
                day_pressed_button = false;
                week_pressed_button = true;
                month_pressed_button = false;
              });
            },
            label: Text(
              "Week",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: RaisedButton.icon(
            color:
            month_pressed_button == true ? Colors.teal : Colors.teal[300],
//          color: Colors.amber[200],
            icon: Icon(Icons.today),
            onPressed: () {
//              day_pressed_button = false;
//              week_pressed_button = false;
//              month_pressed_button = true;
//              print(day_pressed_button);
//              print(week_pressed_button);
//              print(month_pressed_button);
              _taskList = _monthTaskList;
              setState(() {
                day_pressed_button = false;
                week_pressed_button = false;
                month_pressed_button = true;
              });
            },
            label: Text(
              "Month",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }




//git 08/06
//  Widget _button_icon(BuildContext context) {
//    return Row(
//      children: <Widget>[
//        SizedBox(
//          width: 5.0,
//        ),
//        Expanded(
//          child: RaisedButton.icon(
//            color: day_pressed_button == true ? Colors.teal : Colors.teal[300],
//            icon: Icon(Icons.playlist_add_check),
//            onPressed: () {
////              day_pressed_button = true;
////              week_pressed_button = false;
////              month_pressed_button = false;
////              print(day_pressed_button);
////              print(week_pressed_button);
////              print(month_pressed_button);
//              _taskList = _dayTaskList;
//
//              setState(() {
//                day_pressed_button = true;
//                week_pressed_button = false;
//                month_pressed_button = false;
//              });
//            },
//            label: Text(
//              "Day",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        ),
//        SizedBox(
//          width: 5.0,
//        ),
//        Expanded(
//          child: RaisedButton.icon(
//            color: week_pressed_button == true ? Colors.teal : Colors.teal[300],
//            icon: Icon(Icons.view_week),
//            onPressed: () {
////              day_pressed_button = false;
////              week_pressed_button = true;
////              month_pressed_button = false;
////              print(day_pressed_button);
////              print(week_pressed_button);
////              print(month_pressed_button);
//              _taskList = _weekTaskList;
//              setState(() {
//                day_pressed_button = false;
//                week_pressed_button = true;
//                month_pressed_button = false;
//              });
//            },
//            label: Text(
//              "Week",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        ),
//        SizedBox(
//          width: 5.0,
//        ),
//        Expanded(
//          child: RaisedButton.icon(
//            color:
//            month_pressed_button == true ? Colors.teal : Colors.teal[300],
////          color: Colors.amber[200],
//            icon: Icon(Icons.today),
//            onPressed: () {
////              day_pressed_button = false;
////              week_pressed_button = false;
////              month_pressed_button = true;
////              print(day_pressed_button);
////              print(week_pressed_button);
////              print(month_pressed_button);
//              _taskList = _monthTaskList;
//              setState(() {
//                day_pressed_button = false;
//                week_pressed_button = false;
//                month_pressed_button = true;
//              });
//            },
//            label: Text(
//              "Month",
//            ),
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(10),
//            ),
//          ),
//        ),
//        SizedBox(
//          width: 5.0,
//        ),
//      ],
//    );
//  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            padding: const EdgeInsets.all(14.0),
            child: Text("day"),
          ),
        ),
        SizedBox(
          width: 32,
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
                borderRadius: BorderRadius.circular(12.0)),
            color: Colors.white,
            textColor: Theme.of(context).accentColor,
            padding: const EdgeInsets.all(14.0),
            child: Text("week"),
          ),
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            padding: const EdgeInsets.all(14.0),
            child: Text("month"),
          ),
        ),
      ],
    );
  }

  Widget _taskUncomlete(String task, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Icon(
//              Icons.radio_button_checked,
////              color:Theme.of(context).accentColor,
//              color: Colors.teal,
//              size: 20,
//            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.teal,
                  ),
                  onPressed: () {
                    this._taskList[index].isFinish = true;
                    updateTaskComletness(_taskList[index]);
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          task,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskComlete(String task, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Icon(
//              Icons.radio_button_checked,
////              color:Theme.of(context).accentColor,
//              color: Colors.teal,
//              size: 20,
//            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.radio_button_checked,
                    color: Colors.teal,
                  ),
                  onPressed: () {
                    this._taskList[index].isFinish = false;
                    updateTaskComletness(_taskList[index]);
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          task,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.5),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//  Widget _taskComlete(String task, int index) {
//    return Container(
//      //foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
//      child: Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.radio_button_checked,
//                    color: Colors.teal,
//                  ),
//                  onPressed: () {
//                    //to move to compelete and change icon
//                    this._taskList[index].isFinish = false;
//                    setState(() {
//
//                    });
//                  },
//                ),
//                SizedBox(
//                  width: 15,
//                ),
//              ],
//            ),
//            Container(
//              width: MediaQuery.of(context).size.width * 0.6,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Expanded(
//                    child: Text(
//                      task,
//                      style: TextStyle(
//                        fontSize: 20,
//                        color: Colors.black.withOpacity(0.5),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              width: 10,
//            ),
//            IconButton(
//              icon: Icon(
//                Icons.delete_outline,
//                color: Colors.pink,
//              ),
//              onPressed: () {
//                this._taskList.remove(_taskList[index]);
//                setState(() {
//
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  void splitTasks(List<Task> _taskList) {
    print("split task");

    for (var i = 0; i < _taskList.length; i++) {
      print(_taskList[i].frequency);
      if (_taskList[i].frequency == "daily") {
        setState(() {
          _dayTaskList.add(_taskList[i]);
        });
      } else if (_taskList[i].frequency == "weekly") {
        setState(() {
          _weekTaskList.add(_taskList[i]);
        });
      } else {
        setState(() {
          _monthTaskList.add(_taskList[i]);
        });
      }
    }
  }


  //the multi roomatie option
  void _showMultiSelect(BuildContext context) async {
    final List<MultiSelectDialogItem<int>> items = [];
    for (var i = 0; i < usersList.length; i++) {
      items.add(MultiSelectDialogItem(i, usersList[i].name));
      print("MultiSelectDialogItem");
      print(i);
      print(usersList[i].name);
    }

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
//          initialSelectedValues: [1,2].toSet(),
        );
      },
    );
    //print the name of the participans by the tapping order.
    participensInTask.clear();
    for (var i = 0; i < usersList.length; i++) {
      print("user list");
      if(selectedValues.contains(i)){
        print(usersList[i].name);
        participensInTask.add(usersList[i]);
      }
//      print(usersList[if(selectedValues.contains(i)){}]);
//      participensInTask.add(usersList[i]);
//      print("user partisipent list");
//      print(participensInTask[i].name);
    }
    print(selectedValues);
  }

//  Widget partisipence (BuildContext context){
//    return MaterialApp()  }
//

} //end class

//class TasksItem extends StatelessWidget {
//  final Task task;
//
//  TasksItem(String frequency,String nextPerformer,String task_name) : task = Task(frequency: frequency,performers: nextPerformer,task_name:task_name);
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.symmetric(vertical: 5.0),
//          child: Row(
//            children: <Widget>[
//              Material(
//                borderRadius: BorderRadius.circular(100.0),
//                color: Colors.teal.withOpacity(0.2),
//                child: Padding(
//                  padding: EdgeInsets.all(15),
//                  child: Text(
//                    this.task.performer,
//                    style: TextStyle(
//                        color: Colors.teal,
//                        fontSize: 15.0,
//                        fontWeight: FontWeight.bold
//                    ),
//                  ),
//                ),
//              ),
//              SizedBox(width: 25.0,),
//              Expanded(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      this.task.task_name,
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 18.0,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Text(
//                  this.task.frequency,
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 15.0,
//                      fontWeight: FontWeight.bold
//                  )
//              )
//            ],
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 25),
//          child: Divider(),
//        ),
//      ],
//    );
//  }
//}

// ================== coped from stakeoverflow

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose your Bankys by order of execution:',style: TextStyle(color: Colors.pink.withOpacity(0.7),fontSize: 19.0,height: 1.0),),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          textColor: Colors.teal,
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          color: Colors.teal,
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          color: Colors.teal,
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    print("_buildItem");
    print(_selectedValues.contains(item.value));
    return CheckboxListTile(
      value: checked,
      activeColor: Colors.amberAccent,
      title: Text(item.label),
//      checkColor: Colors.teal,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

// =================== until here it was overflow

// //from youtube one to one
//
//class MyListTask extends StatelessWidget{
//  Widget build(BuildContext context){
//    return Scaffold(
//      body:
//      Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          SizedBox(height: 60,),
//          Padding(
//            padding: const EdgeInsets.all(24.0),
//            child: Text("Monday",
//              style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(24.0),
//            child: _button(context),
//          ),
//          _taskUncomlete("clean the home"),
//          _taskUncomlete("trip with frind"),
//          _taskUncomlete("make food"),
//        ],
//      ) ,
//    );
//  }
//
//  Widget _taskUncomlete(String task){
//    return  Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Row(
//        children: <Widget>[
//          Icon(
//            Icons.radio_button_unchecked,
//            color:Theme.of(context).accentColor,
//            size: 20,
//          ),
//          SizedBox(
//            width: 28,
//          ),
//          Text(task)
//        ],
//      ),
//    );
//  }
//
//
//  Widget _button(BuildContext context){
//    return Row(
//      children: <Widget>[
//        Expanded(
//          child: MaterialButton(
//            onPressed: () {},
//            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//            color:Theme.of(context).accentColor,
//            textColor: Colors.white,
//            padding: const EdgeInsets.all(14.0),
//            child: Text("day"),
//          ),
//        ),
//        SizedBox(width: 32,),
//        Expanded(
//          child: MaterialButton(
//            onPressed: () {},
//            shape: RoundedRectangleBorder(
//                side:BorderSide(color:Theme.of(context).accentColor, ),
//                borderRadius: BorderRadius.circular(12.0)),
//            color:Colors.white,
//            textColor: Theme.of(context).accentColor,
//            padding: const EdgeInsets.all(14.0),
//            child: Text("week"),
//          ),
//        ),
//        Expanded(
//          child: MaterialButton(
//            onPressed: () {},
//            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//            color:Theme.of(context).accentColor,
//            textColor: Colors.white,
//            padding: const EdgeInsets.all(14.0),
//            child: Text("month"),
//          ),
//        ),
//      ],
//    );
//  }
//}

//////////////// youtube that i change //////////////////////////
//  Widget _mainContent(BuildContext context){
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        SizedBox(height: 60,),
//        Padding(
//          padding: const EdgeInsets.all(24.0),
//          child: Text("Monday",
//            style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),
//          ),
//        ),
//        Padding(
//          padding: const EdgeInsets.all(24.0),
//          child: _button(context),
//        ),
//        _taskUncomlete("clean the home"),
//        _taskUncomlete("trip with frind"),
//        _taskUncomlete("make food"),
//        Divider(
//          height: 1.0,
//        ),
//        SizedBox(height: 16.0,),
//        _taskComlete("take ths dog to trip"),
//      ],
//    );
//  }

//  Widget _taskUncomlete(String task){
//    return  Padding(
//      padding: const EdgeInsets.only(left:20.0,bottom: 24.0),
//      child: Row(
//        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.radio_button_unchecked,
//              color: Colors.teal,
//            ),
//            onPressed: (){
//              //to move to compelete and change icon
//              setState(() {
////                this._taskUncomlete(task);
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
//            width: 28,
//          ),
//          Text(task,style: TextStyle(fontSize: 20,),),
//        ],
//      ),
//    );
//  }
//
//  Widget _taskComlete(String task){
//    return  Container(
//      foregroundDecoration: BoxDecoration(color: Color(0x60FD)),
//      child: Padding(
//        padding: const EdgeInsets.only(left:20.0,top: 24.0),
//        child: Row(
//          children: <Widget>[
//            Icon(
//              Icons.radio_button_checked,
////              color:Theme.of(context).accentColor,
//            color: Colors.teal,
//              size: 30,
//            ),
//            SizedBox(
//              width: 28,
//            ),
//            Text(task,style: TextStyle(fontSize: 20,),)
//          ],
//        ),
//      ),
//    );
//  }