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
  final TextEditingController _locationController = TextEditingController();
  late final List<int> _pages;

  // Store filter answers as lists to allow multiple selections
  final Map<String, List<String>> filterAnswers = {
    'grade': [],
    'curriculum': [],
    'schoolType': [],
    'location': [],
    'language': [],
    'facilities': [],
    'importance': [],
    'schedule': [],
    'priceRange': [],
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
      'question': 'Which type of School',
      'options': ['public', 'private','Faith-based','International'],
      'key': 'schoolType',
    },
    {'question': 'Select your Location', 'type': 'search', 'key': 'location'},
    {
      'question': 'Price Range (ETB)',
      'type': 'dropdown',
      'options': [
        'Under 1,000',
        '1,000 - 5,000',
        '5,000 - 10,000',
        '10,000 - 15,000',
        'above 15,000',
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
    {
      'question': 'How important are school ratings and parent reviews to you?',
      'options': ['Very Important', 'Important', 'Not Important', 'Neutral'],
      'key': 'importance',
    },
  ];

  bool _canMoveNext() {
    return filterAnswers[questions[_currentPage]['key']]!.isNotEmpty;
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
              .where((q) => filterAnswers[q['key']]!.isEmpty)
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

  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => FilteredSchoolsScreen(filterAnswers: filterAnswers),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = List<int>.generate(questions.length, (index) => index);
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
                    '${_currentPage + 1} of ${questions.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
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
                                    child: TextField(
                                      controller: _locationController,
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
                                            filterAnswers[question['key']] = [
                                              value,
                                            ];
                                          } else {
                                            filterAnswers[question['key']] = [];
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  // Placeholder for the illustration
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
                            else if (question['type'] == 'dropdown')
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFB188E3),
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      filterAnswers[question['key']]!.isEmpty
                                          ? null
                                          : filterAnswers[question['key']]![0],
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: Text(
                                    'Select ${question['question']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  items:
                                      (question['options'] as List<String>).map(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        filterAnswers[question['key']] = [
                                          newValue,
                                        ];
                                      }
                                    });
                                  },
                                ),
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
                                                    // Toggle selection
                                                    if (filterAnswers[question['key']]!
                                                        .contains(option)) {
                                                      filterAnswers[question['key']]!
                                                          .remove(option);
                                                    } else {
                                                      filterAnswers[question['key']]!
                                                          .add(option);
                                                    }
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
