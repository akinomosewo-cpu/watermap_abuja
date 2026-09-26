enum NoticeStatus { scheduled, inProgress, resolved }

extension NoticeStatusX on NoticeStatus {
  String get label {
    switch (this) {
      case NoticeStatus.scheduled:
        return 'Scheduled';
      case NoticeStatus.inProgress:
        return 'In progress';
      case NoticeStatus.resolved:
        return 'Resolved';
    }
  }
}

/// A repair / maintenance notice published by the FCT Water Board.
class RepairNotice {
  final String id;
  final String districtId;
  final String title;
  final String description;
  final NoticeStatus status;
  final DateTime issuedAt;
  final DateTime? expectedResolution;

  const RepairNotice({
    required this.id,
    required this.districtId,
    required this.title,
    required this.description,
    required this.status,
    required this.issuedAt,
    this.expectedResolution,
  });
}
