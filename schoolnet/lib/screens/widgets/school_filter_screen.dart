import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolnet/services/auth_service.dart';

class SchoolFilterScreen extends StatefulWidget {
  const SchoolFilterScreen({Key? key}) : super(key: key);

  @override
  State<SchoolFilterScreen> createState() => _SchoolFilterScreenState();
}

class _SchoolFilterScreenState extends State<SchoolFilterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _locationController = TextEditingController();
  List<int> _pages = [];

  final Map<String, dynamic> filterAnswers = {
    'numChildren': ['One'],
    'sameSchool': ['No'],
    'schoolType': ['Private'],
    'gradeLevel': ['KG'],
    'tuitionFee': ['1000-3000'],
    'budgetMin': 1000,
    'budgetMax': 3000,
    'location': ['Bole'],
  };

  final List<String> _locations = [
    'Bole',
    'Akaki',
    'Lideta',
    'Addis Ketema',
    'Kirkos',
    'Arada',
    'Kolfe',
    'Gulele',
    'Yeka',
  ];

  List<Map<String, dynamic>> _questions = [];

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _setupQuestions();
  }

  Future<bool> _checkParentProfile() async {
    await _authService.ensureInitialized();
    final token = _authService.jwtToken;
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token',
        },
      );

      print(
          'Parent profile check response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('parent_profile', jsonEncode(data['data']));
          return true;
        }
      } else if (response.statusCode == 403) {
        Navigator.pushReplacementNamed(context, '/userstatus');
        return false;
      }
      return false;
    } catch (e) {
      print('Error checking parent profile: $e');
      return false;
    }
  }

  Future<void> _createParentProfile() async {
    final token = _authService.jwtToken;
    if (token == null) throw Exception('No authentication token found');

    final body = {
      'numberOfChildren': filterAnswers['numChildren']![0].toLowerCase(),
      'childrenDetails': {
        'gradeLevels':
            filterAnswers['gradeLevel']!.map((e) => e.toLowerCase()).toList(),
        'schoolType':
            filterAnswers['schoolType']!.map((e) => e.toLowerCase()).toList(),
        'sameSchool': filterAnswers['sameSchool']![0].toLowerCase() == 'yes'
            ? true
            : false,
      },
      'address': {
        'city': 'Addis Ababa',
        'subCity': filterAnswers['location']![0],
      },
      'budgetMin': filterAnswers['budgetMin'],
      'budgetMax': filterAnswers['budgetMax'],
    };

    try {
      print('Creating parent profile with data: $body');
      final response = await http.post(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token',
        },
        body: jsonEncode(body),
      );

      print('Create profile response: ${response.statusCode} ${response.body}');
      final json = jsonDecode(response.body);
      if (response.statusCode == 201) {
        print('Parent profile created successfully: ${json['data']}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('parent_profile', jsonEncode(json['data']));
      } else {
        throw Exception('Failed to create profile: ${json['message']}');
      }
    } catch (e) {
      print('Error creating parent profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create profile: $e. Tap to retry.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _createParentProfile(),
          ),
        ),
      );
      rethrow;
    }
  }

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

  void _updateQuestions() {
    final currentQuestionsLength = _questions.length;
    _questions.clear();
    _questions.add({
      'question': 'How many children do you have?',
      'options': ['One', 'Two', 'More than two'],
      'key': 'numChildren',
    });

    final numChildren = filterAnswers['numChildren']!.isNotEmpty
        ? filterAnswers['numChildren']![0]
        : null;

    if (numChildren == 'Two' || numChildren == 'More than two') {
      _questions.add({
        'question': 'Do you want the same school for your children?',
        'options': ['Yes', 'No'],
        'key': 'sameSchool',
      });

      final sameSchool = filterAnswers['sameSchool']!.isNotEmpty
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
          'question': 'What is your tuition fee budget (per year)?',
          'options': ['1000-3000', '4000-6000', '7000-15000', 'above 15000'],
          'key': 'tuitionFee',
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
        _questions.add({
          'question': 'What is your tuition fee budget (per year)?',
          'options': ['1000-3000', '4000-6000', '7000-15000', 'above 15000'],
          'key': 'tuitionFee',
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
        'question': 'What is your tuition fee budget (per year)?',
        'options': ['1000-3000', '4000-6000', '7000-15000', 'above 15000'],
        'key': 'tuitionFee',
      });
      _questions.add({
        'question': 'Select your Location',
        'type': 'search',
        'key': 'location',
      });
    }

    setState(() {
      _pages = List<int>.generate(_questions.length, (index) => index);
      if (_currentPage >= _questions.length)
        _currentPage = _questions.length - 1;
      if (_questions.length > currentQuestionsLength &&
          _currentPage < _questions.length - 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(_currentPage);
        });
      }
    });
  }

  bool _canMoveNext() {
    final currentKey = _questions[_currentPage]['key'];
    return filterAnswers[currentKey]!.isNotEmpty;
  }

  Future<void> _saveProfileAndNavigate() async {
    // First, check if current page has an answer
    final currentKey = _questions[_currentPage]['key'];
    if (filterAnswers[currentKey]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option to continue'),
          backgroundColor: Color(0xFF4A2C2A),
        ),
      );
      return;
    }

    // If not last page, go to next page
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final requiredKeys = [
      'numChildren',
      'schoolType',
      'gradeLevel',
      'tuitionFee',
      'location'
    ];
    final unansweredQuestions =
        requiredKeys.where((key) => filterAnswers[key]!.isEmpty).toList();

    if (unansweredQuestions.isNotEmpty) {
      final firstUnansweredIndex =
          _questions.indexWhere((q) => unansweredQuestions.contains(q['key']));

      if (firstUnansweredIndex != -1) {
        _pageController.animateToPage(
          firstUnansweredIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please answer: ${_questions[firstUnansweredIndex]['question']}'),
            backgroundColor: const Color(0xFF4A2C2A),
          ),
        );
      }
      return;
    }

    // All questions answered - proceed with profile creation
    _setBudgetRange(filterAnswers['tuitionFee']![0]);

    final token = _authService.jwtToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authentication token available. Please log in.'),
        ),
      );
      Navigator.pushNamed(context, '/register');
      return;
    }

    try {
      bool hasProfile = await _checkParentProfile();
      if (!hasProfile) {
        await _createParentProfile();
      }

      final response = await http.patch(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token',
        },
        body: jsonEncode({
          'numberOfChildren': filterAnswers['numChildren']![0].toLowerCase(),
          'childrenDetails': {
            'gradeLevels': filterAnswers['gradeLevel']!
                .map((e) => e.toLowerCase())
                .toList(),
            'schoolType': filterAnswers['schoolType']!
                .map((e) => e.toLowerCase())
                .toList(),
            'sameSchool': filterAnswers['sameSchool']![0].toLowerCase() == 'yes'
                ? true
                : false,
          },
          'address': {
            'city': 'Addis Ababa',
            'subCity': filterAnswers['location']![0],
          },
          'budgetMin': filterAnswers['budgetMin'],
          'budgetMax': filterAnswers['budgetMax'],
        }),
      );

      print('Update profile response: ${response.statusCode} ${response.body}');
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('parent_profile', jsonEncode(json['data']));
        await prefs.setBool('onboarding_completed', true);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update profile: ${json['message']}')),
        );
      }
    } catch (e) {
      print('Error updating parent profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
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

  void _skipToProfile() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _setBudgetRange(String tuitionFee) {
    switch (tuitionFee) {
      case '1000-3000':
        filterAnswers['budgetMin'] = 1000;
        filterAnswers['budgetMax'] = 3000;
        break;
      case '4000-6000':
        filterAnswers['budgetMin'] = 4000;
        filterAnswers['budgetMax'] = 6000;
        break;
      case '7000-15000':
        filterAnswers['budgetMin'] = 7000;
        filterAnswers['budgetMax'] = 15000;
        break;
      case 'above 15000':
        filterAnswers['budgetMin'] = 15001;
        filterAnswers['budgetMax'] = 999999;
        break;
      default:
        filterAnswers['budgetMin'] = 0;
        filterAnswers['budgetMax'] = 0;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _pageController.dispose();
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
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFB188E3)),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text.isEmpty)
                                              return _locations;
                                            return _locations.where(
                                                (location) => location
                                                    .toLowerCase()
                                                    .contains(textEditingValue
                                                        .text
                                                        .toLowerCase()));
                                          },
                                          onSelected: (String selection) {
                                            setState(() {
                                              _locationController.text =
                                                  selection;
                                              filterAnswers[question['key']] = [
                                                selection
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
                                              onEditingComplete:
                                                  onEditingComplete,
                                              decoration: InputDecoration(
                                                hintText: 'Search',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                prefixIcon: const Icon(
                                                    Icons.search,
                                                    color: Color(0xFFB188E3)),
                                                suffixIcon: const Icon(
                                                    Icons.location_pin,
                                                    color: Color(0xFFB188E3)),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 20),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  filterAnswers[
                                                          question['key']] =
                                                      value.isNotEmpty
                                                          ? [value]
                                                          : [];
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
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: (question['options'] as List<String>)
                                    .map((option) {
                                  final isSelected =
                                      filterAnswers[question['key']]!
                                          .contains(option);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (question['key'] ==
                                                'gradeLevel') {
                                              if (isSelected) {
                                                filterAnswers[question['key']]!
                                                    .remove(option);
                                              } else {
                                                filterAnswers[question['key']]!
                                                    .add(option);
                                              }
                                            } else {
                                              filterAnswers[question['key']] = [
                                                option
                                              ];
                                              if (question['key'] ==
                                                  'tuitionFee') {
                                                _setBudgetRange(option);
                                              }
                                            }
                                            _updateQuestions();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isSelected
                                              ? const Color(0xFFB188E3)
                                              : Colors.white,
                                          side: const BorderSide(
                                              color: Color(0xFFB188E3)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
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
              child: _currentPage > 0
                  ? IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFFB188E3), size: 30),
                    )
                  : const SizedBox.shrink(),
            ),
            Positioned(
              top: 28,
              right: 20,
              child: TextButton(
                onPressed: _skipToProfile,
                child: const Text('Skip',
                    style: TextStyle(fontSize: 20, color: Color(0xFFB188E3))),
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
                            color: _currentPage == index
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
                      Color.fromARGB(255, 74, 42, 69)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: _saveProfileAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Next',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
