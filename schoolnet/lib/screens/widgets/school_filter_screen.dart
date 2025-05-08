import 'package:flutter/material.dart';
import 'package:schoolnet/screens/school/home_screen.dart';

class SchoolFilterScreen extends StatefulWidget {
  const SchoolFilterScreen({Key? key}) : super(key: key);

  @override
  State<SchoolFilterScreen> createState() => _SchoolFilterScreenState();
}

class _SchoolFilterScreenState extends State<SchoolFilterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _locationController = TextEditingController();
  List<int> _pages = []; // Removed 'late' and initialized as empty list

  // Store filter answers
  final Map<String, List<String>> filterAnswers = {
    'numChildren': [],
    'sameSchool': [],
    'schoolType': [],
    'gradeLevel': [],
    'location': [],
  };

  // Autofill locations
  final List<String> _locations = [
    'Bole',
    'Akaki',
    'Lideta',
    'Addis Ketema',
    'Kirkos',
  ];

  // Dynamic questions based on user input
  List<Map<String, dynamic>> _questions = [];

  // Initial questions setup
  void _setupQuestions() {
    _questions = [
      {
        'question': 'How many children do you have?',
        'options': ['One', 'Two', 'More than two'],
        'key': 'numChildren',
      },
    ];
    _pages = List<int>.generate(_questions.length, (index) => index);
  }

  // Update questions based on user input
  void _updateQuestions() {
    final currentQuestionsLength = _questions.length;
    _questions.clear();
    _questions.add({
      'question': 'How many children do you have?',
      'options': ['One', 'Two', 'More than two'],
      'key': 'numChildren',
    });

    final numChildren =
        filterAnswers['numChildren']?.isNotEmpty == true
            ? filterAnswers['numChildren']![0]
            : null;

    if (numChildren == 'Two' || numChildren == 'More than two') {
      _questions.add({
        'question': 'Do you want the same school for your children?',
        'options': ['Yes', 'No'],
        'key': 'sameSchool',
      });

      final sameSchool =
          filterAnswers['sameSchool']?.isNotEmpty == true
              ? filterAnswers['sameSchool']![0]
              : null;

      if (sameSchool == 'Yes') {
        _questions.add({
          'question': 'What type of school do you want?',
          'options': ['Private', 'Public', 'Faith-based', 'International'],
          'key': 'schoolType',
        });
        _questions.add({
          'question': 'What grade level are they?',
          'options': ['KG', 'Primary', 'Middle School', 'High School'],
          'key': 'gradeLevel',
        });
        _questions.add({
          'question': 'Select your Location',
          'type': 'search',
          'key': 'location',
        });
      } else if (sameSchool == 'No') {
        _questions.add({
          'question': 'What type of school do you want?',
          'options': ['Private', 'Public', 'Faith-based', 'International'],
          'key': 'schoolType',
        });
        _questions.add({
          'question': 'What grade level are they?',
          'options': ['KG', 'Primary', 'Middle School', 'High School'],
          'key': 'gradeLevel',
        });
      }
    } else if (numChildren == 'One') {
      _questions.add({
        'question': 'What type of school do you want?',
        'options': ['Private', 'Public', 'Faith-based', 'International'],
        'key': 'schoolType',
      });
      _questions.add({
        'question': 'What grade level are they?',
        'options': ['KG', 'Primary', 'Middle School', 'High School'],
        'key': 'gradeLevel',
      });
      _questions.add({
        'question': 'Select your Location',
        'type': 'search',
        'key': 'location',
      });
    }

    // Update _pages based on new questions length
    setState(() {
      _pages = List<int>.generate(_questions.length, (index) => index);
      // Adjust current page if necessary
      if (_currentPage >= _questions.length) {
        _currentPage = _questions.length - 1;
      }
      // If the number of questions increased, jump to the new question
      if (_questions.length > currentQuestionsLength &&
          _currentPage < _questions.length - 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(_currentPage);
        });
      }
    });
  }

  bool _canMoveNext() {
    return filterAnswers[_questions[_currentPage]['key']]!.isNotEmpty;
  }

  void _nextPage() {
    if (!_canMoveNext()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option to continue'),
          backgroundColor: Color(0xFF4A2C2A),
        ),
      );
      return;
    }

    if (_currentPage < _questions.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Check if all questions are answered
      final unansweredQuestions =
          _questions.where((q) => filterAnswers[q['key']]!.isEmpty).toList();

      if (unansweredQuestions.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions to continue'),
            backgroundColor: Color(0xFF4A2C2A),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(filterAnswers: filterAnswers),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(filterAnswers: filterAnswers),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setupQuestions();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '${_currentPage + 1} of ${_questions.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                        _updateQuestions();
                      });
                    },
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              question['question'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB188E3),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            if (question['type'] == 'search')
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFB188E3),
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Autocomplete<String>(
                                      optionsBuilder: (
                                        TextEditingValue textEditingValue,
                                      ) {
                                        if (textEditingValue.text.isEmpty) {
                                          return _locations;
                                        }
                                        return _locations.where(
                                          (location) =>
                                              location.toLowerCase().contains(
                                                textEditingValue.text
                                                    .toLowerCase(),
                                              ),
                                        );
                                      },
                                      onSelected: (String selection) {
                                        setState(() {
                                          _locationController.text = selection;
                                          filterAnswers[question['key']] = [
                                            selection,
                                          ];
                                        });
                                      },
                                      fieldViewBuilder: (
                                        context,
                                        controller,
                                        focusNode,
                                        onEditingComplete,
                                      ) {
                                        _locationController.text =
                                            controller.text;
                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          decoration: InputDecoration(
                                            hintText: 'Search',
                                            hintStyle: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.search,
                                              color: Color(0xFFB188E3),
                                            ),
                                            suffixIcon: const Icon(
                                              Icons.location_pin,
                                              color: Color(0xFFB188E3),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 20,
                                                ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value.isNotEmpty) {
                                                filterAnswers[question['key']] =
                                                    [value];
                                              } else {
                                                filterAnswers[question['key']] =
                                                    [];
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  Container(
                                    height: 300,
                                    width: 300,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/select_location_image.png',
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children:
                                    (question['options'] as List<String>)
                                        .map(
                                          (option) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (question['key'] ==
                                                        'gradeLevel') {
                                                      // Multi-select for grade levels
                                                      if (filterAnswers[question['key']]!
                                                          .contains(option)) {
                                                        filterAnswers[question['key']]!
                                                            .remove(option);
                                                      } else {
                                                        filterAnswers[question['key']]!
                                                            .add(option);
                                                      }
                                                    } else {
                                                      // Single select for other questions
                                                      filterAnswers[question['key']] =
                                                          [option];
                                                    }
                                                    _updateQuestions();
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      filterAnswers[question['key']]!
                                                              .contains(option)
                                                          ? const Color(
                                                            0xFFB188E3,
                                                          )
                                                          : Colors.white,
                                                  side: const BorderSide(
                                                    color: Color(0xFFB188E3),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                ),
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color:
                                                        filterAnswers[question['key']]!
                                                                .contains(
                                                                  option,
                                                                )
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 28,
              left: 20,
              child:
                  _currentPage > 0
                      ? IconButton(
                        onPressed: _previousPage,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFB188E3),
                          size: 30,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
            Positioned(
              top: 28,
              right: 20,
              child: TextButton(
                onPressed: _skipToHome,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 20, color: Color(0xFFB188E3)),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? const Color(0xFFB188E3)
                                    : const Color(0xFF4A2C2A).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB188E3),
                      Color.fromARGB(255, 74, 42, 69),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
