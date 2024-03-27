import 'package:flutter/material.dart';
import 'package:pokecho/screens/info.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context; //serve ad ottenere il contesto

  List<Widget>? actions;

  CustomAppBar({
    Key? key,
    required this.title,
    required this.context,
  }) : super(key: key) {
    actions = [
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
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: const Color(0xFFD02525),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
