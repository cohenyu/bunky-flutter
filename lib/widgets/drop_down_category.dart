import 'package:flutter/material.dart';

class DropDownExpense extends StatefulWidget {
  final Function callback;
  final Map dropdownValues;
  String title;
  DropDownExpense({this.callback, this.dropdownValues, this.title});

//  const MyDropDown({
//    Key key,
//  }) : super(key: key);

  @override
  _DropDownExpenseState createState() => _DropDownExpenseState();

}

class _DropDownExpenseState extends State<DropDownExpense> {
  String selected;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField(
      validator: (value){
        print(value);
        if (value == null) {
          return 'Select a category';
        }
        return null;
      },
      value: selected,
      hint: Text('Select category'),
      items: widget.dropdownValues.keys.map((value) => DropdownMenuItem(
        child: Text(value,),
        value: value,
      )).toList(),
      onChanged: (value){
        setState(() {
          selected = value;
          print(widget.dropdownValues[value]);
          this.widget.callback(widget.dropdownValues[value], value);
        });
      },
      isExpanded: true,
    );
  }
}
