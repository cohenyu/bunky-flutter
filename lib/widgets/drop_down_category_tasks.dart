import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  final Function callback;
  const MyDropDown({Key key, this.callback}) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();

}

class _MyDropDownState extends State<MyDropDown> {
  String selected;
  //why only 3 ???
  final List<String> _dropdownValues = [
    "evey day",
    "evey week",
    "evey month"
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        value: selected,
        hint: Text('select Task frequency'),
        items: _dropdownValues.map((value) => DropdownMenuItem(
          child: Text(value),
          value: value,
        )).toList(),
        onChanged: (value){
          setState(() {
            selected = value;
            this.widget.callback(value);
          });
        },
        isExpanded: true,
      ),
    );
  }
}
