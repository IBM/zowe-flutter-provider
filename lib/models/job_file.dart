import 'dart:convert';

JobFile jobFileFromJson(String str) => JobFile.fromJson(json.decode(str));
String jobFileToJson(JobFile data) => json.encode(data.toJson());

class JobFile {
  int byteCount;
  String ddName;
  int id;
  int recordCount;
  String recordFormat;
  int recordLength;

  JobFile({
    this.byteCount,
    this.ddName,
    this.id,
    this.recordCount,
    this.recordFormat,
    this.recordLength,
  });

  factory JobFile.fromJson(Map<String, dynamic> json) => JobFile(
        byteCount: json["byteCount"],
        ddName: json["ddName"],
        id: json["id"],
        recordCount: json["recordCount"],
        recordFormat: json["recordFormat"],
        recordLength: json["recordLength"],
      );

  Map<String, dynamic> toJson() => {
        "byteCount": byteCount,
        "ddName": ddName,
        "id": id,
        "recordCount": recordCount,
        "recordFormat": recordFormat,
        "recordLength": recordLength,
      };
}
