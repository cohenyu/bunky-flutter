import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {

  const MyDropDown({
    Key key,
  }) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();

}

class _MyDropDownState extends State<MyDropDown> {
  String selected;
  //why only 3 ???
  final List<String> _dropdownValues = [
    "Clean the home",
    "Take off garbage",
    //"Wash dishes"
    "Other"
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        value: selected,
        hint: Text('select Task category'),
        items: _dropdownValues.map((value) => DropdownMenuItem(
          child: Text(value),
          value: value,
        )).toList(),
        onChanged: (value){
          setState(() {
            selected = value;
          });
        },
        isExpanded: true,
      ),
    );
  }
}
