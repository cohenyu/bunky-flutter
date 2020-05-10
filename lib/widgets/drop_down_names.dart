import 'package:flutter/material.dart';


class DropDownNames extends StatefulWidget {
  final Function callback;
  DropDownNames({this.callback});

  @override
  _DropDownNamesState createState() => _DropDownNamesState();
}

class _DropDownNamesState extends State<DropDownNames> {
  String selected;

  final List<String> _dropdownValues = [
    "Or",
    "Yuval",
    "Miriel"
  ];


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value){
        print(value);
        if (value == null) {
          return 'Select a roomate';
        }
        return null;
      },
      value: selected,
      hint: Text('select roomate'),
      items: _dropdownValues.map((value) => DropdownMenuItem(
        child: Text(value,),
        value: value,
      )).toList(),
      onChanged: (value){
        setState(() {
          selected = value;
          this.widget.callback(value);
        });
      },
      isExpanded: true,
    );
  }
}
