import 'package:flutter/material.dart';
import 'package:schoolnet/screens/filtered_schools_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

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
      'options': ['public', 'private'],
      'key': 'schoolType',
    },
    {'question': 'Select your Location', 'type': 'search', 'key': 'location'},
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
    return filterAnswers[questions[_currentPage]['key']]!.isNotEmpty;
  }

  void _nextPage() {
    if (!_canMoveNext()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one option to continue',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
          backgroundColor: const Color(0xFF4A2C2A),
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
          SnackBar(
            content: Text(
              'Please answer all questions to continue',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              ),
            ),
            backgroundColor: const Color(0xFF4A2C2A),
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
                  padding: EdgeInsets.only(
                    top: ResponsiveUtils.getResponsiveHeight(context, 16),
                  ),
                  child: Text(
                    '${_currentPage + 1} of ${questions.length}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      color: Colors.grey,
                    ),
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
                        padding: EdgeInsets.all(
                          ResponsiveUtils.getResponsivePadding(context, 24),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              question['question'],
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  24,
                                ),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFB188E3),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: ResponsiveUtils.getResponsiveHeight(
                                context,
                                48,
                              ),
                            ),
                            if (question['type'] == 'search')
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFB188E3),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.getResponsiveWidth(
                                          context,
                                          25,
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _locationController,
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize:
                                              ResponsiveUtils.getResponsiveFontSize(
                                                context,
                                                16,
                                              ),
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
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              ResponsiveUtils.getResponsiveHeight(
                                                context,
                                                15,
                                              ),
                                          horizontal:
                                              ResponsiveUtils.getResponsivePadding(
                                                context,
                                                20,
                                              ),
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
                                  SizedBox(
                                    height: ResponsiveUtils.getResponsiveHeight(
                                      context,
                                      48,
                                    ),
                                  ),
                                  // Placeholder for the illustration
                                  Container(
                                    height: ResponsiveUtils.getResponsiveHeight(
                                      context,
                                      300,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.getResponsiveWidth(
                                          context,
                                          20,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.location_on,
                                        size:
                                            ResponsiveUtils.getResponsiveWidth(
                                              context,
                                              50,
                                            ),
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else if (question['type'] == 'dropdown')
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.getResponsiveWidth(
                                        context,
                                        25,
                                      ),
                                    ),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB188E3),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        ResponsiveUtils.getResponsivePadding(
                                          context,
                                          20,
                                        ),
                                    vertical:
                                        ResponsiveUtils.getResponsiveHeight(
                                          context,
                                          15,
                                        ),
                                  ),
                                ),
                                items:
                                    question['options']
                                        .map<DropdownMenuItem<String>>(
                                          (
                                            String value,
                                          ) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveUtils.getResponsiveFontSize(
                                                      context,
                                                      16,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      filterAnswers[question['key']] = [
                                        newValue,
                                      ];
                                    }
                                  });
                                },
                              )
                            else
                              Wrap(
                                spacing: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  10,
                                ),
                                runSpacing: ResponsiveUtils.getResponsiveHeight(
                                  context,
                                  10,
                                ),
                                children:
                                    question['options'].map<Widget>((option) {
                                      final isSelected =
                                          filterAnswers[question['key']]!
                                              .contains(option);
                                      return FilterChip(
                                        label: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveUtils.getResponsiveFontSize(
                                                  context,
                                                  16,
                                                ),
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : const Color(0xFFB188E3),
                                          ),
                                        ),
                                        selected: isSelected,
                                        backgroundColor: Colors.white,
                                        selectedColor: const Color(0xFFB188E3),
                                        checkmarkColor: Colors.white,
                                        side: BorderSide(
                                          color: const Color(0xFFB188E3),
                                          width:
                                              ResponsiveUtils.getResponsiveWidth(
                                                context,
                                                1,
                                              ),
                                        ),
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (selected) {
                                              filterAnswers[question['key']]!
                                                  .add(option);
                                            } else {
                                              filterAnswers[question['key']]!
                                                  .remove(option);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: ResponsiveUtils.getResponsiveHeight(context, 20),
              left: ResponsiveUtils.getResponsivePadding(context, 24),
              right: ResponsiveUtils.getResponsivePadding(context, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                          color: const Color(0xFFB188E3),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 0),
                  if (_currentPage < questions.length - 1)
                    TextButton(
                      onPressed: _skipToHome,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                          color: const Color(0xFFB188E3),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 0),
                  Container(
                    height: ResponsiveUtils.getResponsiveHeight(context, 50),
                    width: ResponsiveUtils.getResponsiveWidth(context, 120),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A2C2A), Color(0xFFB188E3)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getResponsiveWidth(context, 25),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveWidth(context, 25),
                          ),
                        ),
                      ),
                      child: Text(
                        _currentPage == questions.length - 1
                            ? 'Finish'
                            : 'Next',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            18,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
