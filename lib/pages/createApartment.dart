import 'dart:convert';
import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'logo.dart';
import 'package:share/share.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateApartment extends StatefulWidget {
  @override
  _CreateApartmentState createState() => _CreateApartmentState();
}


class _CreateApartmentState extends State<CreateApartment> {
  Map data = {};
  final String url = 'https://bunkyapp.herokuapp.com/loginUser';
  Future<int> aptCode;
  int finalCode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        data = ModalRoute.of(context).settings.arguments;
        aptCode = getApartmentCode().then((value){
          finalCode = value;
          return value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Logo logo = Logo(title: 'Sign up');
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 1000,
              decoration: BoxDecoration(color: Colors.white),
            ),
          ),
          ListView(
            children: <Widget>[
              logo.getLogo(),
              FutureBuilder<int>(
                future: aptCode,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                  List<Widget> children;
                  if(snapshot.hasData){
                    children = <Widget>[
                      Center(
                        child: Text(
                          'This is your apartment code.\nshare it with your bunkys!',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black.withOpacity(0.7)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                          '${snapshot.data}',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.pink[600],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        width: 200.0,
                        child: RaisedButton.icon(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          onPressed: (){
                            final RenderBox box = context.findRenderObject();
                            Share.share('This is my apartment code! Join me at Bunky app! \n$finalCode',
                                subject: 'This is my apartment code! join me at Bunky app!',
                                sharePositionOrigin:
                                box.localToGlobal(Offset.zero) &
                                box.size);
//                            Share.share('flutter is cool');
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
                      Container(
                        width: 200.0,
                        child: RaisedButton.icon(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30),
                          ),
                          onPressed: (){
                            Navigator.of(this.context)
                                .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false, arguments: {
                              'user': data["user"],
                              'index': 0,
                            });
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Let's go",
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
                        child: Text('loading...',
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
            ],
          ),
        ],
      ),
    );
  }
  

  Future<int> getApartmentCode() async{
    User user = data["user"];
    print(user.name);
    try{
      var response = await http.post('https://bunkyapp.herokuapp.com/newApt',headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode({
        'user': user.toJson(),
        'aptName': '',
        'currency': user.currency,
      }
      )).timeout(const Duration(seconds: 10));

      if(response.statusCode == 200){
        int code = jsonDecode(response.body);
        return code;
      } else {
        print('ERROR');
        showSnackBar('Error');
        return -1;
      }

    } catch (_){
      showSnackBar('No Internet Connection');
      print('No Internet Connection');
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
