import 'package:chat_room/provider/theme_provider.dart';
import 'package:chat_room/screens/home.dart';
import 'package:chat_room/screens/passcode_lock.dart';
import 'package:chat_room/screens/sign_in.dart';
import 'package:chat_room/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'ChatRoom',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            home: FutureBuilder(
              future: Auth().getCurrentUser(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return PasscodeLock();
                } else {
                  return SignIn();
                }
              },
            ),
          );
        });
  }
}
