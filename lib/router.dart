import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zowe_flutter/screens/dashboard_screen.dart';
import 'package:zowe_flutter/screens/data_set_content_screen.dart';
import 'package:zowe_flutter/screens/data_set_create_screen.dart';
import 'package:zowe_flutter/screens/data_set_members_list_screen.dart';
import 'package:zowe_flutter/screens/job_content_screen.dart';
import 'package:zowe_flutter/screens/login_screen.dart';


const String initialRoute = 'login';

class Router {
  static Map<String, WidgetBuilder> buildRoutes(BuildContext context) {
    return <String, WidgetBuilder>{
      'login': (BuildContext context) => LoginScreen(),
      'dashboard': (BuildContext context) => DashboardScreen(),
      'dataSetContent': (BuildContext context) => DataSetContentScreen(),
      'dataSetMembers': (BuildContext context) => DataSetMembersListScreen(),
      'dataSetCreate': (BuildContext context) => DataSetCreateScreen(),
      'jobContent': (BuildContext context) => JobContentScreen(),
    };
  }
}
