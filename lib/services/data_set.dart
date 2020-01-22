import 'dart:async';
import 'dart:convert';

import './api.dart';
import '../models/data_set.dart';

class DataSetService {
  /// Get list of data sets with filter.
  Future<List<DataSet>> getDataSets({String filterString, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$filterString';
    var response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);
    Iterable items = jsonBody['items'];
    return items.map((item) => DataSet.fromJson(item)).toList();
  }

  /// Get data set content.
  Future<String> getDataSetContent({String dataSetName, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/content';
    var response = await ApiService.ioClient.get(url, headers: headers);
    var jsonBody = json.decode(response.body);
    return jsonBody['records'];
  }

  /// Update contents of data set.
  Future<bool> updateDataSetContent({String dataSetName, String content, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    var data = {'records': content};
    var dataJson = json.encode(data);

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/content';
    var response =
        await ApiService.ioClient.put(url, headers: headers, body: dataJson);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Create a dataset
  Future<bool> createDataSet({DataSet dataSet, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}';
    var response = await ApiService.ioClient
        .post(url, headers: headers, body: dataSet.toJson());

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Delete data set
  Future<bool> deleteDataSet({String dataSetName, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName';
    var response = await ApiService.ioClient.delete(url, headers: headers);

    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// Get pds members
  Future<List<String>> getDataSetMembers({String dataSetName, String authToken}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + authToken,
    };

    final url = '${ApiService.DATA_SET_ENDPOINT}/$dataSetName/members';
    var response = await ApiService.ioClient.get(url, headers: headers);

    List<dynamic> items = json.decode(response.body)['items'];
    return items.map((item) => item.toString()).toList();
  }
}
