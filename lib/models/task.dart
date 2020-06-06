import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';

class Task{
  String frequency;
  final List<User> performers;
  final String task_name;
  bool isFinish;
  final int id;


  Task({this.frequency,this.performers,this.task_name,this.isFinish,this.id});

  //getting info from server
  factory Task.fromJson(Map<String, dynamic> json){

    return Task(frequency: changeFrequencyNameToProgram(json['frequency']), performers: splitParticipantsFromJason(json['participants']), task_name: json['name'],isFinish: json['shift']['executed'],id:json['dutyId']);
  }
  //send info to server
  Map<String, dynamic> toJson() =>
      {
        'frequency':changeFrequencyNameToServer(frequency),
        'name': task_name,
//        'isExcecuted': isFinish,
        'participants': performers,
        'dutyId':id,
      };


}

//this function change the frequency in the server to frequency in the program
String changeFrequencyNameToProgram(String frequency){
  if(frequency=='DAILY'){
    return "evey day";
  }
  else if(frequency=="WEEKLY"){
    return 'evey week';
  }
  else{
    return 'evey month';
  }
}

//this function change the frequency in the program to frequency in the server
String changeFrequencyNameToServer(String frequency) {
  if (frequency == "evey day") {
    return 'DAILY';
  }
  else if (frequency == "evey week") {
    return 'WEEKLY';
  }
  else {
    return 'MONTHLY';
  }
}

List<User> splitParticipantsFromJason(List<dynamic> jasonList){
  List<User> usersNames = [];
  for(var jsonUser in jasonList){
    User roommate = User.fromJson(jsonUser);
    usersNames.add(roommate);
  }
return usersNames;
}
