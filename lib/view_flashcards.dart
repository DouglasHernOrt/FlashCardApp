import 'package:flutter/material.dart';
import 'database_helper.dart';

class ViewFlashCardsScreen extends StatefulWidget {
  const ViewFlashCardsScreen({Key? key});

  @override
  _ViewFlashCardsScreenState createState() => _ViewFlashCardsScreenState();
}

class _ViewFlashCardsScreenState extends State<ViewFlashCardsScreen> {
  late List<Map<String, dynamic>> _flashCards;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFlashCards();
  }

  void _loadFlashCards() async {
    final flashCards =
        await FlashcardDatabaseHelper.instance.getAllFlashcards();
    setState(() {
      _flashCards = List<Map<String, dynamic>>.from(flashCards);
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashCards.length;
    });
  }

  void _prevCard() {
    if (_currentIndex == 0) {
      setState(() {
        _currentIndex = _flashCards.length - 1;
      });
    } else {
      setState(() {
        _currentIndex = (_currentIndex - 1).clamp(0, _flashCards.length - 1);
      });
    }
  }

  void _deleteCurrentCard() async {
    final int id = _flashCards[_currentIndex]['_id'];
    await FlashcardDatabaseHelper.instance.deleteFlashcard(id);
    _flashCards.removeAt(_currentIndex);

    if (!mounted) return;

    if (_flashCards.isEmpty) {
      // If there are no more flashcards after deletion, navigate back to home screen
      Navigator.pop(context);
      return;
    }
    if (_currentIndex >= _flashCards.length) {
      _currentIndex = (_flashCards.length - 1).clamp(0, _flashCards.length - 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Flash Cards',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: _flashCards.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_currentIndex + 1}/${_flashCards.length}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  // Front of the flash card
                  Container(
                    width: 350,
                    height: 250,
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.blue[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Question:',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _flashCards[_currentIndex]['question'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  // Back of the flash card with answer choices
                  Container(
                    width: 350,
                    height: 250,
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.red[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final option
                            in _flashCards[_currentIndex]['options'].split(','))
                          ElevatedButton(
                            onPressed: () {},
                            style: option ==
                                    _flashCards[_currentIndex]['correctOption']
                                ? ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green)
                                : null,
                            child: Text(option),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _prevCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Prev'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _nextCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Next'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _deleteCurrentCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              )
            : const Text('No flash cards available'),
      ),
    );
  }
}
