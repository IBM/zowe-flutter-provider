import 'dart:convert';

DataSet dataSetFromJson(String str) => DataSet.fromJson(json.decode(str));
String dataSetToJson(DataSet data) => json.encode(data.toJson());

class DataSet {
  int allocatedSize;
  String allocationUnit;
  int averageBlock;
  int blockSize;
  String catalogName;
  String creationDate;
  String dataSetOrganization;
  String deviceType;
  int directoryBlocks;
  String expirationDate;
  bool migrated;
  String name;
  int primary;
  String recordFormat;
  int recordLength;
  int secondary;
  int used;
  String volumeSerial;

  DataSet({
    this.allocatedSize,
    this.allocationUnit,
    this.averageBlock,
    this.blockSize,
    this.catalogName,
    this.creationDate,
    this.dataSetOrganization,
    this.deviceType,
    this.directoryBlocks,
    this.expirationDate,
    this.migrated,
    this.name,
    this.primary,
    this.recordFormat,
    this.recordLength,
    this.secondary,
    this.used,
    this.volumeSerial,
  });

  factory DataSet.fromJson(Map<String, dynamic> json) => DataSet(
        allocatedSize: json["allocatedSize"],
        allocationUnit: json["allocationUnit"],
        averageBlock: json["averageBlock"],
        blockSize: json["blockSize"],
        catalogName: json["catalogName"],
        creationDate: json["creationDate"],
        dataSetOrganization: json["dataSetOrganization"],
        deviceType: json["deviceType"],
        directoryBlocks: json["directoryBlocks"],
        expirationDate: json["expirationDate"],
        migrated: json["migrated"],
        name: json["name"],
        primary: json["primary"],
        recordFormat: json["recordFormat"],
        recordLength: json["recordLength"],
        secondary: json["secondary"],
        used: json["used"],
        volumeSerial: json["volumeSerial"],
      );

  Map<String, dynamic> toJson() => {
        "allocatedSize": allocatedSize,
        "allocationUnit": allocationUnit,
        "averageBlock": averageBlock,
        "blockSize": blockSize,
        "catalogName": catalogName,
        "creationDate": creationDate,
        "dataSetOrganization": dataSetOrganization,
        "deviceType": deviceType,
        "directoryBlocks": directoryBlocks,
        "expirationDate": expirationDate,
        "migrated": migrated,
        "name": name,
        "primary": primary,
        "recordFormat": recordFormat,
        "recordLength": recordLength,
        "secondary": secondary,
        "used": used,
        "volumeSerial": volumeSerial,
      };
}
