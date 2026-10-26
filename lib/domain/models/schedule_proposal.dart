/// What the user is asking the schedule assistant to do.
enum ScheduleIntent {
  setReminderTimes,
  moveReminderTime,
  pause,
  resume,
  updateStock,

  /// A question about the person's own medicines, schedule or stock. Nothing
  /// changes; [ScheduleProposal.answer] holds the reply.
  answer,

  /// The request is too vague to act on; [ScheduleProposal.clarification]
  /// holds the question to ask.
  clarify,

  /// Something Medzee's assistant does not do (e.g. change a dose).
  unsupported;

  static ScheduleIntent? fromName(String? name) {
    for (final ScheduleIntent i in ScheduleIntent.values) {
      if (i.name == name) return i;
    }
    return null;
  }
}

/// How a stock number should be recorded.
enum StockMode {
  /// "I counted and I have N left": fixes the number.
  correction,

  /// "I picked up N more": adds to the stock.
  refill;

  static StockMode? fromName(String? name) {
    for (final StockMode m in StockMode.values) {
      if (m.name == name) return m;
    }
    return null;
  }
}

/// A *suggested* change. It becomes real only after validation and the user's
/// explicit confirmation.
class ScheduleProposal {
  const ScheduleProposal({
    required this.id,
    required this.intent,
    this.medicationId,
    this.times = const <int>[],
    this.moveFrom,
    this.moveTo,
    this.startDate,
    this.endDate,
    this.durationDays,
    this.resumeOn,
    this.stockQuantity,
    this.stockMode,
    this.clarification,
    this.answer,
    this.summary,
  });

  /// Also the idempotency key: a proposal can be applied at most once.
  final String id;
  final ScheduleIntent intent;
  final String? medicationId;

  /// Reminder times in minutes after midnight.
  final List<int> times;
  final int? moveFrom;
  final int? moveTo;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? durationDays;

  /// For [ScheduleIntent.pause]: the day reminders should come back.
  final DateTime? resumeOn;
  final double? stockQuantity;
  final StockMode? stockMode;

  /// A question for the user when something is missing.
  final String? clarification;

  /// The reply to a question ([ScheduleIntent.answer]).
  final String? answer;

  /// The model's one-line description, shown only as a hint.
  final String? summary;

  ScheduleProposal copyWith({
    List<int>? times,
    int? moveFrom,
    int? moveTo,
    StockMode? stockMode,
    double? stockQuantity,
    DateTime? startDate,
    DateTime? endDate,
    int? durationDays,
  }) {
    return ScheduleProposal(
      id: id,
      intent: intent,
      medicationId: medicationId,
      times: times ?? this.times,
      moveFrom: moveFrom ?? this.moveFrom,
      moveTo: moveTo ?? this.moveTo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationDays: durationDays ?? this.durationDays,
      resumeOn: resumeOn,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockMode: stockMode ?? this.stockMode,
      clarification: clarification,
      answer: answer,
      summary: summary,
    );
  }
}
