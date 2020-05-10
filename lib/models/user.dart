class User {
  final String name;
  final String mail;
  final int userId;

  User(this.name, this.mail, this.userId);

  factory User.fromJson(Map<String, dynamic> json){
    return User(json['name'], json['mail'], json['userId']);
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'mail': mail,
        'userId' : userId
      };
}