import 'dart:collection';
import 'package:timetable/models/lesson.dart';
import 'dart:convert';

class Note {
  String title;
  String content;
  Note({required this.title, this.content = ""});

  Map<String, dynamic> toJson() => {'title': title, 'content': content};

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(title: json['title'], content: json['content']);
  }
}

String notesToJson(List<Lesson> lessons) {
  Map<String, dynamic> map = {};
  for (var lesson in lessons) {
    if (lesson.note != null) {
      map[lesson.toString()] = {
        'title': lesson.note!.title,
        'content': lesson.note!.content,
      };
    }
  }
  return jsonEncode(map);
}

enum PendingState { none, hasNote }

class PendingNote {
  final PendingState state;
  Note? note;
  PendingNote(this.state, this.note);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['state'] = state.index;
    if (state == PendingState.hasNote) {
      map['note'] = note!.toJson();
    }
    return map;
  }

  factory PendingNote.fromJson(Map<String, dynamic> json) {
    final jsonState = PendingState.values[json['state']];
    if (jsonState == PendingState.hasNote) {
      return PendingNote(jsonState, Note.fromJson(json['note']));
    }
    return PendingNote(jsonState, null);
  }
}

// Урок может перенестись, при этом для следующих за ним пар может быть задача. Для того, чтобы сохранить верный порядок заметок, в очереди для этого урока останется PendingNote с state.none

class PendingNotes {
  Map<String, Queue<PendingNote>> data = {};

  void enqueue(Lesson lesson, Note note) {
    data[lesson.id] ??= Queue();
    if (data[lesson.id]!.isNotEmpty) {
      PendingNote queueNote = data[lesson.id]!.first;
      if (queueNote.note == null) {
        queueNote.note = note;
        return;
      }
    }
    data[lesson.id]!.add(PendingNote(PendingState.hasNote, note));
  }

  Note? dequeueNote(String id) {
    var notesQueue = data[id];
    if (notesQueue != null && notesQueue.isNotEmpty) {
      final futureNote = notesQueue.removeFirst();
      if (futureNote.state == PendingState.hasNote) {
        return futureNote.note;
      } else {
        return null;
      }
    }
    data.remove(id); // Если очередь пустая, то её надо удалить
    return null;
  }

  bool hasPendingNotes(Lesson lesson) {
    return data[lesson.id] != null && data[lesson.id]!.isNotEmpty;
  }

  void syncFromLessons(List<Lesson> lessons) {
    int i = lessons.length - 1;
    final now = DateTime.now();
    while (i >= 0 && lessons[i].dateTime.isAfter(now)) {
      _enqueueAtFront(lessons[i], lessons[i].note);
      --i;
    }
  }

  void _enqueueAtFront(Lesson lesson, Note? note) {
    if (data[lesson.id] == null) {
      data[lesson.id] = Queue();
    }
    final state = note == null ? PendingState.none : PendingState.hasNote;
    data[lesson.id]!.addFirst(PendingNote(state, note));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    for (var entry in data.entries) {
      Queue<PendingNote> queue = entry.value;
      List<dynamic> lst = queue.map((e) => e.toJson()).toList();
      map[entry.key] = lst;
    }
    return map;
  }

  void addFromJson(String? json) {
    if (json == null) return;
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    decoded.forEach((key, value) {
      Queue<PendingNote> queue = Queue();
      final list = value as List<dynamic>;
      for (var elem in list) {
        queue.add(PendingNote.fromJson(elem as Map<String, dynamic>));
      }
      data[key] = queue;
    });
  }
}
