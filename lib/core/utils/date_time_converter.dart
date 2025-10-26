class DateTimeConverter {
  const DateTimeConverter();

  DateTime fromJson(String json) => DateTime.parse(json);

  String toJson(DateTime date) => date.toIso8601String();
}
