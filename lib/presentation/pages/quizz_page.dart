// ========================================
// quiz_page_bloc.dart
// Page de quiz avec BLoC
// ========================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/quiz_bloc.dart';
import '../../business_logic/bloc/quiz_event.dart';
import '../../business_logic/bloc/quiz_state.dart';
import '../constants/app_colors.dart';
import 'leaderboard_page.dart';

class QuizPageBloc extends StatelessWidget {
  const QuizPageBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        // Écouter les changements d'état pour la navigation
        if (state is QuizCompleted) {
          // Quiz terminé, naviguer vers le leaderboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LeaderboardPageBloc(
                userName: state.userName,
                userScore: state.finalScore,
                totalQuestions: state.totalQuestions,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is QuizInitial) {
          return const Scaffold(
            body: Center(
              child: Text('Initialisation du quiz...'),
            ),
          );
        }

        if (state is QuizError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! QuizInProgress) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final question = state.currentQuestion;
        if (question == null) {
          return const Scaffold(
            body: Center(
              child: Text('Aucune question disponible'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.lightBeige,
          appBar: AppBar(
            backgroundColor: AppColors.lightBeige,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textDark),
                const SizedBox(width: 4),
                const Text(
                  'Previous',
                  style: TextStyle(color: AppColors.textDark, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${state.currentQuestionIndex + 1}/${state.totalQuestions}',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Timer circulaire
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: state.timeRemaining / 30,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mediumTeal),
                        ),
                      ),
                      Text(
                        '${state.timeRemaining}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Affichage du score (votre code préféré)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.mediumTeal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.accentYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Score: ${state.score}/${state.totalQuestions}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Icône de la question
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    question.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(Icons.image, size: 40, color: Colors.grey);
                    },
                  ),
                ),
              ),

              // Carte de question
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  question.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Options de réponse
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    final isSelected = state.selectedAnswer == option;
                    final isCorrect = option == question.correctAnswer;

                    Color backgroundColor = Colors.white;
                    if (state.selectedAnswer != null) {
                      if (isCorrect) {
                        backgroundColor = AppColors.correctGreen;
                      } else if (isSelected && !isCorrect) {
                        backgroundColor = Colors.red.shade300;
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          // Envoyer l'événement SelectAnswer au BLoC
                          context.read<QuizBloc>().add(SelectAnswerEvent(option));

                          // Attendre 1.5s puis passer à la question suivante
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            context.read<QuizBloc>().add(const NextQuestionEvent());
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.mediumTeal : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: state.selectedAnswer != null && (isCorrect || isSelected)
                                        ? Colors.white
                                        : AppColors.textDark,
                                  ),
                                ),
                              ),
                              if (state.selectedAnswer != null && isCorrect)
                                const Icon(Icons.check_circle, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bouton Next
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.selectedAnswer != null
                        ? () {
                      // Envoyer l'événement NextQuestion au BLoC
                      context.read<QuizBloc>().add(const NextQuestionEvent());
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkTeal,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}