// ========================================
// main.dart
// Point d'entrée de l'application avec BLoC
// ========================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/bloc/quiz_bloc.dart';
import 'data/models/question_model.dart';
import 'data/repositories/question_repository.dart';
import 'presentation/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les questions depuis le repository
  final questionRepository = QuestionRepository();
  final List<Question> questions = await questionRepository.loadQuestions();

  runApp(MyApp(questions: questions));
}

class MyApp extends StatelessWidget {
  final List<Question> questions;

  const MyApp({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Créer une instance du QuizBloc disponible dans toute l'application
      create: (context) => QuizBloc(),
      child: MaterialApp(
        title: 'Quiz App with BLoC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: WelcomePageBloc(questions: questions),
      ),
    );
  }
}