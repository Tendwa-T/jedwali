import 'package:flutter/material.dart';

class Jedwali extends StatefulWidget {
  const Jedwali({super.key});

  @override
  State<Jedwali> createState() => _JedwaliState();
}

class _JedwaliState extends State<Jedwali> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JEDWALI"),
      ),
      body: const Column(
        children: [
          Center(
            child: Text("Welcome home"),
          ),
        ],
      ),
    );
  }
}
