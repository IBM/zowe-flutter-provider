import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/router.dart';
import 'package:zowe_flutter/screens/dashboard_screen.dart';
import 'package:zowe_flutter/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MaterialColor zoweColor = MaterialColor(0xFF2A7DE1, {
    50:Color.fromRGBO(4,131,184, .1),
    100:Color.fromRGBO(4,131,184, .2),
    200:Color.fromRGBO(4,131,184, .3),
    300:Color.fromRGBO(4,131,184, .4),
    400:Color.fromRGBO(4,131,184, .5),
    500:Color.fromRGBO(4,131,184, .6),
    600:Color.fromRGBO(4,131,184, .7),
    700:Color.fromRGBO(4,131,184, .8),
    800:Color.fromRGBO(4,131,184, .9),
    900:Color.fromRGBO(4,131,184, 1),
    });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: zoweColor,
      ),
      home: HomePage(),
      routes: Router.buildRoutes(context),
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
