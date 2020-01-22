import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/providers/data_set_content.dart';

class DataSetContentScreen extends StatefulWidget {
  final String dataSetName;

  DataSetContentScreen({this.dataSetName});

  @override
  _DataSetContentScreenState createState() => _DataSetContentScreenState();
}

class _DataSetContentScreenState extends State<DataSetContentScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => DataSetContentProvider.initial(
        dataSetName: widget.dataSetName,
        authToken: auth.user.token,
      ),
      child: Consumer(
        builder: (context, DataSetContentProvider dsContentProvider, _) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(dsContentProvider.content ?? 'Loading...')
              ],
            ),
          );
        },
      ),
    );
  }
}

