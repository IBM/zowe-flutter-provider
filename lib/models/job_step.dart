import 'dart:convert';

JobStep jobStepFromJson(String str) => JobStep.fromJson(json.decode(str));
String jobStepToJson(JobStep data) => json.encode(data.toJson());

class JobStep {
  String name;
  String program;
  int step;

  JobStep({
    this.name,
    this.program,
    this.step,
  });

  factory JobStep.fromJson(Map<String, dynamic> json) => JobStep(
        name: json["name"],
        program: json["program"],
        step: json["step"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "program": program,
        "step": step,
      };
}
