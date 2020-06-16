import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  final Function callback;
  const MyDropDown({Key key, this.callback}) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();

}

class _MyDropDownState extends State<MyDropDown> {
  String selected;
  final List<String> _dropdownValues = [
    "Daily",
    "Weekly",
    "Monthly"
  ];


//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 10.0),
//      child: DropdownButton(
//        value: selected,
//        hint: Text('Select frequency'),
//        items: _dropdownValues.map((value) => DropdownMenuItem(
//          child: Text(value),
//          value: value,
//        )).toList(),
//        onChanged: (value){
//          setState(() {
//            selected = value;
//            this.widget.callback(value);
//          });
//        },
//        isExpanded: true,
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField(
      validator: (value){
        print(value);
        if (value == null) {
          return 'Select a frequency';
        }
        return null;
      },
      value: selected,
      hint: Text('Select frequency'),
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
    );
  }
}
