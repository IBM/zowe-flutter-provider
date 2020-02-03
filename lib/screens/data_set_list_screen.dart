import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/providers/data_set_list.dart';
import 'package:zowe_flutter/widgets/alert_widget.dart';
import 'package:zowe_flutter/widgets/loading_widget.dart';

class DataSetListScreen extends StatefulWidget {
  @override
  _DataSetListScreenState createState() => _DataSetListScreenState();
}

class _DataSetListScreenState extends State<DataSetListScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _filter;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => DataSetListProvider.initial(filterString: auth.user.userId, authToken: auth.user.token),
      child: Consumer(
        builder: (context, DataSetListProvider dataSetListProvider, _) {
          _filter = TextEditingController(text: dataSetListProvider.filter);
          switch (dataSetListProvider.status) {
            case Status.Success:
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: TextField(
                        controller: _filter,
                        decoration: InputDecoration(
                          hintText: "Filter data sets",
                          suffixIcon: IconButton(
                            onPressed: () => dataSetListProvider.getDataSets(
                              filterString: _filter.text,
                              authToken: auth.user.token,
                            ),
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: dataSetListProvider.dataSetList.length,
                      itemBuilder: (context, index) => DataSetItem(
                          dataSet: dataSetListProvider.dataSetList[index]),
                      )
                    ),
                  ],
                ),
              ); 
            case Status.Loading:
              return LoadingWidget();
            case Status.Empty:
              return AlertWidget(
                message: 'Nothing to display.',
                color: Colors.amber,
                icon: Icons.assistant,
                back: false,
              );
            case Status.Error:
            default:
              return AlertWidget(
                message: 'An error occured!',
                color: Colors.redAccent,
                icon: Icons.warning,
                back: false,
              );
          }
        }
      
      ),
    );
  }
}

class DataSetItem extends StatelessWidget {
  final DataSet dataSet;

  DataSetItem({this.dataSet});

  @override
  Widget build(BuildContext context) {
    final dsListProvider = Provider.of<DataSetListProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final active = dataSet.dataSetOrganization != null && dsListProvider.actionStatus == ActionStatus.Idle;
    return ListTile(
      title: Text(dataSet.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.black,
            onPressed: !active ? null : () async {
              switch (dataSet.dataSetOrganization) {
                case 'PO':
                case 'PO_E':
                  Navigator.pushNamed(context, 'dataSetMembers', arguments: dataSet.name);
                  break;
                case 'PS':
                  final result = await Navigator.pushNamed(context, 'dataSetContent', arguments: dataSet.name);
                  print(result);
                  if (result == 'refresh') {
                    dsListProvider.getDataSets(
                      filterString: dsListProvider.filter,
                      authToken: authProvider.user.token,
                    );
                  }
                  break;
                default:
              }
            },
            tooltip: 'Display',
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.green,
            onPressed: !active || dataSet.dataSetOrganization != 'PS' ? null : () async {
              ResponseStatusMessage response = await dsListProvider.submitAsJob(
                dataSetName: dataSet.name, 
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
              ResponseStatusMessage response = await dsListProvider.deleteDataSet(
                dataSetName: dataSet.name,
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
      leading: Text(dataSet.dataSetOrganization ?? '-', style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle:
          Text('RECF: ${dataSet.recordFormat} | RECL: ${dataSet.recordLength}'),
      dense: false,
      enabled: dataSet.dataSetOrganization != null,
      isThreeLine: true,
    );
  }
}
