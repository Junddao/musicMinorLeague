import 'dart:convert';

class SendFile {
  String filePath;

  SendFile({
    this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
    };
  }

  factory SendFile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SendFile(
      filePath: map['filePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SendFile.fromJson(String source) =>
      SendFile.fromMap(json.decode(source));
}
