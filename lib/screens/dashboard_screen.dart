import 'package:dynamic_tabs/dynamic_tabs.dart';
import 'package:flutter/material.dart';

import 'package:zowe_flutter/router.dart';
import 'package:zowe_flutter/screens/data_set_create_screen.dart';
import 'package:zowe_flutter/screens/data_set_list_screen.dart';
import 'package:zowe_flutter/screens/job_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return DynamicTabScaffold.adaptive(
        routes: Router.buildRoutes(context),
        persistIndex: true,
        maxTabs: 4,
        tabs: <DynamicTab>[
          DynamicTab(
            child: DataSetListScreen(),
            tab: BottomNavigationBarItem(
              title: Text("List Data Sets"),
              icon: Icon(Icons.view_list),
            ),
            tag: "dataSetList", // Must Be Unique
          ),
          DynamicTab(
            child: DataSetCreateScreen(),
            tab: BottomNavigationBarItem(
              title: Text("Create Data Set"),
              icon: Icon(Icons.add_box),
            ),
            tag: "dataSetCreate", // Must Be Unique
          ),
          DynamicTab(
            child: JobListScreen(),
            tab: BottomNavigationBarItem(
              title: Text("List Jobs"),
              icon: Icon(Icons.perm_data_setting),
            ),
            tag: "jobList", // Must Be Unique
          ),
          /*DynamicTab(
            child: LogoutView(),
            tab: BottomNavigationBarItem(
              title: Text("Logout"),
              icon: Icon(Icons.exit_to_app),
            ),
            tag: "logout",
          ),*/
        ]);
  }
}

class RandomScreen extends StatelessWidget {
  RandomScreen({
    @required this.title,
    @required this.color,
  });
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(title),
        ),
        SliverFillRemaining(
          child: Container(
            color: color,
          ),
        ),
      ],
    );
  }
}
