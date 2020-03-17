import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/providers/job_content.dart';
import 'package:zowe_flutter/widgets/loading_widget.dart';

class JobContentScreen extends StatefulWidget {
  JobContentScreen();

  @override
  _JobContentScreenState createState() => _JobContentScreenState();
}

class _JobContentScreenState extends State<JobContentScreen> {
  TextEditingController _jobContent;

  @override
  Widget build(BuildContext context) {
    final List<String> args = ModalRoute.of(context).settings.arguments as List<String>;
    final String jobId = args[1];
    final String username = args[0];
    final auth = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => JobContentProvider.initial(
        username: username,
        jobId: jobId,
        authToken: auth.user.token,
      ),
      child: Consumer(
        builder: (context, JobContentProvider jobContentProvider, _) {
          _jobContent =
              TextEditingController(text: jobContentProvider.content ?? '');
          
          return Scaffold(
            appBar: AppBar(
              title: Text('$username - $jobId'),
            ),
            body: jobContentProvider.status == JobContentStatus.Loading
                ? LoadingWidget()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text editor with job content
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _jobContent,
                            enabled: false,
                            maxLines: null,
                            autofocus: false,
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
