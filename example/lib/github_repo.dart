import 'package:example/github_owner.dart';

class GithubRepo {
  int? id;
  String? name;
  String? fullName;
  String? description;
  GithubOwner? owner;

  GithubRepo({
    this.id,
    this.name,
    this.fullName,
    this.description,
    this.owner,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) => GithubRepo(
        id: json['id'] as int?,
        name: json['name'] as String?,
        fullName: json['full_name'] as String?,
        description: json['description'] as String?,
        owner: json['owner'] == null
            ? null
            : GithubOwner.fromJson(json['owner'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'full_name': fullName,
        'description': description,
        'owner': owner,
      };

  @override
  String toString() {
    return 'GithubRepo{id: $id, name: $name, fullName: $fullName, description: $description, owner: $owner}';
  }
}
