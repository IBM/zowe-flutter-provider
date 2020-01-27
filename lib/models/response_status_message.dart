import 'dart:convert';

ResponseStatusMessage responseStatusMessageFromJson(String str) => ResponseStatusMessage.fromJson(json.decode(str));

String responseStatusMessageToJson(ResponseStatusMessage data) => json.encode(data.toJson());

class ResponseStatusMessage {
    String status;
    String message;
    bool error;

    ResponseStatusMessage({
        this.status,
        this.message,
        this.error = true,
    });

    factory ResponseStatusMessage.fromJson(Map<String, dynamic> json) => ResponseStatusMessage(
        status: json["status"].toString(),
        message: json["message"].toString(),
        error: true,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
    };
}