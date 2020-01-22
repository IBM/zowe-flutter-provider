import 'dart:convert';

UnixFile unixFileFromJson(String str) => UnixFile.fromJson(json.decode(str));
String unixFileToJson(UnixFile data) => json.encode(data.toJson());

class UnixFile {
  List<Child> children;
  String group;
  String lastModified;
  String owner;
  String permissionsSymbolic;
  int size;
  String type;

  UnixFile({
    this.children,
    this.group,
    this.lastModified,
    this.owner,
    this.permissionsSymbolic,
    this.size,
    this.type,
  });

  factory UnixFile.fromJson(Map<String, dynamic> json) => UnixFile(
        children:
            List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
        group: json["group"],
        lastModified: json["lastModified"],
        owner: json["owner"],
        permissionsSymbolic: json["permissionsSymbolic"],
        size: json["size"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "group": group,
        "lastModified": lastModified,
        "owner": owner,
        "permissionsSymbolic": permissionsSymbolic,
        "size": size,
        "type": type,
      };
}

class Child {
  String link;
  String name;
  String type;

  Child({
    this.link,
    this.name,
    this.type,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        link: json["link"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "name": name,
        "type": type,
      };
}
