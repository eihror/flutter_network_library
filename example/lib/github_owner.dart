class GithubOwner {
  int? id;

  GithubOwner({
    this.id,
  });

  factory GithubOwner.fromJson(Map<String, dynamic> json) => GithubOwner(
        id: json['id'] as int?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
      };

  @override
  String toString() {
    return 'GithubOwner{id: $id}';
  }
}
