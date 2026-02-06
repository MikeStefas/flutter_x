import 'package:flutter/material.dart';

class DataField extends StatelessWidget {
  const DataField({
    super.key,
    required this.dataController,
    required this.label,
  });

  final TextEditingController dataController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: label == 'password' ? true : false, //passwords are obscure
      controller: dataController,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.lightBlueAccent),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
