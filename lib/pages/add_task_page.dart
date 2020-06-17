import 'dart:convert';

import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:bunky/widgets/drop_down_category_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:bunky/models/user.dart';


class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool isChanged = false;
  String frequency;
  TextEditingController taskTitleController = new TextEditingController();
  List<User> deletedItems = [];
  List<User> participensInTask = [];
  Map data = {};
  List<User> usersList = [];
  Function callback;
  bool _autoValidate = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = ModalRoute.of(context).settings.arguments;
      callback = data['callback'];
      getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    for(var c in participensInTask){
      print(c);
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.teal,
        body: SingleChildScrollView(
          child: Form(
            autovalidate: _autoValidate,
            key: formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40.0),
                      child: FloatingActionButton(
                        onPressed: (){
                          Navigator.pop(context, isChanged);
                        },
                        backgroundColor: Colors.yellow[300],
                        elevation: 3,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
                  child: Container(
//                  height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0.0, 3.0),
                            blurRadius: 15.0,
                          )
                        ]
                    ),
                    child: usersList.isEmpty ? Container(
                      height: 320,
                      width: 310,
                      child: Center(
                        child: SpinKitCircle(
                          color: Colors.grey[600],
                          size: 50.0,
                        ),
                      ),
                    ) : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text('New duty',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            SizedBox(height: 5.0,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: MyDropDown(callback: (val) {
                                setState(() {
                                  frequency = val;
                                });
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                child: TextFormField(
                                  validator: (value){
                                    value = value.trim();
                                    if (value.isEmpty) {
                                      return 'Title is required';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(fontSize: 18.0),
                                  controller: taskTitleController,
                                  decoration: InputDecoration(
                                      hintText: 'Title',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black))),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Container(
                              height: 30.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Choose order (or swipe to delete):', style: TextStyle(fontSize: 18.0), textAlign: TextAlign.start,),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            deletedItems.isNotEmpty ? RaisedButton(
                              color: Colors.grey[200],
                              onPressed: (){
                                _showMultiSelect(context);
                              },
                              child: Container(
                                height: 30.0,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.add),
                                    SizedBox(width: 10.0,),
                                    Text('Add a bunky', style: TextStyle(fontSize: 16.0),)
                                  ],
                                ),
                              ),
                            ): SizedBox.shrink(),
                            Container(
                              height: usersList.length * 81.0,
                              width: double.infinity,
                              color: Colors.white,
                              child: ReorderableListView(
                                padding: EdgeInsets.only(top: 0.0),
                                scrollDirection: Axis.vertical,
                                onReorder: (oldIndex, newIndex){
                                  setState(() {
                                    if(newIndex > oldIndex){
                                      newIndex -= 1;
                                    }
                                    final item  = usersList.removeAt(oldIndex);
                                    usersList.insert(newIndex, item);
//                                    User s = usersList[oldIndex];
//                                    usersList.removeAt(oldIndex);
//                                    usersList.insert(newIndex, s);
                                  });
                                },
                                children: <Widget>[
                                  for(final item in usersList)
                                    Dismissible(
                                      background: Container(
                                        color: Colors.redAccent,
                                      ),
                                      onDismissed: (direction){
                                        setState(() {
                                          deletedItems.add(item);
                                          usersList.removeAt(usersList.indexOf(item));
                                        });
                                      },
                                      key: ValueKey(item.userId),
                                      child: ListTile(
                                        key: ValueKey(item),
                                        title: Text('${item.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                                        leading: Text('${usersList.indexOf(item) + 1}', style: TextStyle(fontSize: 18.0),),
                                        trailing: Icon(Icons.list),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: RaisedButton(
                    color: Colors.teal[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    onPressed: (){
                      if(!formKey.currentState.validate()){
                        setState(() {
                          _autoValidate = true;
                        });
                        return;
                      }
                      if(usersList.isEmpty){
                        showSnackBar('Add at least one bunky');
                      } else{
                        formKey.currentState.save();
                        String tmpTitle  = taskTitleController.text.trim();
                        String firstLetter = tmpTitle[0].toUpperCase();
                        tmpTitle = firstLetter + tmpTitle.substring(1);
                        callback(frequency, this.usersList, tmpTitle, false);
                        Navigator.pop(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void showSnackBar (String title){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.pink[50],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.pink
            ),
          ),
        ],
      ),
    ));
  }


  Future<void> getUsers() async {
    try {
      User user = data['user'];
      final response = await http.get(
        'https://bunkyapp.herokuapp.com/allUsersOfAptByUser?userId=${user.userId}&name=${user.name}&mail=${user.mail}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 7));

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
          });
        }
      } else {
        print('Error');
      }
    } catch (_) {
      print('No Internet Connection');
    }
  }

  void _showMultiSelect(BuildContext context) async {
    final List<MultiSelectDialogItem<int>> items = [];
    for (var i = 0; i < deletedItems.length; i++) {
      items.add(MultiSelectDialogItem(i, deletedItems[i]));
    }


    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
        );
      },
    );
    //print the name of the participans by the tapping order.
    participensInTask.clear();
    if(selectedValues != null){
      for(var index in selectedValues){
        participensInTask.add(deletedItems[index]);
      }
      setState(() {
        usersList.addAll(participensInTask);
        for(var i in participensInTask){
          deletedItems.remove(i);
        }

      });
    }
  }
}


class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.user);

  final V value;
  final User user;
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      title: Text('Choose bunkys:',style: TextStyle(color: Colors.pink.withOpacity(0.7),fontSize: 19.0,height: 1.0), textAlign: TextAlign.center,),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
              textColor: Colors.teal,
              child: ListBody(
                children: widget.items.map(_buildItem).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Text('CANCEL'),
                    color: Colors.teal,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10.0,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Text('OK'),
                    color: Colors.teal,
                    onPressed: _onSubmitTap,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    print("_buildItem");
    print(_selectedValues.contains(item.value));
    return CheckboxListTile(
      value: checked,
      activeColor: Colors.amberAccent,
      title: Text(item.user.name),
//      checkColor: Colors.teal,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
