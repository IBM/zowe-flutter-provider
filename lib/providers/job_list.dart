import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/job.dart';
import 'package:zowe_flutter/models/job_step.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/api.dart';

class JobListProvider with ChangeNotifier{
  Status _status = Status.Loading;
  ActionStatus _actionStatus = ActionStatus.Idle;
  List<Job> _jobList = [];

  Status _stepStatus = Status.Loading;
  List<JobStep> _stepList = [];

  JobListProvider.initial({String authToken}) {
    getJobs(authToken: authToken);
  }

  Status get status => _status;
  ActionStatus get actionStatus => _actionStatus;
  List<Job> get jobList => _jobList;
  Status get stepStatus => _stepStatus;
  List<JobStep> get stepList => _stepList;


  /// Get list of jobs.
  Future<ResponseStatusMessage> getJobs({String authToken}) async {
    _status = Status.Loading;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.JOB_ENDPOINT}';
    Response response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _status = Status.Error;
      _jobList = [];
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }


    Iterable items = jsonBody['items'];
    List<Job> jobs = items.map((item) => Job.fromJson(item)).toList();

    _status = Status.Success;
    _jobList = jobs;

    if (jobs.length == 0) {
      _status = Status.Empty;
    }
    notifyListeners();

    return ResponseStatusMessage(status: 'Success', message: 'Job list fetched', error: false);
  }

  /// Get steps of a job.
  Future<ResponseStatusMessage> getSteps({String jobName, String jobId, String authToken}) async {
    _stepStatus = Status.Loading;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.JOB_ENDPOINT}/$jobName/$jobId/steps';
    print(url);
    Response response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _stepStatus = Status.Error;
      _jobList = [];
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    print(response.body);
    Iterable items = jsonBody;
    List<JobStep> steps = items.map((item) => JobStep.fromJson(item)).toList();

    _stepStatus = Status.Success;
    _stepList = steps;

    if (steps.length == 0) {
      _stepStatus = Status.Empty;
    }
    notifyListeners();

    return ResponseStatusMessage(status: 'Success', message: 'Job steps fetched', error: false);
  }

  /// Delete data set
  Future<ResponseStatusMessage> deleteJob({String jobName, String jobId, String authToken}) async {
    _actionStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.JOB_ENDPOINT}/$jobName/$jobId';
    var response = await ApiService.ioClient.delete(url, headers: headers);

    _actionStatus = ActionStatus.Idle;
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Job purged', error: false);
  }
}