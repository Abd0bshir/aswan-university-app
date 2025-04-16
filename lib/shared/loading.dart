import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this line

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Or any background you prefer
      child: const Center(
        child: SpinKitChasingDots( // or any other spinkit animation
          color: Color(0xFF007C7B), // Change color as needed
          size: 50.0,
        ),
      ),
    );
  }
}