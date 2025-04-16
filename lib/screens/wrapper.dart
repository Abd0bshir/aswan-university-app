
import 'package:au/screens/authenticate/authenticate.dart';
import 'package:au/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Users.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user =  Provider.of<Users?>(context);
    if (user == null )
      {
        return Authenticate();
      }
    else{
      return Home();
    }
    return Authenticate();
  }
}
