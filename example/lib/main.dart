import 'dart:async';

import 'package:example/github_owner.dart';
import 'package:example/github_repo.dart';
import 'package:flutter/material.dart';
import 'package:network/exception/network_exception.dart';
import 'package:network/network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final Network network = Network.createNetwork(
    baseUrl: "https://api.github.com/",
  );

  FutureOr<void> fetchGithubRepo() async {
    try {
      final result =
          await network.client.get<List<dynamic>>("users/eihror/repos");

      final dataResult =
          result.data?.map((e) => GithubRepo.fromJson(e)).toList();

      if (dataResult != null) {
        for (var element in dataResult) {
          print(element);
        }
      }
    } on NetworkException catch (e) {
      print("Exception: $e");
    }
  }

  FutureOr<void> fetchGithubUser() async {
    try {
      final request = await network.client.get<dynamic>("users/eihror");

      if (request.data != null) {
        final dataResult = GithubOwner.fromJson(request.data);
        print(dataResult);
      }
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
    widget.fetchGithubRepo();

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
