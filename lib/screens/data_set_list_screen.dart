import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/providers/data_set_list.dart';

class DataSetListScreen extends StatefulWidget {
  @override
  _DataSetListScreenState createState() => _DataSetListScreenState();
}

class _DataSetListScreenState extends State<DataSetListScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _filter;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _filter = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _filter = TextEditingController(text: "");
    final auth = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => DataSetListProvider.initial(),
      child: Consumer(
        builder: (context, DataSetListProvider dataSetListProvider, _) {
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
                DataSetListBody()
              ],
            ),
          );
        },
      ),
    );
  }
}

class DataSetListBody extends StatelessWidget {
  final TextStyle _alertStyle = TextStyle(
    fontSize: 36,
    fontFamily: 'Montserrat',
  );

  @override
  Widget build(BuildContext context) {
    final dsListProvider = Provider.of<DataSetListProvider>(context);

    switch (dsListProvider.status) {
      case Status.Loading:
        return Center(
          child: CircularProgressIndicator()
        );
      case Status.Success:
        return Expanded(
          child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: dsListProvider.dataSetList.length,
          itemBuilder: (context, index) => DataSetItem(
              dataSet: dsListProvider.dataSetList[index]),
          )
        );
      case Status.Empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.assistant,
                color: Colors.redAccent,
                size: 64,
              ),
              Padding(
                child:
                    Text('Data set list is empty!', style: _alertStyle),
                padding: EdgeInsets.all(16),
              ),
            ],
          ),
        );
      case Status.Error:
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.warning, color: Colors.redAccent, size: 64),
              Padding(
                child: Text('An error occured!', style: _alertStyle),
                padding: EdgeInsets.all(16),
              ),
            ],
          ),
        );
    }
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
            onPressed: !active ? null : () {
              switch (dataSet.dataSetOrganization) {
                case 'PO':
                case 'PO_E':
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('PDS', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ));
                  break;
                case 'PS':
                  Navigator.pushNamed(context, 'dataSetContent', arguments: dataSet.name);
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
