import 'package:flutter/material.dart';
import 'database_helper.dart';

class CreateFlashCardsScreen extends StatefulWidget {
  const CreateFlashCardsScreen({Key? key}) : super(key: key);

  @override
  _CreateFlashCardsScreenState createState() => _CreateFlashCardsScreenState();
}

class _CreateFlashCardsScreenState extends State<CreateFlashCardsScreen> {
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController1 = TextEditingController();
  final TextEditingController _backController2 = TextEditingController();
  final TextEditingController _backController3 = TextEditingController();
  final TextEditingController _backController4 = TextEditingController();

  int _correctAnswerIndex = 0; // Initialize correct answer index to 0

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _saveFlashCard() async {
    if (_formKey.currentState!.validate()) {
      final List<String> options = [
        _backController1.text,
        _backController2.text,
        _backController3.text,
        _backController4.text
      ];

      final newFlashCard = {
        'question': _frontController.text,
        'options': options.join(','),
        'correctOption': options[_correctAnswerIndex],
      };

      // Insert new flashcard into the database
      await FlashcardDatabaseHelper.instance.insertFlashcard(newFlashCard);

      _frontController.clear();
      _backController1.clear();
      _backController2.clear();
      _backController3.clear();
      _backController4.clear();
      _correctAnswerIndex = 0; // Reset correct answer index

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flash Cards',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Front of the flash card input
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: _frontController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the front of the flash card';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter front of the flash card',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Back of the flash card input with four answer choices
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Back of the flash card (Answer choices)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < 4; i++)
                        Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: _correctAnswerIndex,
                              onChanged: (value) {
                                setState(() {
                                  _correctAnswerIndex = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: TextFormField(
                                  controller: i == 0
                                      ? _backController1
                                      : i == 1
                                          ? _backController2
                                          : i == 2
                                              ? _backController3
                                              : _backController4,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter answer choice ${String.fromCharCode(65 + i)}';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter answer choice ${String.fromCharCode(65 + i)}',
                                    border: const OutlineInputBorder(),
                                    fillColor: i == _correctAnswerIndex
                                        ? Colors.green
                                        : null,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveFlashCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Save Flash Card'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController1.dispose();
    _backController2.dispose();
    _backController3.dispose();
    _backController4.dispose();
    super.dispose();
  }
}
