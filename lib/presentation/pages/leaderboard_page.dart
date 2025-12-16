// ========================================
// leaderboard_page_bloc.dart
// Page du classement (version BLoC)
// ========================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LeaderboardPageBloc extends StatelessWidget {
  final String userName;
  final int userScore;
  final int totalQuestions;

  const LeaderboardPageBloc({
    Key? key,
    required this.userName,
    required this.userScore,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Données fictives du leaderboard
    final List<Map<String, dynamic>> leaderboard = [
      {'name': 'Fama Coundoul', 'score': 9, 'avatar': '👨‍💼'},
      {'name': 'John Deh', 'score': 8, 'avatar': '👨‍🎓'},
      {'name': 'Michael', 'score': 8, 'avatar': '👨‍💻'},
      {'name': 'Smith Carol', 'score': 6, 'avatar': '👩‍🔬'},
      {'name': 'Harry', 'score': 5, 'avatar': '👨‍🎨'},
      {'name': 'Jon', 'score': 4, 'avatar': '👨‍🚀'},
      {'name': 'Ken', 'score': 3, 'avatar': '👨‍🏫'},
      {'name': 'Petter', 'score': 2, 'avatar': '👨‍⚕️'},
    ];

    return Scaffold(
      backgroundColor: AppColors.darkTeal,
      appBar: AppBar(
        backgroundColor: AppColors.darkTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top 3
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTopPlayer(leaderboard[1], 2),
                _buildTopPlayer(leaderboard[0], 1),
                _buildTopPlayer(leaderboard[2], 3),
              ],
            ),
          ),

          // Liste des autres joueurs
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.lightBeige,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: leaderboard.length - 3,
                itemBuilder: (context, index) {
                  final player = leaderboard[index + 3];
                  return _buildLeaderboardItem(
                    index + 4,
                    player['name'],
                    player['avatar'],
                    player['score'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlayer(Map<String, dynamic> player, int position) {
    final isWinner = position == 1;
    return Column(
      children: [
        if (isWinner)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('👑', style: TextStyle(fontSize: 24)),
          ),
        Container(
          width: isWinner ? 80 : 65,
          height: isWinner ? 80 : 65,
          decoration: BoxDecoration(
            color: AppColors.accentYellow,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: Text(
              player['avatar'],
              style: TextStyle(fontSize: isWinner ? 36 : 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          player['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${player['score']}/10',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int position, String name, String avatar, int score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '$position',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            '$score/10',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}