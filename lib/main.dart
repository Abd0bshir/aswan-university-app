
import 'package:au/screens/wrapper.dart';
import 'package:au/services/auth.dart';
import 'package:au/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/Users.dart';
import 'models/department.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Users?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),
        StreamProvider<List<Department>?>.value(
          value: DatabaseService().departments, // بدون uid
          initialData: null,
          catchError: (_, __) => null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
