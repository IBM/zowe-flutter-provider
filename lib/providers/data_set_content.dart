import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/api.dart';

enum DataSetContentStatus { Loading, Success, Error }


class DataSetContentProvider with ChangeNotifier{
  DataSetContentStatus _status = DataSetContentStatus.Loading;
  ActionStatus _deleteStatus = ActionStatus.Idle;
  ActionStatus _saveStatus = ActionStatus.Idle;
  ActionStatus _submitStatus = ActionStatus.Idle;

  DataSet _dataSet;
  String _content = "";

  DataSetContentProvider.initial({String dataSetName, String authToken}) {
    getDataSetContent(dataSetName: dataSetName, authToken: authToken);
  }

  DataSetContentStatus get status => _status;
  ActionStatus get deleteStatus => _deleteStatus;
  ActionStatus get saveStatus => _saveStatus;
  ActionStatus get submitStatus => _submitStatus;
  DataSet get dataSet => _dataSet;
  String get content => _content;

  ActionStatus get actionStatus {
    if (_deleteStatus == ActionStatus.Idle && _saveStatus == ActionStatus.Idle && _submitStatus == ActionStatus.Idle) {
      return ActionStatus.Idle;
    }
    return ActionStatus.Working;
  }

  /// Get content of a data set
  Future<ResponseStatusMessage> getDataSetContent({String dataSetName, String authToken}) async {
    _status = DataSetContentStatus.Loading;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/content';
    var response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _content = "";
      _dataSet = null;
            _status = DataSetContentStatus.Error;
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    _content = jsonBody['records'];
    _status = DataSetContentStatus.Success;
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Data set content fetched!', error: false);
  }

  /// Delete data set
  Future<ResponseStatusMessage> deleteDataSet({String dataSetName, String authToken}) async {
    _deleteStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName';
    var response = await ApiService.ioClient.delete(url, headers: headers);

    _deleteStatus = ActionStatus.Idle;
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    return ResponseStatusMessage(status: 'Success', message: 'Data set deleted', error: false);
  }

  /// Submit data set as a job
  Future<ResponseStatusMessage> submitAsJob({String dataSetName, String authToken}) async {
    _submitStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    Object requestBody = {
      'file': "'$dataSetName'"
    };
    String requestBodyJson = json.encode(requestBody);

    final url = '${ApiService.JOB_ENDPOINT}/dataset';
    var response = await ApiService.ioClient.post(url, headers: headers, body: requestBodyJson);
    _submitStatus = ActionStatus.Idle;

    // Error occured
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Job is submitted!', error: false);
  }

  /// Update data set content
  Future<ResponseStatusMessage> updateDataSetContent({String dataSetName, String content, String authToken}) async {
    _saveStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    Map<String, String> requestBody = {'records': content};
    String requestBodyJson = json.encode(requestBody);

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/content';
    var response = await ApiService.ioClient.put(url, headers: headers, body: requestBodyJson);
    _saveStatus = ActionStatus.Idle;
    // Error occured
    if (response.statusCode >= 400) {
        var jsonBody = json.decode(response.body);  // it is empty if successful
        return ResponseStatusMessage.fromJson(jsonBody);
    }

    _content = content;
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Data set content is updated!', error: false);
  }
}