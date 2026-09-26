enum OutageStatus { supplied, intermittent, outage }

extension OutageStatusX on OutageStatus {
  String get label {
    switch (this) {
      case OutageStatus.supplied:
        return 'Water flowing';
      case OutageStatus.intermittent:
        return 'Intermittent';
      case OutageStatus.outage:
        return 'No water';
    }
  }
}

class District {
  final String id;
  final String name;
  final String area;
  final OutageStatus status;
  final DateTime lastUpdated;
  final int daysWithoutWater;

  const District({
    required this.id,
    required this.name,
    required this.area,
    required this.status,
    required this.lastUpdated,
    this.daysWithoutWater = 0,
  });

  District copyWith({
    OutageStatus? status,
    DateTime? lastUpdated,
    int? daysWithoutWater,
  }) {
    return District(
      id: id,
      name: name,
      area: area,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      daysWithoutWater: daysWithoutWater ?? this.daysWithoutWater,
    );
  }
}
