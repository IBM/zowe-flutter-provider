import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/services.dart';


class DataSetMembersListProvider extends ChangeNotifier {
  Status _status = Status.Empty;
  ActionStatus _actionStatus = ActionStatus.Idle;
  DataSet _dataSet;
  String _dataSetName;
  List<String> _members;

  DataSetMembersListProvider.initial({String dataSetName, String authToken}) {
    _dataSetName = dataSetName;
    getDataSetMembers(dataSetName: dataSetName, authToken: authToken);
    notifyListeners();
  }

  Status get status => _status;
  ActionStatus get actionStatus => _actionStatus;
  DataSet get dataSet => _dataSet;
  String get dataSetName => _dataSetName;
  List<String> get members => _members;

  /// Get list of data sets with filter.
  Future<ResponseStatusMessage> getDataSetMembers({String dataSetName, String authToken}) async {
    _status = Status.Loading;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/members';
    var response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _members = [];
      _dataSet = null;
      _status = Status.Error;
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    List<dynamic> items = jsonBody['items'];
    _members = items.map((item) => item.toString()).toList();
    _status = _members.length > 0 ? Status.Success : Status.Empty;
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Data set members fetched!', error: false);
  }

  /// Delete data set member
  Future<ResponseStatusMessage> deleteDataSet({String memberName, String authToken}) async {
    _actionStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$_dataSetName($memberName)';
    var response = await ApiService.ioClient.delete(url, headers: headers);

    _actionStatus = ActionStatus.Idle;
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    _members.removeWhere((ds) => ds == dataSetName);
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Data set deleted', error: false);
  }

  /// Submit data set as a job
  Future<ResponseStatusMessage> submitAsJob({String memberName, String authToken}) async {
    _actionStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    Object requestBody = {
      'file': "'$_dataSetName($memberName)'"
    };
    String requestBodyJson = json.encode(requestBody);

    final url = '${ApiService.JOB_ENDPOINT}/dataset';
    var response = await ApiService.ioClient.post(url, headers: headers, body: requestBodyJson);
    _actionStatus = ActionStatus.Idle;

    // Error occured
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Job is submitted!', error: false);
  }

}