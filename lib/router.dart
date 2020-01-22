import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zowe_flutter/screens/data_set_content_screen.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

const String initialRoute = 'login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Route arrived: ${settings.name}');
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case 'dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case 'dataSetContent':
        var dataSetName = settings.arguments as String;
        print('Router arrived at dataSetContent with $dataSetName');
        return MaterialPageRoute(builder: (_) => DataSetContentScreen(dataSetName: dataSetName));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('404 ${settings.name} route not found.'),
                  ),
                ));
    }
  }

  static Map<String, WidgetBuilder> buildRoutes(BuildContext context) =>
      <String, WidgetBuilder>{
        'login': (BuildContext context) => LoginScreen(),
        'dashboard': (BuildContext context) => DashboardScreen(),
      };
}
