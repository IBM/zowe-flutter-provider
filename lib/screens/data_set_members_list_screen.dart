import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/providers/data_set_members_list.dart';
import 'package:zowe_flutter/widgets/alert_widget.dart';
import 'package:zowe_flutter/widgets/loading_widget.dart';

class DataSetMembersListScreen extends StatefulWidget {
  @override
  _DataSetMembersListScreenState createState() => _DataSetMembersListScreenState();
}

class _DataSetMembersListScreenState extends State<DataSetMembersListScreen> {
  @override
  Widget build(BuildContext context) {
    final String dataSetName =
        ModalRoute.of(context).settings.arguments as String;
    final auth = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => DataSetMembersListProvider.initial(
        dataSetName: dataSetName, 
        authToken: auth.user.token
      ),
      child: Consumer(
        builder: (context, DataSetMembersListProvider dataSetMembersListProvider, _) {
           switch (dataSetMembersListProvider.status) {
            case Status.Loading:
              return LoadingWidget();
            case Status.Success:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Members of ${dataSetMembersListProvider.dataSetName}'),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                            padding: EdgeInsets.all(16.0),
                            itemCount: dataSetMembersListProvider.members.length,
                            itemBuilder: (context, index) => DataSetMemberItem(
                                memberName: dataSetMembersListProvider.members[index]),
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case Status.Empty:
              return AlertWidget(
                message: 'This data set has no members.',
                color: Colors.amber,
                icon: Icons.assistant,
                back:true,
              );
            case Status.Error:
            default:
              return AlertWidget(
                message: 'An error occured!',
                color: Colors.redAccent,
                icon: Icons.warning,
                back: true,
              );
          }
          
        },
      ),
    );
  } 
}

class DataSetMemberItem extends StatelessWidget {
  final String memberName;
  DataSetMemberItem({this.memberName});

  @override
  Widget build(BuildContext context) {
    final dsMembersProvider = Provider.of<DataSetMembersListProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final active = dsMembersProvider.actionStatus == ActionStatus.Idle;
    return ListTile(
      title: Text(memberName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.black,
            onPressed: !active ? null : () async {
              final result = await Navigator.pushNamed(context, 'dataSetContent', arguments: '${dsMembersProvider.dataSetName}($memberName)');
              if (result == 'refresh') {
                dsMembersProvider.getDataSetMembers(
                  dataSetName: dsMembersProvider.dataSetName,
                  authToken: authProvider.user.token);
              }
            },
            tooltip: 'Display',
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.green,
            onPressed: !active ? null : () async {
              ResponseStatusMessage response = await dsMembersProvider.submitAsJob(
                memberName: memberName, 
                authToken: authProvider.user.token
              );

              if (response.error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${response.status}: ${response.message}', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${response.message}', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                ));
              }
            },
            tooltip: 'Submit as a job',
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            color: Colors.redAccent,
            onPressed: !active ? null : () async {
              ResponseStatusMessage response = await dsMembersProvider.deleteDataSet(
                memberName: memberName,
                authToken: authProvider.user.token,
              );

              if (response.error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${response.status}: ${response.message}', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('${response.message}', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                ));
              }
            },
            tooltip: 'Delete',
          ),
        ],
      ),
      dense: false,
      isThreeLine: true,
      subtitle: Text('PDS Member'),
    );
  }

}

