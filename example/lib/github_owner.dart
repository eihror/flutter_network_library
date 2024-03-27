class GithubOwner {
  int? id;
  String? login;

  GithubOwner({
    this.id,
    this.login,
  });

  factory GithubOwner.fromJson(Map<String, dynamic> json) => GithubOwner(
        id: json['id'] as int?,
        login: json['login'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'login': login,
      };

  @override
  String toString() {
    return 'GithubOwner{id: $id, login: $login}';
  }
}
