import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mad_proj/movies.dart';
import 'package:tmdb_api/tmdb_api.dart'; // Don't remove this, for some reason it breaks. Typical dev stuff...
import 'firebase_options.dart';
import 'dart:developer' as developer;

void main() async {
  //Initializing Firebase Database and the app
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
  // Variables to use with the login function
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final db = FirebaseFirestore.instance;

  // Async function to login using Firebase's Firestore db
  Future<void> loginAsync(String username, String password) async {
    try {
      // This give the variable path to the users collection in the db
      final userLog = db.collection("users").doc(username);

      // Getting the document field
      userLog.get().then(
        (DocumentSnapshot doc) {
          // If exist, it will get its content
          if (doc.exists) {
            // Map the data to a variable, save it in variable with regrex of removing '()'
            final data = doc.data() as Map<String, dynamic>;
            var dataPass = data.values.toString();
            var newpass = dataPass.replaceAll(RegExp('[^A-Za-z0-9]'), '');
            developer.log('Password in firestore: $newpass');
            developer.log('Password entered: $password');

            // Comparing the input password with the stored password of the user
            if (password == newpass) {
              //If success, show a toast...
              developer.log('User successfully logged!');
              Fluttertoast.showToast(
                  msg: "Successfully Logged In!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(255, 230, 242, 255),
                  textColor: Colors.black,
                  fontSize: 16.0);

              // and route to the next page (movies.dart)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            } else {
              // Else, go here. Self-explanatory
              Fluttertoast.showToast(
                  msg: "Wrong Username or Password!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(255, 230, 242, 255),
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          } else {
            // Else, go here. Self-explanatory
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
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: TextField(
                controller: _username,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: 'Username'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Password'),
                  style: const TextStyle(color: Colors.white)),
            ),
            SizedBox(
                height: 60, //height of button
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 3),
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
                    child: const Text('PROCEED')))
          ]),
    ));
  }
}
