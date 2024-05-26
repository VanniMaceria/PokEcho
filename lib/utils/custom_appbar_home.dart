import 'package:flutter/material.dart';
import 'package:pokecho/screens/autenticazione.dart';
import 'package:pokecho/screens/info.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context; //serve ad ottenere il contesto

  List<Widget>? actions;

  CustomAppBarHome({
    Key? key,
    required this.title,
    required this.context,
  }) : super(key: key) {
    actions = [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Autenticazione()),
          );
        },
        icon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Info()),
          );
        },
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
      ),
    ];
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
