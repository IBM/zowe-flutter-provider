import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/models/user.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/router.dart';
import 'package:zowe_flutter/screens/dashboard_screen.dart';
import 'package:zowe_flutter/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      onGenerateRoute: Router.generateRoute,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider.instance(),
      child: Consumer(
        builder: (context, AuthProvider user, _) {
          switch (user.status) {
            case AuthStatus.Unauthenticated:
            case AuthStatus.Authenticating:
              return LoginScreen();
            case AuthStatus.Authenticated:
              return DashboardScreen();
          }
        },
      ),
    );
  }
}
