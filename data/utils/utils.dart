enum DurationK { one, three, twelve }

Map<String, DurationK> durationKToString = {
  '1 mois': DurationK.one,
  '3 mois': DurationK.three,
  '12 mois': DurationK.twelve,
};

DateTime accordingToDurationK({required DurationK durationK}) {
  if (durationK == DurationK.one) {
    return DateTime.now().add(const Duration(days: 31));
  } else if (durationK == DurationK.three) {
    return DateTime.now().add(const Duration(days: 62));
  } else {
    return DateTime.now().add(const Duration(days: 365));
  }
}
