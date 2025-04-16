import 'package:flutter/material.dart';

final InputDecoration customInputDecoration = InputDecoration(
  // labelText: 'Email',
  // prefixIcon: Icon(Icons.email),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xFF007C7B),
    ),
  ),
);
