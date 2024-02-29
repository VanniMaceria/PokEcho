import 'package:flutter/material.dart';
import 'package:pokecho/utils/custom_appbar.dart';

class Ricerca extends StatefulWidget {
  const Ricerca({super.key});

  @override
  State<Ricerca> createState() => _RicercaState();
}

class _RicercaState extends State<Ricerca> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Cerca"),
    );
  }
}
