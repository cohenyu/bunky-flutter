import 'package:bunky/models/navigation_item.dart';
import 'package:flutter/material.dart';

class BottomNavyBar extends StatefulWidget {
  @override
  _BottomNavyBarState createState() => _BottomNavyBarState();
}

class _BottomNavyBarState extends State<BottomNavyBar> {
  Map data = {};
  int index = 0;
  Color backgroundColor = Colors.pink;

  final _pageOptions = [
    '/home',
    '/expenses',
    '/tasks',
    '/settings'
  ];



  List<NavigationItem> items = [
    NavigationItem(icon: Icon(Icons.home), title:Text('Home'), color: Colors.white),
    NavigationItem(icon: Icon(Icons.attach_money), title:Text('Expenses'), color: Colors.white),
    NavigationItem(icon: Icon(Icons.today), title:Text('Tasks'), color: Colors.white),
    NavigationItem(icon: Icon(Icons.settings), title:Text('Settings'), color: Colors.white),
  ];

  Widget _buildItem(NavigationItem item, bool isSelected){
    return Container(
      height: double.maxFinite,
      width: isSelected ? 125 : 50,
      padding: isSelected ? EdgeInsets.only(left: 16, right: 16): null,
      decoration: isSelected? BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.all(Radius.circular(50))
      ): null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: 24,
                  color: isSelected ? backgroundColor: Colors.black,
                ),
                child: item.icon,
              ), Padding(
                padding: const EdgeInsets.only(left: 8),
                child: isSelected ? DefaultTextStyle.merge(
                    style: TextStyle(
                        color: backgroundColor
                    ),
                    child: item.title
                ) : Container(),
              )
            ],
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if(data != null){
      index = data['index'];
    }
    return AnimatedContainer(
      duration: Duration(microseconds: 270),
      height: 56,
      padding: EdgeInsets.only(left: 20,top: 5, bottom: 5, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4
            )
          ]
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item){
          var itemIndex = items.indexOf(item);
          return GestureDetector(
            onTap: (){
              setState(() {
                index = itemIndex;
              });
              Navigator.pushReplacementNamed(context, _pageOptions[index], arguments: {'index': index, 'user': data['user']});
            },
            child: _buildItem(item, index==itemIndex),
          );
        }).toList(),
      ),
    );
  }
}
