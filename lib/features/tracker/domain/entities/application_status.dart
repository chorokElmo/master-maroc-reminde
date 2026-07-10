enum ApplicationStatus {
  interested,
  preparingDocuments,
  submitted,
  waitingForResults,
  accepted,
  rejected,
  archived,
}

extension ApplicationStatusX on ApplicationStatus {
  String get label => switch (this) {
        ApplicationStatus.interested => 'Interested',
        ApplicationStatus.preparingDocuments => 'Preparing Documents',
        ApplicationStatus.submitted => 'Submitted',
        ApplicationStatus.waitingForResults => 'Waiting for Results',
        ApplicationStatus.accepted => 'Accepted',
        ApplicationStatus.rejected => 'Rejected',
        ApplicationStatus.archived => 'Archived',
      };

  /// Position in the natural application funnel, used to render a progress
  /// bar. Accepted/Rejected/Archived are terminal states drawn at full bar.
  double get progress => switch (this) {
        ApplicationStatus.interested => 0.15,
        ApplicationStatus.preparingDocuments => 0.4,
        ApplicationStatus.submitted => 0.65,
        ApplicationStatus.waitingForResults => 0.85,
        ApplicationStatus.accepted => 1.0,
        ApplicationStatus.rejected => 1.0,
        ApplicationStatus.archived => 1.0,
      };
}
