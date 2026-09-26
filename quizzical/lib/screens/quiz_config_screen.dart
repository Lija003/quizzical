import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/quiz_config.dart';
import '../providers/quiz_provider.dart';
import '../services/preferences_service.dart';
import '../utils/app_theme.dart';
import '../utils/category_icons.dart';
import 'quiz_play_screen.dart';

class QuizConfigScreen extends StatefulWidget {
  final TriviaCategory category;

  const QuizConfigScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  int _amount = 10;
  String _difficulty = 'any';
  String _type = 'any';
  int _timerSeconds = 20;
  bool _isLoadingSavedConfig = true;

  final List<Map<String, String>> _difficultyOptions = [
    {'value': 'any', 'label': 'Any Difficulty'},
    {'value': 'easy', 'label': 'Easy'},
    {'value': 'medium', 'label': 'Medium'},
    {'value': 'hard', 'label': 'Hard'},
  ];

  final List<Map<String, String>> _typeOptions = [
    {'value': 'any', 'label': 'Any Type (Multiple & True/False)'},
    {'value': 'multiple', 'label': 'Multiple Choice (4 options)'},
    {'value': 'boolean', 'label': 'True / False (2 options)'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedConfig();
  }

  Future<void> _loadSavedConfig() async {
    final saved = await PreferencesService.loadConfig();
    if (mounted) {
      setState(() {
        _amount = (saved['amount'] as int?)?.clamp(1, 50) ?? 10;
        final savedDiff = saved['difficulty'] as String? ?? 'any';
        if (_difficultyOptions.any((o) => o['value'] == savedDiff)) {
          _difficulty = savedDiff;
        }
        final savedType = saved['type'] as String? ?? 'any';
        if (_typeOptions.any((o) => o['value'] == savedType)) {
          _type = savedType;
        }
        _isLoadingSavedConfig = false;
      });
    }
  }

  void _onStartQuiz() {
    final config = QuizConfig(
      category: widget.category,
      amount: _amount,
      difficulty: _difficulty,
      type: _type,
      timerDurationSeconds: _timerSeconds,
    );

    final quizProvider = context.read<QuizProvider>();
    quizProvider.startQuiz(config);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizPlayScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyles.getStyle(widget.category.id, widget.category.name);

    if (_isLoadingSavedConfig) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Configuration'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selected Category Header Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: style.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: style.iconColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 26,
                          child: Icon(style.icon, color: style.iconColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected Category',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.category.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Setting 1: Number of Questions (Slider)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.format_list_numbered, size: 20, color: AppTheme.primary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Number of Questions',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$_amount questions',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.primary,
                              thumbColor: AppTheme.primary,
                              inactiveTrackColor: const Color(0xFFE2E8F0),
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: _amount.toDouble(),
                              min: 1,
                              max: 50,
                              divisions: 49,
                              label: '$_amount',
                              onChanged: (val) {
                                setState(() {
                                  _amount = val.round();
                                });
                              },
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                              Text('10 (Default)', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                              Text('50', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Setting 2: Difficulty Dropdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.speed, size: 20, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text(
                                'Difficulty',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: _difficulty,
                            decoration: const InputDecoration(),
                            items: _difficultyOptions.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(item['label']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _difficulty = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Setting 3: Question Type Dropdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_box_outlined, size: 20, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text(
                                'Question Type',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: _type,
                            decoration: const InputDecoration(),
                            items: _typeOptions.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(item['label']!),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _type = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Setting 4: Timer per Question
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 20, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text(
                                'Timer per Question',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<int>(
                            value: _timerSeconds,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 15, child: Text('15 seconds')),
                              DropdownMenuItem(value: 20, child: Text('20 seconds')),
                              DropdownMenuItem(value: 30, child: Text('30 seconds')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _timerSeconds = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Start Quiz Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onStartQuiz,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Start Quiz',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
