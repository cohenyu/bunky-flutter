import 'package:bunky/models/categories.dart';
import 'package:bunky/models/user.dart';

class Expense{

  final User user;
  final String title;
  final String value;
  final String category;
  final String date;
  final int id;

  Expense({this.user, this.title, this.value, this.category, this.date, this.id});


  factory Expense.fromJson(Map<String, dynamic> json){
    return Expense(user: json['user'], title: json['title'], value: json['amount'], category: Categories().valueToCategoryMap()[json['categoryId']], date: json['date'], id: json['expenseId']);
  }

  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'title': title,
        'amount' : value,
        'categoryId': Categories().categoryToValueMap()[category],
        'date': date,
        'expenseId': id
      };
}