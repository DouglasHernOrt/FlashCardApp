import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({Key? key}) : super(key: key);

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;

  List<Map<String, dynamic>> _quizQuestions = [];
  List<int> _questionOrder = [];
  List<List<String>> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _loadQuizQuestions();
  }

  Future<void> _loadQuizQuestions() async {
    _quizQuestions = await FlashcardDatabaseHelper.instance.getAllFlashcards();
    _questionOrder = _shuffleQuestionOrder(_quizQuestions.length);
    _shuffledOptions = _shuffleOptions();
    setState(() {
      _currentIndex = 0;
    });
  }

  List<int> _shuffleQuestionOrder(int totalQuestions) {
    List<int> questionOrder = List.generate(totalQuestions, (index) => index);
    questionOrder.shuffle();
    return questionOrder;
  }

  List<List<String>> _shuffleOptions() {
    List<List<String>> shuffledOptions = [];
    for (var index in _questionOrder) {
      List<String> options = _quizQuestions[index]['options'].split(',');
      options.shuffle();
      shuffledOptions.add(options);
    }
    return shuffledOptions;
  }

  void _checkAnswer(String selectedOption) {
    final correctOption =
        _quizQuestions[_questionOrder[_currentIndex]]['correctOption'];

    if (selectedOption == correctOption) {
      setState(() {
        _score++;
      });
    }

    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quizQuestions.length;
    });
    if (_currentIndex == 0 && _quizQuestions.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        '/congratulations',
        arguments: {'score': _score, 'totalQuestions': _quizQuestions.length},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take Quiz',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Container(
          color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
          padding: const EdgeInsets.all(20.0),
          child: _quizQuestions.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Question ${_currentIndex + 1}/${_quizQuestions.length}',
                      style: TextStyle(
                        fontSize: 24,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.red[400],
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Text(
                        _quizQuestions[_questionOrder[_currentIndex]]
                            ['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: <Widget>[
                        for (final option in _shuffledOptions[_currentIndex])
                          MouseRegion(
                            onHover: (event) {
                              setState(() {});
                            },
                            onExit: (event) {
                              setState(() {});
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                _checkAnswer(option);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              : const Text('No flash cards to take quiz'),
        ),
      ),
    );
  }
}
