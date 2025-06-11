class Question {
  final int questionId;
  final int? courseId;
  final String title;
  final String text;
  final List<dynamic> options;
  final int correctIndex;
  final int? userAnswerIndex;

  Question({
    required this.questionId,
    required this.title,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.courseId,
    this.userAnswerIndex
  });
}