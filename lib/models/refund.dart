import 'package:bunky/models/user.dart';

class Refund {
  final User user;
  final String value;

  Refund(this.user, this.value);


  Map<String, dynamic> toJson() =>
      {
        'user': user.toJson(),
        'amount': value,
      };
}