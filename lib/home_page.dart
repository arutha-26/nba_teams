import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  // get teams
  static const String apiKey = '0daa4538-0d33-44b8-b5b5-7597d46b3d1f';

  Future<void> fetchData() async {
    var response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/teams'),
      headers: {'Authorization': apiKey},
    );
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Request was successful, process the response
      print(response.body);
    } else {
      // Request failed with an error
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }
    print('Teams Total: ${teams.length}');
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'NBA Teams',
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.indigoAccent,
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          //   done loading
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    children: [
                      Text(
                          '${index + 1}. ${index + 1 == teams.length ? teams[index].city : teams[index].abbreviation}'),
                      Text(teams[index].abbreviation),
                      Text(teams[index].city),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
