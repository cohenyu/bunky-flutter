import 'dart:convert';
import 'package:bunky/models/user.dart';
import 'package:bunky/pages/http_service.dart';
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
  bool firstTime = true;
  int finalCode;

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
    if(firstTime){
      firstTime = false;
    }
    print("hey");
//    load();
//    loadData();
    Logo logo = Logo(title: 'Signup');
    HttpService http = HttpService();
    return Scaffold(
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
                            Share.share('$finalCode',
                                subject: 'This is your apartment code! join me at Bunky app!',
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
                              'share',
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
                            Navigator.pushNamed(context, '/home', arguments: {
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
                              "let's go",
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
            ],
          ),
        ],
      ),
    );
  }
  

  Future<int> getApartmentCode() async{
    print("inside");
    User user = data["user"];
    print(user.name);
//    print(data["user"]);
    var response = await http.post('https://bunkyapp.herokuapp.com/newApt',headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': user,
      'aptName': 'yuval&miriel',
    }
    ));
    if(response.statusCode == 200){
      print('200 OK');
      print('body: ${jsonDecode(response.body)}');
      int code = jsonDecode(response.body);
      return code;
    } else {
      print('somthing went worng');
      return -1;
    }

  }

}
