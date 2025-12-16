// ========================================
// question_model.dart
// Modèle de données pour les questions
// ========================================
class Question {
  final String id;
  final String questionText;
  final bool isCorrect;
  final String theme;
  final int difficulty;
  final String image;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.isCorrect,
    required this.theme,
    required this.difficulty,
    required this.image,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      isCorrect: json['isCorrect'],
      theme: json['theme'] ?? "",
      difficulty: json['difficulty'] ?? 1,
      image: json['image'] != null
          ? json['image']!.replaceFirst('./', 'assets/')
          : "assets/images/placeholder.png",
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : [],
      correctAnswer: json['correctAnswer'] ?? "",
    );
  }
}