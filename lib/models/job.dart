class Job {
  String jobId;
  String jobName;
  String owner;
  String type;
  String status;
  String returnCode;
  String subsystem;
  String executionClass;
  String phaseName;

  Job({
    this.jobId,
    this.jobName,
    this.owner,
    this.type,
    this.status,
    this.returnCode,
    this.subsystem,
    this.executionClass,
    this.phaseName,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        jobId: json["jobId"],
        jobName: json["jobName"],
        owner: json["owner"],
        type: json["type"],
        status: json["status"],
        returnCode: json["returnCode"] == null ? null : json["returnCode"],
        subsystem: json["subsystem"],
        executionClass: json["executionClass"],
        phaseName: json["phaseName"],
      );

  Map<String, dynamic> toJson() => {
        "jobId": jobId,
        "jobName": jobName,
        "owner": owner,
        "type": type,
        "status": status,
        "returnCode": returnCode == null ? null : returnCode,
        "subsystem": subsystem,
        "executionClass": executionClass,
        "phaseName": phaseName,
      };
}
