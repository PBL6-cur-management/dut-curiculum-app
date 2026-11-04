int parseDateOnly(String iso) =>
    DateTime.parse('${iso}T00:00:00Z').millisecondsSinceEpoch;

int parseTimestamp(String iso) => DateTime.parse(iso).millisecondsSinceEpoch;
