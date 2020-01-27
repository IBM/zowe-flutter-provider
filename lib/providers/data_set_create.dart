import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/services.dart';

class DataSetCreateProvider with ChangeNotifier {
  ActionStatus _status = ActionStatus.Idle;
  DataSet _dataSet = new DataSet(
    allocationUnit: 'AllocationUnit.TRACK',
    averageBlock: 500,
    blockSize: 400,
    dataSetOrganization: 'DataSetOrganization.PO',
    deviceType: '3390',
    directoryBlocks: 5,
    name: 'HLQ.ZOWE',
    primary: 10,
    secondary: 5,
    recordFormat: 'FB',
    recordLength: 80
  );

  DataSet get dataSet => _dataSet;
  ActionStatus get status => _status;

  Future<ResponseStatusMessage> createDataSet({String authToken}) async {
    print(_dataSet.name);
    _status = ActionStatus.Working;
    notifyListeners();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    Map<String, dynamic> requestBody = _dataSet.toPostJson();
    String requestBodyJson = json.encode(requestBody);
    print(requestBodyJson);

    final url = '${ApiService.DATA_SET_ENDPOINT}';
    var response = await ApiService.ioClient.post(url, headers: headers, body: requestBodyJson);
    _status = ActionStatus.Idle;
    notifyListeners();

    // Error occured
    if (response.statusCode >= 400) {
        if (response.body == null ||response.body == '') {
          return ResponseStatusMessage(error: true, status: 'Error', message: response.statusCode.toString());
        }
        var jsonBody = json.decode(response.body);
        return ResponseStatusMessage.fromJson(jsonBody);
    }

    return ResponseStatusMessage(status: 'Success', message: 'Data set is created!', error: false);
  }

  void resetDataSet() {
    _dataSet = new DataSet();
  }
}