import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/Splash_Screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => Userprovider(),
      
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          fontFamily: "Poppins"),
      home: const SplashScreen(),
    );
  }
}
