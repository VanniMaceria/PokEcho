import 'package:flutter/material.dart';
import 'package:pokecho/controller/utente_controller.dart';
import 'package:pokecho/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utente extends StatefulWidget {
  const Utente({super.key});

  @override
  State<Utente> createState() => _UtenteState();
}

class _UtenteState extends State<Utente> {
  final UtenteController _utenteController = UtenteController();
  late Future<DocumentSnapshot?> _userDetails = Future.value(null);
  late String _currentUserId = "";
  late SharedPreferences _prefs;
  late String? _userEmail;
  bool _isLoading = true; // Variabile per tracciare lo stato del caricamento

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserDetails(); // Attendi il completamento del caricamento
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true; // Inizia il caricamento
    });

    if (_prefs.getBool("login") == true) {
      _userEmail = _prefs.getString("email");
    } else {
      _userEmail = _utenteController.getCurrentUserEmail();
    }

    if (_userEmail != null) {
      _userDetails = _utenteController.getUserDetailsByEmail(_userEmail!);
      DocumentSnapshot? userDoc = await _userDetails;

      if (userDoc != null && userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _currentUserId = userDoc.id;
          _isLoading = false; // Caricamento completato
          print("UID utente: $_currentUserId");
        });
        print("Email: ${data['email']}");
      } else {
        setState(() {
          _isLoading = false; // Caricamento completato
        });
        print("User not found");
      }
    } else {
      setState(() {
        _isLoading = false; // Caricamento completato
      });
      print("User is not authenticated");
    }
  }

  Future<void> _showEditDialog(
      String field, String initialValue, Function(String) onSave) async {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: field,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfoRow(BuildContext context, String field, String value,
      Function(String)? onSave) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$field: $value"),
          if (onSave != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                _showEditDialog(field, value, onSave);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          if (_isLoading) // Mostra l'indicatore di caricamento se _isLoading è true
            Center(
              child: CircularProgressIndicator(),
            )
          else
            Positioned(
              top: 140,
              left: 16,
              child: FutureBuilder<DocumentSnapshot?>(
                future: _userDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text("User not found");
                  } else {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    return Container(
                      width: MediaQuery.of(context).size.width -
                          100, // To prevent overflow
                      child: Text(
                        "Welcome back\n${data['email']}",
                        style: TextStyle(fontSize: 30),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    );
                  }
                },
              ),
            ),
          if (!_isLoading)
            Center(
              child: FutureBuilder<DocumentSnapshot?>(
                future: _userDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text("User not found");
                  } else {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUserInfoRow(
                          context,
                          'Email',
                          data['email'],
                          (newValue) async {
                            // Logica per aggiornare l'email
                            await _utenteController.updateUserEmail(
                                snapshot.data!.id, newValue);
                            setState(() {
                              _userDetails = _utenteController
                                  .getUserDetailsByEmail(newValue);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        _buildUserInfoRow(
                          context,
                          'Password',
                          data['password'],
                          (newValue) async {
                            // Logica per aggiornare la password
                            await _utenteController.updateUserPassword(
                                snapshot.data!.id, newValue);
                            setState(() {
                              _userDetails = _utenteController
                                  .getUserDetailsByEmail(data['email']);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        _buildUserInfoRow(
                          context,
                          'Best Score',
                          data['bestScore'].toString(),
                          null,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); //Chiudi l'alert
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //l'utente va cancellato anche da Auth
                          _utenteController.deleteUser(_currentUserId);

                          //azzero la sessione dell'utente
                          _prefs.setBool("login", false);
                          _prefs.setString("email", "");
                          _prefs.setString("password", "");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RootPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text(
                          "Yes",
                          style:
                              TextStyle(color: Color(0xFFD02525), fontSize: 20),
                        ),
                      ),
                    ],
                    title: const Center(
                      child: Text(
                        'Are you sure to delete this account?\nThe action is permanent!',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.person_off_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Color(0xFFD02525),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); //Chiudi l'alert
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _utenteController.logOut();
                          _prefs.setBool("login", false);
                          _prefs.setString("email", "");
                          _prefs.setString("password", "");

                          //torna alla home e cancella la cronologia delle pagine
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RootPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text(
                          "Yes",
                          style:
                              TextStyle(color: Color(0xFFD02525), fontSize: 20),
                        ),
                      ),
                    ],
                    title: const Center(
                      child: Text(
                        'Are you sure to log out?',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.logout),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Color(0xFFD02525),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RootPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
