import 'package:flutter/material.dart';
import 'filtered_schools_screen.dart';

class SchoolFilterScreen extends StatefulWidget {
  const SchoolFilterScreen({Key? key}) : super(key: key);

  @override
  State<SchoolFilterScreen> createState() => _SchoolFilterScreenState();
}

class _SchoolFilterScreenState extends State<SchoolFilterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Store filter answers
  final Map<String, dynamic> filterAnswers = {
    'grade': null,
    'curriculum': null,
    'schoolType': null,
    'location': null,
    'language': null,
    'facilities': null,
    'importance': null,
    'schedule': null,
    'priceRange': null,
  };

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What grade level are you looking for?',
      'options': ['KG', 'Middle School', 'Primary', 'High School'],
      'key': 'grade',
    },
    {
      'question': 'What curriculum do you prefer?',
      'options': ['Ethiopian National', 'Cambridge', 'IB', 'Montessori'],
      'key': 'curriculum',
    },
    {
      'question': 'Preferred school type',
      'options': ['Private', 'Public', 'Middle School', 'High School'],
      'key': 'schoolType',
    },
    {
      'question': 'Preferred location or neighborhood',
      'type': 'dropdown',
      'options': ['Bole', 'Gerji', 'CMC', 'Sarbet', 'Ayat', 'Megenagna'],
      'key': 'location',
    },
    {
      'question': 'Price Range (ETB)',
      'type': 'dropdown',
      'options': [
        '1,000 - 3,000',
        '4,000 - 8,000',
        '10,000 - 15,000',
        '15,000+',
      ],
      'key': 'priceRange',
    },
    {
      'question': 'Preferred language(s) of instruction',
      'options': ['Amharic', 'French', 'English', 'Mixed'],
      'key': 'language',
    },
    {
      'question': 'Desired programs or facilities',
      'options': ['STEM', 'Art', 'Sports', 'Special Education'],
      'key': 'facilities',
    },
    {
      'question': 'School timing preference',
      'options': ['Day School', 'Night School', 'Boarding School', 'Other'],
      'key': 'schedule',
    },
  ];

  bool _canMoveNext() {
    return filterAnswers[questions[_currentPage]['key']] != null;
  }

  void _nextPage() {
    if (!_canMoveNext()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option to continue'),
          backgroundColor: Color(0xFF4A2C2A),
        ),
      );
      return;
    }

    if (_currentPage < questions.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Check if all questions are answered
      final unansweredQuestions =
          questions
              .where((q) => filterAnswers[q['key']] == null)
              .map((q) => q['question'])
              .toList();

      if (unansweredQuestions.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions to continue'),
            backgroundColor: Color(0xFF4A2C2A),
          ),
        );
        return;
      }

      // Navigate to results screen with filter answers
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => FilteredSchoolsScreen(filterAnswers: filterAnswers),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A2C2A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Text(
            'Please Answer\nThe Following\nquestion',
            style: TextStyle(
              fontSize: 34,
              fontFamily: "DMSans",
              fontWeight: FontWeight.bold,
              color: const Color(0xFF290851),
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: () {
                  // Calculate the range of numbers to display (e.g., 1-3, 4-6, etc.)
                  int groupIndex = _currentPage ~/ 3;
                  int startNumber = groupIndex * 3 + 1;
                  int endNumber = (startNumber + 2).clamp(1, questions.length);

                  // Generate the list of indicators for the current range
                  List<Widget> indicators = [];
                  for (int i = startNumber - 1; i < endNumber; i++) {
                    indicators.add(
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  i <= _currentPage
                                      ? const Color(0xFFB188E3)
                                      : Colors.transparent,
                              border: Border.all(
                                color:
                                    i <= _currentPage
                                        ? const Color(0xFFB188E3)
                                        : const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color:
                                      i <= _currentPage
                                          ? Colors.white
                                          : const Color(0xFFE0E0E0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (i < endNumber - 1)
                            Container(
                              width: 80,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                    i < _currentPage
                                        ? const Color(0xFFB188E3)
                                        : const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return indicators;
                }(),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          question['question'],
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF170F49).withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (question['type'] == 'dropdown')
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFB188E3),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: filterAnswers[question['key']],
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                'Select ${question['question']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              items:
                                  (question['options'] as List<String>).map((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  filterAnswers[question['key']] = newValue;
                                });
                              },
                            ),
                          )
                        else
                          Center(
                            child: Column(
                              children:
                                  (question['options'] as List<String>)
                                      .map(
                                        (option) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                filterAnswers[question['key']] =
                                                    option;
                                              });
                                            },
                                            child: SizedBox(
                                              width: 300,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFB188E3,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color:
                                                      filterAnswers[question['key']] ==
                                                              option
                                                          ? const Color(
                                                            0xFFB188E3,
                                                          )
                                                          : Colors.white,
                                                ),
                                                child: Center(
                                                  // Centers the text inside the button
                                                  child: Text(
                                                    option,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          filterAnswers[question['key']] ==
                                                                  option
                                                              ? Colors.white
                                                              : const Color(
                                                                0xFF4A2C2A,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  IconButton(
                    onPressed: _previousPage,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4A2C2A),
                      size: 44,
                    ),
                  )
                else
                  const SizedBox(width: 48),
                IconButton(
                  onPressed: _nextPage,
                  icon: Icon(
                    _currentPage == questions.length - 1
                        ? Icons.check_circle
                        : Icons.arrow_forward,
                    color:
                        _canMoveNext()
                            ? const Color.fromARGB(255, 107, 16, 219)
                            : Colors.grey,
                    size: 44,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
