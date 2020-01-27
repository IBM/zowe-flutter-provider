import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/providers/data_set_content.dart';
import 'package:zowe_flutter/widgets/loading_widget.dart';

class DataSetContentScreen extends StatefulWidget {
  DataSetContentScreen();

  @override
  _DataSetContentScreenState createState() => _DataSetContentScreenState();
}

class _DataSetContentScreenState extends State<DataSetContentScreen> {
  TextEditingController _dsContent;

  @override
  Widget build(BuildContext context) {
    final String dataSetName =
        ModalRoute.of(context).settings.arguments as String;
    final auth = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => DataSetContentProvider.initial(
        dataSetName: dataSetName,
        authToken: auth.user.token,
      ),
      child: Consumer(
        builder: (context, DataSetContentProvider dsContentProvider, _) {
          _dsContent =
              TextEditingController(text: dsContentProvider.content ?? '');
          final active =
              dsContentProvider.status != DataSetContentStatus.Loading &&
                  dsContentProvider.actionStatus == ActionStatus.Idle;

          return Scaffold(
            appBar: AppBar(
              title: Text(dataSetName),
              actions: <Widget>[
                // Save button
                Builder(
                  builder: (context) => dsContentProvider.saveStatus ==
                          ActionStatus.Working
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Save data set content',
                          icon: Icon(Icons.save),
                          onPressed: !active
                              ? null
                              : () async {
                                  final String content = _dsContent.text;
                                  ResponseStatusMessage response =
                                      await dsContentProvider
                                          .updateDataSetContent(
                                    dataSetName: dataSetName,
                                    content: content,
                                    authToken: auth.user.token,
                                  );
                                  if (response.error) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          '${response.status}: ${response.message}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('${response.message}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.green,
                                    ));
                                  }
                                },
                        ),
                ),

                // Submit button
                Builder(
                  builder: (ctx) => dsContentProvider.submitStatus ==
                          ActionStatus.Working
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: !active
                              ? null
                              : () => {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Job Submit Confirmation'),
                                            content: Text(
                                                'Are you sure you want to submit data set named $dataSetName as a job?'),
                                            actions: <Widget>[
                                              new RaisedButton(
                                                child: new Text("Yes",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  ResponseStatusMessage
                                                      response =
                                                      await dsContentProvider
                                                          .submitAsJob(
                                                    dataSetName: dataSetName,
                                                    authToken: auth.user.token,
                                                  );

                                                  if (response.error) {
                                                    Scaffold.of(ctx)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${response.status}: ${response.message}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ));
                                                  } else {
                                                    Scaffold.of(ctx)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${response.message}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                  }

                                                  
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        })
                                  },
                        ),
                ),

                // Delete button
                Builder(
                  builder: (ctx) => dsContentProvider.deleteStatus ==
                          ActionStatus.Working
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: !active
                              ? null
                              : () => {
                                    showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            title: Text('Delete Confirmation'),
                                            content: Text(
                                                'Are you sure you want to delete data set named $dataSetName?'),
                                            actions: <Widget>[
                                              RaisedButton(
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onPressed: () async {
                                                  Navigator.of(dialogContext).pop();
                                                  ResponseStatusMessage
                                                      response =
                                                      await dsContentProvider
                                                          .deleteDataSet(
                                                    dataSetName: dataSetName,
                                                    authToken: auth.user.token,
                                                  );

                                                  if (response.error) {
                                                    Scaffold.of(ctx)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${response.status}: ${response.message}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ));
                                                  } else {
                                                    Scaffold.of(ctx)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${response.message}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                    // Force refresh upon returning to data set list
                                                    Navigator.pop(context, 'refresh');
                                                  }
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        })
                                  },
                        ),
                )
              ],
            ),
            body: dsContentProvider.status == DataSetContentStatus.Loading
                ? LoadingWidget()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text editor with data set content
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _dsContent,
                            enabled: true,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          )),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
