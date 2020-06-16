import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';

class Task{
  String frequency;
  final List<User> performers;
  final String task_name;
  bool isFinish;
  final int id;
  User nextUserTask;


  Task({this.frequency,this.performers,this.task_name,this.isFinish,this.id,this.nextUserTask});

  //getting info from server
  factory Task.fromJson(Map<String, dynamic> json){

    return Task(frequency: changeFrequencyNameToProgram(json['frequency']), performers: splitParticipantsFromJason(json['participants']), task_name: json['name'],isFinish: json['shift']['executed'],id:json['dutyId'],nextUserTask:User.fromJson(json['shift']['executor']));
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
    return "Daily";
  }
  else if(frequency=="WEEKLY"){
    return 'Weekly';
  }
  else{
    return 'Monthly';
  }
}

//this function change the frequency in the program to frequency in the server
String changeFrequencyNameToServer(String frequency) {
  if (frequency == "Daily") {
    return 'DAILY';
  }
  else if (frequency == "Weekly") {
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
//User getNextUserFromJason(var jasonList){
//  User nextUsersNames;
//  for(var jsonUser in jasonList){
//    nextUsersNames = User.fromJson(jsonUser);
//  }
//  return nextUsersNames;
//}