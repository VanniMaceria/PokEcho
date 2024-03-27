import 'package:flutter/material.dart';
import 'package:pokecho/utils/custom_appbar_back.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBarBack(title: "Info"),
    );
  }
}
