import 'package:flutter/material.dart';
import 'package:pokecho/screens/autenticazione.dart';
import 'package:pokecho/screens/info.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokecho/screens/utente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;

  CustomAppBarHome({
    Key? key,
    required this.title,
    required this.context,
  }) : super(key: key);

  @override
  _CustomAppBarHomeState createState() => _CustomAppBarHomeState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarHomeState extends State<CustomAppBarHome> {
  late SharedPreferences _prefs;
  List<Widget>? actions;

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    actions = [
      IconButton(
        onPressed: () {
          if (_prefs.getBool("login") == true) {
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => Utente()),
            );
          } else {
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => Autenticazione()),
            );
          }
        },
        icon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            widget.context,
            MaterialPageRoute(builder: (context) => const Info()),
          );
        },
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
      ),
    ];

    _initializePrefs();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SvgPicture.asset(
            "assets/img/logos/pokecho_logo_white.svg",
            height: 50,
            fit: BoxFit.contain,
          ),
          Text(""),
        ],
      ),
      actions: actions,
      backgroundColor: const Color(0xFFD02525),
      automaticallyImplyLeading: false,
    );
  }
}
