import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Movie',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiKey = 'ccd287a77249d372162613f50c9972e3';
  final url = Uri.parse('https://api.themoviedb.org/3/search/movie');
  TextEditingController _movieNameController = TextEditingController();

  Future<void> searchMovie(String movieName) async {
    final queryParams = {
      'api_key': apiKey,
      'query': movieName,
    };

    final response = await http.get(url.replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final movieTitle = jsonResponse['title'];
      final movieDirector = jsonResponse['director'];

      // Update the UI with the movie details
      print('Title: $movieTitle');
      print('Director: $movieDirector');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _movieNameController,
            decoration: const InputDecoration(hintText: 'Search Movie'),
          ),
          ElevatedButton(
            onPressed: () {
              final movieName = _movieNameController.text;
              searchMovie(movieName);
            },
            child: const Text('Search'),
          )
        ],
      ),
    );
  }
}
