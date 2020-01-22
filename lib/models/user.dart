class User {
  String userId;
  String token;

  User({this.userId, this.token});

  User.initial()
      : userId = '',
        token = '';
}
