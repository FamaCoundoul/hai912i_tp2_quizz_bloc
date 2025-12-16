// ========================================
// question_repository.dart
// Repository pour charger les questions depuis JSON
// ========================================

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionRepository {
  // Charger les questions depuis le fichier JSON
  Future<List<Question>> loadQuestions() async {
    try {
      final String jsonData = await rootBundle.loadString('assets/data/quizz_questions.json');
      final List<dynamic> list = json.decode(jsonData);
      return list.map((e) => Question.fromJson(e)).toList();
    } catch (e) {
      print('Erreur lors du chargement des questions: $e');
      return [];
    }
  }
}