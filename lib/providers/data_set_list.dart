import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/api.dart';

enum Status { Loading, Success, Error, Empty }
enum ActionStatus { Idle, Working }

class DataSetListProvider with ChangeNotifier{
  Status _status = Status.Loading;
  ActionStatus _actionStatus = ActionStatus.Idle;
  List<DataSet> _dataSetList = [];
  String _filter = "";

  DataSetListProvider.initial() {
    getDataSets(filterString: 'z406400', authToken: 'WjQwNjQwOjEzNTc');
  }

  Status get status => _status;
  ActionStatus get actionStatus => _actionStatus;
  List<DataSet> get dataSetList => _dataSetList;
  String get filter => _filter;

  /// Get list of data sets with filter.
  Future<ResponseStatusMessage> getDataSets({String filterString, String authToken}) async {
    _status = Status.Loading;
    notifyListeners();

    // if filter is empty don't bother with http request
    if (filterString == '') {
      _status = Status.Success;
      _dataSetList = [];
      notifyListeners();
      return ResponseStatusMessage(status: 'Success', message: 'Data set list fetched', error: false);
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$filterString';
    Response response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);

    if (response.statusCode >= 400) {
      _status = Status.Error;
      _dataSetList = [];
      notifyListeners();
      return ResponseStatusMessage.fromJson(jsonBody);
    }


    Iterable items = jsonBody['items'];
    List<DataSet> dataSets = items.map((item) => DataSet.fromJson(item)).toList();

    _status = Status.Success;
    _dataSetList = dataSets;

    if (dataSets.length == 0) {
      _status = Status.Empty;
    }
    notifyListeners();

    return ResponseStatusMessage(status: 'Success', message: 'Data set list fetched', error: false);
  }

  /// Delete data set
  Future<ResponseStatusMessage> deleteDataSet({String dataSetName, String authToken}) async {
    _actionStatus = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName';
    var response = await ApiService.ioClient.delete(url, headers: headers);

    _actionStatus = ActionStatus.Idle;
    if (response.statusCode >= 400) {
      var jsonBody = json.decode(response.body);  // it is empty if successful
      return ResponseStatusMessage.fromJson(jsonBody);
    }

    _dataSetList.removeWhere((ds) => ds.name == dataSetName);
    notifyListeners();
    return ResponseStatusMessage(status: 'Success', message: 'Data set deleted', error: false);
  }

  /// Submit data set as a job
  Future<ResponseStatusMessage> submitAsJob({String dataSetName, String authToken}) async {
    _actionStatus = ActionStatus.Working;
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