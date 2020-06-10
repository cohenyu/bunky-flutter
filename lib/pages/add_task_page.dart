//import 'dart:convert';
//import 'package:bunky/models/task.dart';
//import 'package:bunky/models/user.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:bunky/widgets/drop_down_category_tasks.dart';
//import 'package:http/http.dart' as http;
//import 'package:bunky/widgets/my_shape_clipper.dart';
//import 'package:bunky/widgets/charge_card.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//
//
//class AddTaskPage extends StatefulWidget{
//  final User user;
//  final Function callback;
//
//  const AddTaskPage({this.user, this.callback});
//  @override
//
//  _AddTaskPageState createState() => _AddTaskPageState();
//}
//
//class _AddTaskPageState extends State<AddTaskPage> {
//  List<User> usersList = [];
//  List<User> participensInTask = [];
//  List<User> usersInApprtment = [];
//  String frequency;
//  TextEditingController taskNameController = new TextEditingController();
////  bool _autoValidate = false;
//  bool ready = false;
//  User selectedUser;
//  bool refreshBalance = true;
//  bool isChanged = false;
//  Color primaryColor = Colors.teal;
//  Map data = {};
//  String url = 'https://bunkyapp.herokuapp.com';
//  List<ChargeCard> credit = [];
//  List<ChargeCard> debt = [];
//  bool isLoading = true;
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    data  = ModalRoute.of(context).settings.arguments;
//    if(refreshBalance){
//      refreshBalance = false;
//      getUsers();
//    }
//    return Scaffold(
//        key: _scaffoldKey,
//        resizeToAvoidBottomInset: true,
//        body: SingleChildScrollView(
//          child: Stack(
//            children: <Widget>[
//              ClipPath(
//                clipper: CustomShapeClipper(),
//                child: Container(
//                  height: 600.0,
//                  decoration: BoxDecoration(color: primaryColor),
//                ),
//              ),
//              Column(
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.only(left: 20.0, top: 40.0),
//                        child: FloatingActionButton(
//                          onPressed: (){
//                            Navigator.pop(context, isChanged);
//                          },
//                          backgroundColor: Colors.yellow[300],
//                          elevation: 3,
//                          child: Icon(
//                            Icons.arrow_back,
//                            color: Colors.black,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
//                    child: Container(
//                      height: MediaQuery.of(context).size.height / 1.3,
//                      width: double.infinity,
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.black.withOpacity(0.1),
//                              offset: Offset(0.0, 3.0),
//                              blurRadius: 15.0,
//                            )
//                          ]
//                      ),
//                      child: isLoading ? Center(
//                        child: SpinKitCircle(
//                          color: Colors.grey[600],
//                          size: 50.0,
//                        ),
//                      ) :
//                      Padding(
//                        padding: const EdgeInsets.symmetric(vertical: 20.0),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            //--------------------------------------------------------
//                            Container(
//                              width: 300,
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Text(
//                                    'Add new Task',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                        color: Colors.black,
//                                        fontSize: 20),
//                                  ),
//                                  SizedBox(
//                                    height: 10,
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.symmetric(),
////                    padding: const EdgeInsets.only(left: 10, right: 10),
//                                    child: Container(
//                                      height: 40,
//                                      width: 350,
//                                      child: RaisedButton(
//                                        //color:Colors.teal[100],
//                                        color: Colors.teal.withOpacity(0.2),
//                                        child:
////                          TextField(
////                            decoration: InputDecoration(
////                                border: InputBorder.none,
////                                hintText: "press to choose partisipans"
////                            ),
////                          ),
//                                        Text(
//                                          "Press to choose participants",
//                                          style: TextStyle(
//                                              color: Colors.black45,
//                                              //fontWeight: FontWeight.bold,
//                                              fontSize: 18.0),
//                                        ),
//                                        // onPressed: () => _showMultiSelect(context),
//                                        onPressed: () {
//
//                                          //ShowUsersDialog();
//                                          _showMultiSelect(context);
//                                          setState(() {
//                                            //_showParticipans();
//                                          });
//                                        },
//                                      ),
//                                    ),
//                                  ),
//                                  participensInTask.length >0 ?
//                                  Container(
//                                    height: 200,
//                                    width: 350,
//                                    child: ReorderableListView(
//                                      onReorder: (oldIndex, newIndex) {
//                                        setState(() {
//                                          User user = participensInTask[oldIndex];
//                                          participensInTask.removeAt(oldIndex);
//                                          participensInTask.insert(newIndex, user);
//                                        });
//                                      },
//                                      children: <Widget>[
//                                        for (final u in participensInTask)
//                                          Dismissible(
//                                            background: Container(
//                                              color: Colors.redAccent,
//                                            ),
//                                            onDismissed: (direction) {
//                                              setState(() {
//                                                participensInTask
//                                                    .removeAt(participensInTask.indexOf(u));
//                                              });
//                                            },
//                                            key: ValueKey(u),
//                                            child: ListTile(
//                                              key: ValueKey(u),
//                                              title: Text(u.name),
//                                              leading: Text('${participensInTask.indexOf(u)}'),
//                                              trailing: Icon(Icons.person),
//                                            ),
//                                          ),
//                                      ],
//                                    ),)
//                                      :Container(),
//                                  SizedBox(
//                                    height: 10.0,
//                                  ),
//                                  MyDropDown(callback: (val) {
//                                    setState(() {
//                                      frequency = val;
//                                    });
//                                  }),
//                                  Padding(
//                                    padding: const EdgeInsets.symmetric(),
//                                    child: Container(
//                                      child: TextField(
//                                        controller: taskNameController,
//                                        decoration: InputDecoration(
//                                            hintText: 'Title',
//                                            enabledBorder: UnderlineInputBorder(
//                                                borderSide: BorderSide(color: Colors.black))),
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 10,
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                    children: <Widget>[
//                                      RaisedButton(
//                                        color: Colors.pink[800],
//                                        child: Text(
//                                          "Cancel",
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 15.0),
//                                        ),
//                                        onPressed: () {
//                                          Navigator.pop(context);
//                                        },
//                                      ),
//                                      RaisedButton(
//                                        color: Colors.pink[800],
//                                        child: Text(
//                                          "Add",
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 15.0),
//                                        ),
//                                        onPressed: () {
//                                          if (taskNameController.text != '') {
//                                            this.widget.callback(frequency, this.participensInTask,
//                                                taskNameController.text, false);
//                                            Navigator.pop(context);
////                                            sendAddTak(frequency, this.participensInTask,
////                                                taskNameController.text, false);
//                                            //send to or
//                                          }
//                                        },
//                                      ),
//                                    ],
//                                  )
//                                ],
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(height: 10.0,),
//                ],
//              ),
//            ],
//          ),
//        )
//
//    );
//  }
//
//  Future<void> getUsers() async {
//    try {
//      User user = widget.user;
//      final response = await http.get(
//        'https://bunkyapp.herokuapp.com/allUsersOfAptByUser?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
//        headers: <String, String>{
//          'Content-Type': 'application/json; charset=UTF-8',
//        },
//      ).timeout(const Duration(seconds: 6));
//
//      if (response.statusCode == 200) {
//        print("get users");
//        print("200 OK");
//        if (response.body.isNotEmpty) {
//          List jsonData = jsonDecode(response.body);
//          List<User> usersNames = [];
//          for (var jsonUser in jsonData) {
//            User roommate = User.fromJson(jsonUser);
//            usersNames.add(roommate);
//          }
//          setState(() {
//            usersList = usersNames;
//            print("here");
//            isLoading = false;
//            usersInApprtment = usersNames;
//          });
//        }
//      } else {
//        print('Error');
//      }
//    } catch (_) {
//      print('No Internet Connection');
//    }
//  }
//
//  //the multi roomatie option
//  void _showMultiSelect(BuildContext context) async {
//    final List<MultiSelectDialogItem<int>> items = [];
//    for (var i = 0; i < usersList.length; i++) {
//      items.add(MultiSelectDialogItem(i, usersList[i].name));
//    }
//
//    final selectedValues = await showDialog<Set<int>>(
//      context: context,
//      builder: (BuildContext context) {
//        return MultiSelectDialog(
//          items: items,
////          initialSelectedValues: [1,2].toSet(),
//        );
//      },
//    );
//    //print the name of the participans by the tapping order.
//    participensInTask.clear();
//    for (var i = 0; i < selectedValues.length; i++) {
//      print("user list");
//      print(usersList[i].name);
//      participensInTask.add(usersList[i]);
//      print("user partisipent list");
//      print(participensInTask[i].name);
//    }
//    print(selectedValues);
//    setState(() {
//
//    });
//  }
//
//  Future<void> sendAddTak(String frequency, List<User> performers,
//      String task_name, bool isFinish) async {
//    setState(() {});
//    try {
//      //    http post
//      User user = widget.user;
//      for (User u in performers) {
//        print("yuval check");
//        print(u.name);
//      }
//      final response = await http
//          .post('$url/addDuty',
//          headers: <String, String>{
//            'Content-Type': 'application/json; charset=UTF-8',
//          },
//          body: jsonEncode({
//            'name': task_name,
//            'participants': performers,
//            'frequency': changeFrequencyNameToServer(frequency),
//            'isExecuted': isFinish,
//          }))
//          .timeout(const Duration(seconds: 10));
//      if (response.statusCode == 200) {
//        print("200 OK Task");
//        print("BODY RESPONSE");
//        print(jsonDecode(response.body));
//        print(jsonDecode(response.body)['participants'].runtimeType);
//        Task task = Task.fromJson(jsonDecode(response.body));
//        print(task.task_name);
//        print(task.frequency);
//        print(task.isFinish);
//        print(task.performers);
//        //showAddTask(frequency, performers, task_name, isFinish);
//        setState(() {
////          this.widget.callback(task);
////          Navigator.pop(context);
////          showAddTask(frequency, performers, task_name, isFinish);
////          _aptTasks.insert(0, TaskItem(task));
//        });
//      } else {
//        // showSnackBar('Error');
//        print('somthing went worng');
//      }
//    } //end try
//    catch (_) {
//      print('point 3');
//      showSnackBar('No Internet Connection');
//    }
//  } //end function
//
//  //this function add tsk to each list by frequency
//
//  void showSnackBar(String title) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      duration: Duration(seconds: 1),
//      backgroundColor: Colors.pink[50],
//      content: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            title,
//            style: TextStyle(fontSize: 16.0, color: Colors.pink),
//          ),
//        ],
//      ),
//    ));
//  }
//}
//
//// ================== coped from stakeoverflow
//
//class MultiSelectDialogItem<V> {
//  const MultiSelectDialogItem(this.value, this.label);
//
//  final V value;
//  final String label;
//}
//
//class MultiSelectDialog<V> extends StatefulWidget {
//  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
//      : super(key: key);
//
//  final List<MultiSelectDialogItem<V>> items;
//  final Set<V> initialSelectedValues;
//
//  @override
//  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
//}
//
//class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
//  final _selectedValues = Set<V>();
//
//  void initState() {
//    super.initState();
//    if (widget.initialSelectedValues != null) {
//      _selectedValues.addAll(widget.initialSelectedValues);
//    }
//  }
//
//  void _onItemCheckedChange(V itemValue, bool checked) {
//    setState(() {
//      if (checked) {
//        _selectedValues.add(itemValue);
//      } else {
//        _selectedValues.remove(itemValue);
//      }
//    });
//  }
//
//  void _onCancelTap() {
//    Navigator.pop(context);
//  }
//
//  void _onSubmitTap() {
//    setState(() {
//      Navigator.pop(context, _selectedValues);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return AlertDialog(
//      title: Text('Choose your Bankys by order of execution:',style: TextStyle(
//        color:Colors.pink.withOpacity(0.6),fontSize: 20.0,height: 1.5,
//        fontWeight: FontWeight.bold,
//      ),
//      ),
//      contentPadding: EdgeInsets.only(top: 12.0),
//      content: SingleChildScrollView(
//        child: ListTileTheme(
//          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
//          textColor: Colors.teal,
//          child: ListBody(
//            children: widget.items.map(_buildItem).toList(),
//          ),
//        ),
//      ),
//      actions: <Widget>[
//        FlatButton(
//          child: Text('CANCEL'),
//          color: Colors.teal,
//          onPressed: _onCancelTap,
//        ),
//        FlatButton(
//          child: Text('OK'),
//          color: Colors.teal,
//          onPressed:_onSubmitTap,
//        )
//      ],
//    );
//  }
//
//  Widget _buildItem(MultiSelectDialogItem<V> item) {
//    final checked = _selectedValues.contains(item.value);
//    print("_buildItem");
//    print(_selectedValues.contains(item.value));
//    return CheckboxListTile(
//      value: checked,
//      activeColor: Colors.amberAccent,
//      title: Text(item.label),
////      checkColor: Colors.teal,
//      controlAffinity: ListTileControlAffinity.leading,
//      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
//    );
//  }
//}
//
//// =================== until here it was overflow
