import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_flashcards.dart';
import 'create_flashcards.dart';
import 'take_quiz.dart';
import 'congratulations.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlashcardDatabaseHelper dbHelper = FlashcardDatabaseHelper.instance;
  await dbHelper.database; // Ensure that the database is initialized

  // Check if there are any flashcards in the database
  final List<Map<String, dynamic>> flashcards =
      await dbHelper.getAllFlashcards();
  if (flashcards.isEmpty) {
    // If there are no flashcards, insert pre-made example flashcards
    await insertExampleFlashcards(dbHelper);
  }

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: const FlashCardApp(),
    ),
  );
}

// Function to insert pre-made example flashcards
Future<void> insertExampleFlashcards(FlashcardDatabaseHelper dbHelper) async {
  final List<Map<String, dynamic>> exampleFlashcards = [
    {
      'question': 'What is the capital of France?',
      'options': 'London,Berlin,Paris,Madrid',
      'correctOption': 'Paris',
    },
    {
      'question': 'Who wrote "To Kill a Mockingbird"?',
      'options': 'Mark Twain,Harper Lee,Stephen King,JK Rowling',
      'correctOption': 'Harper Lee',
    },
    {
      'question': 'What is the powerhouse of the cell?',
      'options': 'Mitochondria,Nucleus,Ribosome,Golgi Apparatus',
      'correctOption': 'Mitochondria',
    },
  ];

  for (final flashcard in exampleFlashcards) {
    await dbHelper.insertFlashcard(flashcard);
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Card App',
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(),
      home: const HomeScreen(),
      routes: {
        '/viewFlashCards': (context) => const ViewFlashCardsScreen(),
        '/createFlashCards': (context) => const CreateFlashCardsScreen(),
        '/takeQuiz': (context) => const TakeQuizScreen(),
        '/congratulations': (context) => const CongratulationsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Flash Card Quizzes',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/viewFlashCards');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'View Flash Cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createFlashCards');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Create Flash Cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/takeQuiz');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Take Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Change Theme',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
