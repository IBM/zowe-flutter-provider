import 'dart:io';
import 'package:http/io_client.dart';

class ApiService {
  static const AUTH_ENDPOINT = 'https://192.86.32.67:8544/auth';
  static const DATA_SET_ENDPOINT = 'https://192.86.32.67:8547/api/v1/datasets';
  static const JOB_ENDPOINT = 'https://192.86.32.67:7554/api/v1/jobs';

  static HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  static IOClient ioClient = new IOClient(httpClient);
}
