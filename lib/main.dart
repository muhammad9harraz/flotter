import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mad_proj/movies.dart';
import 'package:tmdb_api/tmdb_api.dart'; // Don't remove this, for some reason it breaks. Typical dev stuff...
import 'firebase_options.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final db = FirebaseFirestore.instance;
  late Map<String, dynamic> userInfo;

  Future<void> loginAsync(String username, String password) async {
    try {
      final userLog = db.collection("users").doc(username);
      userLog.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          var dataPass = data.values.toString();
          var newpass = dataPass.replaceAll(RegExp('[^A-Za-z0-9]'), '');
          developer.log('Password in firestore: $newpass');
          developer.log('Password entered: $password');
          if (password == newpass) {
            developer.log('User successfully logged!');
            Fluttertoast.showToast(
                msg: "Successfully Logged In!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromARGB(255, 230, 242, 255),
                textColor: Colors.black,
                fontSize: 16.0);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          } else {
            Fluttertoast.showToast(
                msg: "Wrong Username or Password!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromARGB(255, 230, 242, 255),
                textColor: Colors.black,
                fontSize: 16.0);
          }
        },
        onError: (e) => developer.log("Error getting document: $e"),
      );
    } catch (e) {
      developer.log('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login Page'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 20, bottom: 120, right: 20, top: 0),
                child: Text(
                  "MOVIE SEARCH APP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: TextField(
                  controller: _username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Username'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Password'),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    final user = _username.text;
                    final pass = _password.text;

                    if (user.isEmpty || pass.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Username and Password cannot be empty!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor:
                              const Color.fromARGB(255, 230, 242, 255),
                          textColor: Colors.black,
                          fontSize: 16.0);
                    } else {
                      loginAsync(user, pass);
                    }
                  },
                  child: const Text('PROCEED'))
            ])));
  }
}
