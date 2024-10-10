import 'dart:async';

import 'package:example/github_owner.dart';
import 'package:example/github_repo.dart';
import 'package:flutter/material.dart';
import 'package:network/exception/network_exception.dart';
import 'package:network/model/result.dart';
import 'package:network/network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final Network network = Network.createNetwork(
    baseUrl: "http://192.168.1.5:3000/",
  );

  FutureOr<void> fetchGithubRepo() async {
    try {
      final result =
          await network.client.get<List<dynamic>>("users/eihror/repos");

      final githubRepoListResult = Successful(
        data: result.data?.map((e) => GithubRepo.fromJson(e)).toList() ??
            List.empty(),
      );

      githubRepoListResult
        ..onSuccess((data) {
          for (var element in data) {
            print(element);
          }
        })
        ..onFailure((exception) {
          print(exception.message);
        });
    } on NetworkException catch (e) {
      print("Exception: $e");
    }
  }

  FutureOr<void> fetchGithubUser() async {
    try {
      final request = await network.client.get<dynamic>("users/eihror");

      final githubOwnerResult =
          Successful(data: GithubOwner.fromJson(request.data));

      githubOwnerResult
        ..onSuccess((data) {
          print(data);
        })
        ..onFailure((exception) {
          print(exception.message);
        });
    } on NetworkException catch (e) {
      print("Exception: $e");
    }
  }

  FutureOr<void> doLogin() async {
    try {
      final result = await network.client.post<dynamic>("auth/login",
          data: {"email": "", "password": "qwerqwer"});
    } on NetworkException catch (e) {
      print("Exception: $e");
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    widget.doLogin();

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Text("Network example"),
        ),
      ),
    );
  }
}
