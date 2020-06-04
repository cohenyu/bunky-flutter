import 'dart:convert';
import 'package:share/share.dart';
import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  Map data = {};
  Future<int> code;
  String url = 'https://bunkyapp.herokuapp.com';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      print(MediaQuery.of(context).size.toString());
      data = ModalRoute.of(context).settings.arguments;
      setState(() {
        code = getApartmentCode();
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavyBar(),
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                bottom: -50,
                right: -150,
                child: Icon(Icons.settings,color: Colors.teal.withOpacity(0.2), size: 370,),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 30.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 10.0,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                color: Colors.teal[400],
                child: ListTile(
                  onTap: (){
                    showRenameDialog();
                  },
                  title: Text('${data['user'].name}', style: TextStyle(fontSize: 18.0),),
                  trailing: Icon(Icons.edit),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: Card(
                  elevation: 10.0,
                  color: Colors.white,
                  child: FutureBuilder<int>(
                    future: code,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                      List<Widget> children;

                      if(snapshot.hasData){
                        children = <Widget>[
                          Center(
                            child: Text(
                              'Apartment Code',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black.withOpacity(0.7)
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            snapshot.data != -1 ? '${snapshot.data}' : '------',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.pink[600],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Container(
                            width: 160.0,
                            child: RaisedButton.icon(
                              color: Colors.teal[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30),
                              ),
                              onPressed: (){
                                final RenderBox box = context.findRenderObject();
                                Share.share('$code',
                                    subject: 'This is your apartment code! join me at Bunky app!',
                                    sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) &
                                    box.size);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      wordSpacing: 2
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                      } else{
                        children = <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: SpinKitThreeBounce(
                              color: Colors.grey[600],
                              size: 25.0,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting for apartment code...',
                              style: TextStyle(
                                  fontSize: 20.0
                              ),),
                          )
                        ];
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                        child: Column(
                          children: children,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 10.0, right: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.grey[300],
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Log Out",
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


  void showRenameDialog(){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController = new TextEditingController(text: data['user'].name);
    bool _autoValidate = false;

    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    backgroundColor: Colors.teal[100],
                    content: Container(
                      height: 200,
                      width: 100,
                      child: Form(
                        autovalidate: _autoValidate,
                        key:  formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Rename',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                validator: (value){
                                  if (value.isEmpty) {
                                    return 'name is required';
                                  }
                                  if(value == data['user'].name){
                                    return 'name already exist';
                                  }
                                  return null;
                                },
                                controller: titleController,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.pink[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0
                                    ),
                                  ),
                                  onPressed: (){
                                    if(!formKey.currentState.validate()){
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                      return;
                                    }
                                    formKey.currentState.save();
                                    renameUser(titleController.text);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> renameUser(String newName) async{
    User user = data["user"];

    final response = await http.put(
        '$url/renameUser', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        }, body: jsonEncode({
        'user': user,
        'newName': newName,
        }));
    if(response.statusCode == 200){
      if(response.body.isNotEmpty){
        setState(() {
          data['user'] = User.fromJson(jsonDecode(response.body));
        });
      }

    } else {
      showSnackBar('Error');
      return -1;
    }
  }

  Future<int> getApartmentCode() async{
    User user = data["user"];
    var response = await http.get('$url/aptIdByUser?userId=${user.userId}&name=${user.name}&mail=${user.mail}',headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);

    if(response.statusCode == 200){
      int code = jsonDecode(response.body);
      return code;
    } else {
      showSnackBar('Error');
      return -1;
    }
  }

  void showSnackBar (String title){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
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
}
