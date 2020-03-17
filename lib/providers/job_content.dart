import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/api.dart';

enum JobContentStatus { Loading, Success, Error }


class JobContentProvider with ChangeNotifier{
  JobContentStatus _status = JobContentStatus.Loading;

  String _content = "";

  JobContentProvider.initial({String username, String jobId, String authToken}) {
    getJobContent(username: username, jobId: jobId, authToken: authToken);
  }

  JobContentStatus get status => _status;
  String get content => _content;

  /// Get content of a data set
  Future<ResponseStatusMessage> getJobContent({String username, String jobId, String authToken}) async {
    _status = JobContentStatus.Loading;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.JOB_ENDPOINT}/$username/$jobId/files/content';
    var response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _content = "";
      _status = JobContentStatus.Error;
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    _content = jsonBody['content'];
    _status = JobContentStatus.Success;
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Job content fetched!', error: false);
  }

}