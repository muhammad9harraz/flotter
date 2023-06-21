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
  String movieTitle = '';
  String moviePoster = '';
  String movieDate = '';

  final apiKey = 'ccd287a77249d372162613f50c9972e3';

  TextEditingController _movieNameController = TextEditingController();

  Future<void> searchMovie(String movieName) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?query=$movieName&api_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final results = jsonResponse['results'][0];

      movieTitle = results['title'];
      moviePoster = results['poster_path'];
      movieDate = results['release_date'];

      print(movieTitle);
      print(moviePoster);
      print(movieDate);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
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
          ),
          //SizedBox(height: 10),
          Container(
            width: 200,
            height: 200,
            child: (moviePoster != null && moviePoster.isNotEmpty)
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500$moviePoster',
                    fit: BoxFit.cover,
                  )
                : Placeholder(),
          ),
          SizedBox(height: 20),
          Text(
            'Title: $movieTitle\n' 'Release Date: $movieDate',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
