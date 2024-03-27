import 'dart:async';

import 'package:dio/dio.dart';
import 'package:example/github_owner.dart';
import 'package:example/github_repo.dart';
import 'package:flutter/material.dart';
import 'package:network/mapper/domain_result_mapper.dart';
import 'package:network/model/network_result.dart';
import 'package:network/model/result.dart';
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
      final result = await network.client
          .get<NetworkResult<List<dynamic>>>("users/eihror/repos");

      if (result.data != null) {
        final Result<List<GithubRepo>> list = result.data!
            .toDomainResult<List<dynamic>, List<GithubRepo>>((networkData) {
          return networkData.map((e) => GithubRepo.fromJson(e)).toList();
        });

        list
          ..onSuccess((data) {
            for (var element in data) {
              print(element);
            }
          })
          ..onFailure((exception) {});
      }
    } on DioException catch (e) {
      FailureUnknown(exception: e);
    }
  }

  FutureOr<void> fetchGithubUser() async {
    try {
      final result =
          await network.client.get<NetworkResult<dynamic>>("users/eihror");

      if (result.data != null) {
        final Result<GithubOwner> list =
            result.data!.toDomainResult<dynamic, GithubOwner>((networkData) {
          return GithubOwner.fromJson(networkData);
        });

        list
          ..onSuccess((data) {
            print(data);
          })
          ..onFailure((exception) {});
      }
    } on DioException catch (e) {
      FailureUnknown(exception: e);
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
