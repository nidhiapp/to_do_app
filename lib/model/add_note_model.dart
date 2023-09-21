class AddNoteModel {
  int? id;
  String? title;
  DateTime? date;
  String? priority;
  int? status;

  AddNoteModel({this.date, this.priority, this.title, this.status});
  AddNoteModel.withId(
      {this.id, this.date, this.priority, this.title, this.status});

  Map<String, dynamic> toMap() {
    final noteMap = Map<String, dynamic>();
    if (id != null) {
      noteMap['id'] = id;
     
    }
    noteMap['title'] = title;
    noteMap['date'] = date!.toIso8601String();
    noteMap['priority'] = priority;
    noteMap['status'] = status;

    return noteMap;
  }

  factory AddNoteModel.fromMap(Map<String, dynamic> noteMap) {
    return AddNoteModel.withId(
        id: noteMap['id'],
        title: noteMap['title'],
        date: DateTime.parse(noteMap['date']),
        priority: noteMap['priority'],
        status: noteMap['status']);
  }
}
