import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:zowe_flutter/models/data_set.dart';
import 'package:zowe_flutter/models/response_status_message.dart';
import 'package:zowe_flutter/services/api.dart';

enum DataSetContentStatus { Loading, Success, Error }

class DataSetContentProvider with ChangeNotifier{
  DataSetContentStatus _status = DataSetContentStatus.Loading;
  DataSet _dataSet;
  String _content = "";

  DataSetContentProvider.initial({String dataSetName, String authToken}) {
    getDataSetContent(dataSetName: dataSetName, authToken: authToken);
  }

  DataSetContentStatus get status => _status;
  DataSet get dataSet => _dataSet;
  String get content => _content;

  /// Get list of data sets with filter.
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
    return ResponseStatusMessage(status: 'Success', message: 'Data set content fetched!', error: false);
  }
}