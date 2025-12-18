import 'package:timetable/api/fetch_final_response.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/models/filter.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/save_system/save_system.dart';
import 'package:timetable/utils/lessons.dart';
import 'package:timetable/models/note.dart';

import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';

class GroupProcessor with ChangeNotifier {
  late SessionManager _session;
  late SaveSystem _saveSystem;
  late PendingNotes _pendingNotes;
  List<Lesson> _lessons = [];
  String? _groupName;
  int _subgroupsCount = 0;
  DateTime? _scheduleStartDate;
  DateTime? _scheduleEndDate;
  DateTime? _selectedDay;
  bool isLoading = false;
  int _currentSubgroup = 0;

  GroupProcessor() {
    _lessons = [];
  }

  bool nextLessonHasNote(Lesson lesson) {
    Lesson? nextLesson = getNextLesson(lesson);
    if (nextLesson == null) {
      return _pendingNotes.hasPendingNotes(lesson);
    }
    return nextLesson.note != null;
  }

  Lesson? getNextLesson(Lesson lesson) {
    int index = _lessons.indexWhere((e) => e == lesson) + 1;
    for (int i = index; i < _lessons.length; ++i) {
      if (_lessons[i].id == lesson.id) {
        return _lessons[i];
      }
    }
    return null;
  }

  void addNoteToNext(Lesson lesson, Note note) {
    var nextLesson = getNextLesson(lesson);
    if (nextLesson != null) {
      setNote(nextLesson, note);
      return;
    }
    _pendingNotes.enqueue(lesson, note);
    _saveSystem.savePendingNotes(_pendingNotes);
    notifyListeners();
  }

  void attachPendingNotes() {
    final now = DateTime.now();
    var currentLessons = _lessons.where(
      (lesson) => lesson.dateTime.isAfter(now),
    );
    for (var lesson in currentLessons) {
      lesson.note = _pendingNotes.dequeueNote(lesson.id);
    }
  }

  void importSavedNotes(Map<String, Note> map) {
    for (Lesson lesson in _lessons) {
      lesson.note = map[lesson.toString()];
    }
  }

  Note? getNote(Lesson lesson) {
    return lesson.note; // Необходимо для обновления в провайдере
  }

  void setNoteTitle(Lesson lesson, String title) {
    if (lesson.note == null) return;
    lesson.note!.title = title;
    notifyListeners();
  }

  void setNoteContent(Lesson lesson, String content) {
    if (lesson.note == null) return;
    lesson.note!.content = content;
    notifyListeners();
  }

  void setNote(Lesson lesson, Note note) {
    lesson.note = note;
    _saveSystem.saveNotes(_lessons);
    notifyListeners();
  }

  void setPendingNote(PendingNote pendingNote, Note note) {
    pendingNote.note = note;
    notifyListeners();
  }

  void deleteNote(Lesson lesson) {
    lesson.note = null;
    notifyListeners();
  }

  void deletePending(PendingNote pendingNote) {
    pendingNote.note = null;
    pendingNote.state = PendingState.none;
    _pendingNotes.getList();
    notifyListeners();
  }

  int get notesCount {
    int n = 0;
    for (var lesson in _lessons) {
      if (lesson.note != null) ++n;
    }
    n += _pendingNotes.getList().length;
    return n;
  }

  void clear() {
    _lessons = [];
    _groupName = null;
    _subgroupsCount = 0;
    _scheduleStartDate = null;
    _scheduleEndDate = null;
    _selectedDay = null;
    _currentSubgroup = 0;
    notifyListeners();
  }

  void getPendingNotes(PendingNotes pn) {
    _pendingNotes = pn;
  }

  void getSaveSystem(SaveSystem system) {
    _saveSystem = system;
  }

  void updateSession(SessionManager session) {
    _session = session;
  }

  Future<Tuple2<OnlineStatus, List<Lesson>?>> getLessonsByGroup(
    String group,
  ) async {
    if (!_session.loggedIn) {
      return Tuple2(OnlineStatus.sessionErr, null);
    }
    final url = "https://time.ulstu.ru/api/1.0/timetable?filter=$group"
        .replaceAll(" ", "%20");
    Response? response = await FetchFinalResponse.fetchFinalResponse(
      url,
      _session.ams ?? "",
    );
    var status = FetchFinalResponse.getOnlineStatusByResponse(response);
    if (status == OnlineStatus.sessionErr) {
      await _session.updateAms();
    }
    response = await FetchFinalResponse.fetchFinalResponse(
      url,
      _session.ams ?? "",
    );
    status = FetchFinalResponse.getOnlineStatusByResponse(response);
    if (status != OnlineStatus.ok) {
      return Tuple2(status, null);
    }
    String raw = response!.body;
    _saveSystem.saveLessons(raw);
    final dumpLessons = decodeJSON(raw);
    final newLessons = converDumpToLessons(dumpLessons);
    newLessons.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return Tuple2(OnlineStatus.ok, newLessons);
  }

  static int getSubgroupCount(List<Lesson> list) {
    return list.map((e) => e.subgroup).reduce(max);
  }

  Future<Tuple2<OnlineStatus, List<String>?>> getAllGroups() async {
    if (!_session.loggedIn) {
      return Tuple2(OnlineStatus.sessionErr, null);
    }
    final url = "https://time.ulstu.ru/api/1.0/groups";
    Response? response = await FetchFinalResponse.fetchFinalResponse(
      url,
      _session.ams ?? "",
    );
    var status = FetchFinalResponse.getOnlineStatusByResponse(response);
    if (status == OnlineStatus.sessionErr) {
      await _session.updateAms();
    }
    response = await FetchFinalResponse.fetchFinalResponse(
      url,
      _session.ams ?? "",
    );
    status = FetchFinalResponse.getOnlineStatusByResponse(response);
    if (status != OnlineStatus.ok) {
      return Tuple2(status, null);
    }
    String raw = response!.body;
    debugPrint(response.body);
    dynamic decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return Tuple2(OnlineStatus.undefined, null);
    }
    List<dynamic> list = decoded["response"];
    List<String> result = list.map((e) => e.toString()).toList();
    return Tuple2(OnlineStatus.ok, result);
  }

  List<Lesson> get lessons => List.unmodifiable(_lessons);
  String? get groupName => _groupName;
  int get subgroupsCount => _subgroupsCount;
  DateTime? get scheduleStartDate => _scheduleStartDate;
  DateTime? get scheduleEndDate => _scheduleEndDate;
  int get currentSubgroup => _currentSubgroup;
  DateTime? get selectedDay => _selectedDay;

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  // Изменил сигнатуру: контекст теперь необязателен; метод сам сохранит подгруппу через _saveSystem
  void setSubgroup(int t, [BuildContext? context]) {
    _currentSubgroup = t.abs() > _subgroupsCount ? 0 : t;
    try {
      _saveSystem.saveSubGroup(_currentSubgroup);
    } catch (_) {
      // если _saveSystem не инициализирован — молча пропускаем
    }
    notifyListeners();
  }

  Future<bool> updateFromGroup() async {
    isLoading = true;
    if (!_session.loggedIn) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    if (_session.group == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    final temp = await getLessonsByGroup(_session.group!);
    if (temp.item1 != OnlineStatus.ok) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    if (temp.item2 == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    try {
      final newLessons = temp.item2!;
      if (newLessons.isEmpty) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      newLessons.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      final newStart = newLessons.first.dateTime;
      final newEnd = newLessons.last.dateTime;
      final newGroupName = newLessons.first.group;
      final newSubgroupCount = newLessons.map((e) => e.subgroup).reduce(max);
      _pendingNotes.syncFromLessons(lessons);
      _lessons = newLessons;
      attachPendingNotes();
      _groupName = newGroupName;
      _scheduleStartDate = newStart;
      _scheduleEndDate = newEnd;
      _subgroupsCount = newSubgroupCount;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool updateFromRaw(String rawJson) {
    try {
      final dumps = decodeJSON(rawJson);
      final newLessons = converDumpToLessons(dumps);
      if (newLessons.isEmpty) {
        notifyListeners();
        return false;
      }
      newLessons.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      final newStart = newLessons.first.dateTime;
      final newEnd = newLessons.last.dateTime;
      final newGroupName = newLessons.first.group;
      final newSubgroupCount = newLessons.map((e) => e.subgroup).reduce(max);
      _lessons = newLessons;
      _groupName = newGroupName;
      _scheduleStartDate = newStart;
      _scheduleEndDate = newEnd;
      _subgroupsCount = newSubgroupCount;

      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  List<Lesson> getLessonsForDay(DateTime date) {
    var dayLessons = _getLessonsByDate(date, _lessons);
    var filtered = _getLessonsBySubgroup(_currentSubgroup, dayLessons);
    filtered.sort((a, b) {
      final indexComparison = a.index.compareTo(b.index);
      if (indexComparison != 0) {
        return indexComparison;
      }
      return a.dateTime.compareTo(b.dateTime);
    });
    return filtered;
  }

  List<Lesson> getFilteredLessons(DateTime date, Filter filter) {
    var filtered = _getLessonsByDate(date, _lessons);
    filtered = _getLessonsBySubgroup(filter.subgroup, filtered);
    filtered.sort((a, b) => a.index.compareTo(b.index));
    return filtered;
  }

  bool _isEqualDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Lesson> _getLessonsByDate(DateTime date, List<Lesson> target) {
    return target.where((l) => _isEqualDay(l.dateTime, date)).toList();
  }

  List<Lesson> _getLessonsBySubgroup(int? s, List<Lesson> target) {
    if (s == null) return target;
    return target.where((l) {
      if (s == 0) return l.subgroup == 0;
      if (s < 0) return s.abs() == l.subgroup;
      if (s > 0) return s == l.subgroup || l.subgroup == 0;
      return true;
    }).toList();
  }

  List<DateTime> get days {
    if (_scheduleStartDate == null || _scheduleEndDate == null) {
      return [];
    }
    final start = _scheduleStartDate!.subtract(Duration(days: 14));
    final end = _scheduleEndDate!.add(Duration(days: 14));

    final count = end.difference(start).inDays;
    return List.generate(count + 1, (i) => start.add(Duration(days: i)));
  }

  int getInitialDayIndex({required DateTime today}) {
    final todayNormalized = DateTime(today.year, today.month, today.day);
    int index = days.indexWhere((day) {
      return day.year == todayNormalized.year &&
          day.month == todayNormalized.month &&
          day.day == todayNormalized.day;
    });
    return index != -1 ? index : 0;
  }
}
