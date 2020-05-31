//import 'package:flutter/material.dart';
//import 'package:bunky/models/task.dart';
//
//class TaskPage extends StatefulWidget {
//  @override
//  _TaskPageState createState() => _TaskPageState();
//}
//
//  final List<Task>_taskList=[
//    Task(frequency: 'every day',performer:'yuval',task_name: 'claen the room',isFinish:false),
//    Task(frequency: 'every week',performer:'miriel',task_name: 'make food for dinner',isFinish:false),
//    Task(frequency: 'every day',performer:'or',task_name: 'claen the toilete',isFinish:true),
//    Task(frequency: 'every month',performer:'yuval',task_name: 'take the dog to trip',isFinish:true),
//  ];
//
//
//
//
//class _TaskPageState extends State<TaskPage> {
//  final List<Task>_dayTaskList=[];
//  final List<Task>_weekTaskList=[];
//  final List<Task>_monthTaskList=[];
//
//  final List<Task>_taskList=[
//    Task(frequency: 'every day',performer:'yuval',task_name: 'claen the room',isFinish:false),
//    Task(frequency: 'every week',performer:'miriel',task_name: 'make food for dinner',isFinish:false),
//    Task(frequency: 'every day',performer:'or',task_name: 'claen the toilete',isFinish:true),
//    Task(frequency: 'every month',performer:'yuval',task_name: 'take the dog to trip',isFinish:true),
//  ];
//
//  //splitTasks(_taskList,_dayTaskList,_weekTaskList,_monthTaskList);
//
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      padding: const EdgeInsets.all(0),
//      itemCount: _taskList.length,
//      itemBuilder: (context, index) {
//        return _taskList[index].isFinish
//            ? _taskComlete(_taskList[index].task_name)
//            : _taskUncomlete(_taskList[index].task_name);
//      },
//    );
//  }
//
//  Widget _taskUncomlete(String task) {
//    return InkWell(
//      onTap: (){
//
//        showDialog(
//          context: context,
//          builder: (context){
//            return Dialog(
//              child: Column(
//                children: <Widget>[
//                    Text("Confirm Task",
//                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),
//                    )
//                ],
//              ),
//            );
//          }
//        );
//      },
//      onLongPress: (){
//
//      },
//      child: Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//        child: Row(
//          children: <Widget>[
////            IconButton(
////              icon: Icon(Icons.radio_button_unchecked,
////                color: Colors.teal,
////              ),
////              onPressed: () {
////                //to move to compelete and change icon
////                setState(() {
////
////                });
////              },
////            ),
//          Icon(
//            Icons.radio_button_unchecked,
////            color:Theme.of(context).accentColor,
//            color: Colors.teal,
//            size: 20,
//          ),
//            SizedBox(
//              width: 28,
//            ),
//            Text(task, style: TextStyle(fontSize: 20,),),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _taskComlete(String task) {
//    return Container(
//      foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
//      child: Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//        child: Row(
//          children: <Widget>[
//            Icon(
//              Icons.radio_button_checked,
////              color:Theme.of(context).accentColor,
//              color: Colors.teal,
//              size: 20,
//            ),
////            IconButton(
////              icon: Icon(Icons.radio_button_checked,
////                color: Colors.teal,
////              ),
////              onPressed: () {
////                //to move to compelete and change icon
////                setState(() {
////                  _taskList[1].isFinish=false;
////                });
////              },
////            ),
//            SizedBox(
//              width: 28,
//            ),
//            Text(task, style: TextStyle(fontSize: 20,),)
//          ],
//        ),
//      ),
//    );
//  }
//
//
// void splitTasks(List<Task>_taskList,_dayTaskList,_weekTaskList,_monthTaskList){
//
//    for (var i=0; i<_taskList.length;i++){
//      if(_taskList[i].frequency=="evey day"){
//        _dayTaskList.add(_taskList[i]);
//      }
//      else if(_taskList[i].frequency=="evey week"){
//        _weekTaskList.add(_taskList[i]);
//      }
//      else{
//        _monthTaskList.add(_taskList[i]);
//      }
//    }
// }
//
//}





