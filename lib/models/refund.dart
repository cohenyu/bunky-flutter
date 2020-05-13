import 'package:bunky/models/user.dart';

class Refund {
  final User user;
  final double amount;
  final User receiver;
  final String date;


  Refund({this.user,this.receiver, this.amount, this.date});


  Map<String, dynamic> toJson() =>
      {
        'giver': user.toJson(),
        'receiver': receiver.toJson(),
        'date': date,
        'amount': amount,
      };
}