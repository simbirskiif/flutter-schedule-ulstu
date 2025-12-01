class DayOfWeekTable {
  static const Map<int, String> map = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье',
  };

  static String get(int n) => map[n] ?? "Неизвестно";

  DayOfWeekTable._();
}
