class Refund {
  final String username;
  final String value;

  Refund(this.username, this.value);


  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'value': value,
      };
}