import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropDownCurrency extends StatefulWidget {
  final Function callback;
  final scaffoldKey;

  DropDownCurrency({this.callback, this.scaffoldKey});

  @override
  _DropDownCurrencyState createState() => _DropDownCurrencyState();
}

class _DropDownCurrencyState extends State<DropDownCurrency> {
  String selected;
  List<String> _dropdownValues = [];


  @override
  void initState() {
    super.initState();
    getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(60.0),
            ),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white70),
      validator: (value){
        if (value == null) {
          return 'Select a currency';
        }
        return null;
      },
      value: selected,
      items: _dropdownValues.map((value) => DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(value, style: TextStyle(fontSize: 28.0),),
        ),
        value: value,
      )).toList(),
      onChanged: (value){
        setState(() {
          selected = value;
          this.widget.callback(value);
        });
      },
      isExpanded: false,
    );
  }


  Future<void> getCurrencies() async {
    try{

      final response = await http.get(
        'https://bunkyapp.herokuapp.com/getAvailableCurrencies', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 5));

      if(response.statusCode == 200){

        if(response.body.isNotEmpty){
          List jsonData = jsonDecode(utf8.decode(response.bodyBytes));
          List<String> currencies = [];
          for(var jsonSymbol in jsonData){
            print(jsonSymbol);
            currencies.add(jsonSymbol);
          }
          setState(() {
            _dropdownValues.addAll(currencies);
            selected = _dropdownValues[0];
            widget.callback(selected);
          });
        } else{
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_){
      showSnackBar('No Internet Connection');
    }
  }

  void showSnackBar (String title){
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
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
