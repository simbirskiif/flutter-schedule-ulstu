class Note {
  String title;
  String content;
  Note({required this.title, this.content = ""});

  Map<String, dynamic> toJson() => {'title': title, 'content': content};

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(title: json['title'], content: json['content']);
  }
}

class SavedNotes {}
