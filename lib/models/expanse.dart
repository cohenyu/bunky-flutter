import 'package:bunky/models/user.dart';

class Expense{

  final User user;
  final String title;
  final String value;
  final String category;
  final String date;
  final int id;

  Expense({this.user, this.title, this.value, this.category, this.date, this.id});

  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'title': title,
        'value' : value,
        'category': category,
        'date': date,
        'id': id
      };
}