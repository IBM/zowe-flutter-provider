import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/job_step.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/models/job.dart';
import 'package:zowe_flutter/providers/job_list.dart';
import 'package:zowe_flutter/widgets/alert_widget.dart';
import 'package:zowe_flutter/widgets/loading_widget.dart';

class JobListScreen extends StatefulWidget {
 @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => JobListProvider.initial(authToken: auth.user.token),
      child: Consumer(
        builder: (context, JobListProvider jobListProvider, _) {
          switch (jobListProvider.status) {
            case Status.Success:
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                      padding: EdgeInsets.only(top: 32.0),
                      itemCount: jobListProvider.jobList.length,
                      itemBuilder: (context, index) => JobItem(
                          job: jobListProvider.jobList[index]),
                      )
                    ),
                    RaisedButton(
                      child: Text('Refresh'),
                      onPressed: () {
                        jobListProvider.getJobs(authToken: auth.user.token);
                      }
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

class JobItem extends StatelessWidget {
  final Job job;

  JobItem({this.job});

  @override
  Widget build(BuildContext context) {
    final jobListProvider = Provider.of<JobListProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final active = true;
    return ListTile(
      title: Text(job.jobName + ' ' + job.jobId),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.black,
            onPressed: !active ? null : () async {
              await Navigator.pushNamed(context, 'jobContent', arguments: [job.owner, job.jobId]);
            },
            tooltip: 'Display',
          ),
          IconButton(
            icon: Icon(Icons.storage),
            color: Colors.green,
            onPressed: () async {
              // Fetch job steps
              await jobListProvider.getSteps(
                jobName: job.jobName,
                jobId: job.jobId,
                authToken: authProvider.user.token
              );

              // Dialog that displays steps
              return showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                    title: Text('Job Steps - ${job.jobName} ${job.jobId}'),
                    content: Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child:
                            ListView.builder(
                              itemBuilder: (context, index) => ListTile(
                                title: Text(jobListProvider.stepList[index].name),
                                subtitle: Text('Program: ' + jobListProvider.stepList[index].program),
                                leading: Text(jobListProvider.stepList[index].step.toString())
                              ),
                              itemCount: jobListProvider.stepList.length,
                            ),
                          )
                        ]
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Show',
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            color: Colors.redAccent,
            onPressed: !active ? null : () async {
              ResponseStatusMessage response = await jobListProvider.deleteJob(
                jobName: job.jobName,
                jobId: job.jobId,
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
      leading: Text(job.executionClass, style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle:
          Text('Status: ${job.status}\nPhase name: ${job.phaseName}\nType: ${job.type}'),
      dense: false,
      isThreeLine: true,
    );
  }
}
