class NoticeModel {
  String? text;

  NoticeModel({this.text});

  factory NoticeModel.fromMap(map) {
    return NoticeModel(
      text: map['text']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }
}
