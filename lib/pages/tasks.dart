
import 'dart:convert';
import 'package:bunky/models/task.dart';
import 'package:bunky/models/user.dart';
import 'package:bunky/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bunky/widgets/drop_down_category_tasks.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool isLoading = true;
  List<User> participensInTask = [];
  Map data = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = 'https://bunkyapp.herokuapp.com';
  bool start = true;
  bool choosePartisipansIsPressed = false;


  List<Task> _taskList = [];
  List<Task> _allApartmentTasks = [];
  List<Task> _dayTaskList = [];
  List<Task> _weekTaskList = [];
  List<Task> _monthTaskList = [];
  List<TaskItem> _aptTasks = [];


  @override
  void initState() {
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
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, '/addTaskPage', arguments: {'user': data['user'], 'callback': (String frequency, List<User> performers,
                String title, bool isFinish){
              addTask(frequency, performers, title, isFinish);
            }});
          },
          backgroundColor: Colors.pink.withOpacity(0.9),
        ),
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
                      height: 380.0,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        day_pressed_button ? "Your duties for today:" : week_pressed_button ? "Your duties for this week:" : "Your duties for this month:",
                              style: TextStyle(
                                      fontSize: 20.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                                    ),
                                  ],
                                )
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          //youtube
                          Expanded(
                            child: Scrollbar(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  isLoading ? SizedBox.shrink() : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _aptTasks.isNotEmpty ? showTasks() : hideTasks(),
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  List<Widget> hideTasks() {
    return [
      Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
        child: Text(
          'No duties',
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
          'All apartment duties',
          style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ),
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
                          "Are you sure you wish to delete this duty?",
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
                  //print(index);
//                  _taskList.remove(_aptTasks[index].task);
                  print("duty del");
                  print(_aptTasks[index].task.task_name);
                  print(_aptTasks[index].task.id);
                  showDelTask(_aptTasks[index].task);
                  _aptTasks.removeAt(index);
                  showSnackBar('Duty deleted');
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

  void showAddDialog() {
    String frequency;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController taskNameController = new TextEditingController();
    TextEditingController frequencyController = new TextEditingController();
    bool _autoValidate = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.teal[100],
            content: Container(
              height: 350,
              width: 400,
              child: Form(
                autovalidate: _autoValidate,
                key:  formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Add new duty',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: 50,
                        width: 400,
                        child: RaisedButton(
                          //color:Colors.teal[100],
                          color: Colors.teal.withOpacity(0.2),
                          child:
                          Text(
                            "Press to choose participants",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18.0),
                          ),
                          onPressed: () {
                            _showMultiSelect(context);
                            setState(() {
                            });
                          },
                        ),
                      ),
                    ),
                    MyDropDown(callback: (val) {
                      setState(() {
                        frequency = val;
                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        child: TextField(
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9 ."\'()-_=+;,!?@#%^&*\$/<>|]+')),],
                          controller: taskNameController,
                          decoration: InputDecoration(
                              hintText: 'Title',
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
                            if(!formKey.currentState.validate()){
                              setState(() {
                                _autoValidate = true;
                              });
                              return;
                            }
                            formKey.currentState.save();
                            String tmpTitle  = taskNameController.text.trim();
                            String firstLetter = tmpTitle[0].toUpperCase();
                            tmpTitle = firstLetter + tmpTitle.substring(1);

                            if (taskNameController.text != '') {
                              addTask(frequency, this.participensInTask, tmpTitle, false);
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
    setState(() {
      isLoading = true;
    });
    User user = data['user'];

    try{
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
        showSnackBar('Error');
      }
      setState(() {
        _aptTasks = List.from(tmpAptTasks.reversed);
      });
    }catch(_){
      showSnackBar('No Internet Connection');
    }

    setState(() {
      isLoading = false;
    });
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

  // This function update the completeness of task in the server
  Future<void> updateTaskCompleteness(Task task) async {
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

  Future<void> addTask(String frequency, List<User> performers, String taskTitle, bool isFinish) async {
    User user = data['user'];
    try {
      final response = await http
          .post('$url/addDuty',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'name': taskTitle,
            'participants': performers,
            'frequency': changeFrequencyNameToServer(frequency),
            'isExecuted': isFinish,
          }))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        if(response.body.isNotEmpty){
          Task task = Task.fromJson(jsonDecode(response.body));
          setState(() {
            if(performers[0].userId==user.userId) {
              addTaskByFrequency(frequency, performers, taskTitle, isFinish, task.id);
            }
            _aptTasks.insert(0, TaskItem(task));
          });
        } else{
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    } //end try
    catch (_) {
      showSnackBar('No Internet Connection');
    }
  } //end function

  //this function add tsk to each list by frequency
  void showDelTask(Task delTask) {
    setState(() {
      if (delTask.frequency == "Daily") {
        print("delte to day");
        for(var i=0 ;i<_dayTaskList.length;i++){
          if(_dayTaskList[i].id==delTask.id){
            _dayTaskList.removeAt(i);
          }
        }
      } else if (delTask.frequency == "Weekly") {
        print("delete to week");
        for(var i=0 ;i<_weekTaskList.length;i++){
          if(_weekTaskList[i].id==delTask.id){
            _weekTaskList.removeAt(i);
          }
        }
      } else {
        print("delete to Month");
        for(var i=0 ;i<_monthTaskList.length;i++){
          if(_monthTaskList[i].id==delTask.id){
            _monthTaskList.removeAt(i);
          }
        }
      }
    });
  }

  //this function add tsk to each list by frequency
  void addTaskByFrequency(String frequency, List<User> performers, String taskName, bool isFinish,int id) {
    Task task = Task(frequency: frequency, performers: performers, task_name: taskName, isFinish: isFinish, id: id);
    setState(() {
      if (frequency == "Daily") {
        _dayTaskList.add(task);
      } else if (frequency == "Weekly") {
        _weekTaskList.add(task);
      } else {
        _monthTaskList.add(task);
      }
    });

  }

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
        } else{
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');

      }
    } catch (_) {
      showSnackBar('No Internet Connection');
    }
  }

  //this function bring all the user tasks
  Future<void> getTaskList() async {
    List<Task> listOfTaskFromServer = [];

    try{
      User user = data['user'];
      final response = await http.get(
        'https://bunkyapp.herokuapp.com/getMyDuties?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 6));

      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List jsonData = jsonDecode(response.body);

          for (var jsonTask in jsonData) {
            Task userTask = Task.fromJson(jsonTask);
            setState(() {
              listOfTaskFromServer.add(userTask);
            });
          }
          _allApartmentTasks = listOfTaskFromServer;
          splitTasks(listOfTaskFromServer);
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_){
      showSnackBar('No Internet Connection');
    }
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


  Widget _taskUncomlete(String task, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.teal,
                  ),
                  onPressed: () {
                    this._taskList[index].isFinish = true;
                    updateTaskCompleteness(_taskList[index]);
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
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.radio_button_checked,
                    color: Colors.teal,
                  ),
                  onPressed: () {
                    this._taskList[index].isFinish = false;
                    updateTaskCompleteness(_taskList[index]);
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

  void splitTasks(List<Task> _taskList) {
    print("split task");

    for (var i = 0; i < _taskList.length; i++) {
      print(_taskList[i].frequency);
      if (_taskList[i].frequency == "Daily") {
        setState(() {
          _dayTaskList.add(_taskList[i]);
        });
      } else if (_taskList[i].frequency == "Weekly") {
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
    }
    print(selectedValues);
  }

} //end class



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
      title: Text('Choose your bunkys by order of execution:',style: TextStyle(color: Colors.pink.withOpacity(0.7),fontSize: 19.0,height: 1.0),),
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
