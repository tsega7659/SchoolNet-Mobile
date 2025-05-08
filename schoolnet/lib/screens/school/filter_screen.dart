import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Map to store the selected filter options for each category
  final Map<String, List<String>> _selectedFilters = {
    'Price': [],
    'Grade Level': [],
    'Review': [],
    'Language': [],
    'School Type': [],
    'Gender': [],
    'School Format': [],
    'Location': [],
  };

  // Map to track which category is expanded
  final Map<String, bool> _isExpanded = {
    'Price': false,
    'Grade Level': false,
    'Review': false,
    'Language': false,
    'School Type': false,
    'Gender': false,
    'School Format': false,
    'Location': false,
  };

  // Available options for each filter category
  final Map<String, List<String>> _filterOptions = {
    'Price': ['<5000 ETB', '5000-10000 ETB', '>10000 ETB'],
    'Grade Level': ['KG', 'Middle School', 'Primary', 'High School'],
    'Review': ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
    'Language': ['English', 'Amharic', 'French'],
    'School Type': ['Public', 'Private', 'International'],
    'Gender': ['Female', 'Male', 'Mixed'],
    'School Format': ['Day', 'Boarding', 'Both'],
    'Location': ['Bole', 'Addis Ababa', 'Other'],
  };

  // Function to toggle the selection of an option in a category
  void _toggleOption(String category, String option) {
    setState(() {
      if (_selectedFilters[category]!.contains(option)) {
        _selectedFilters[category]!.remove(option);
      } else {
        _selectedFilters[category]!.add(option);
      }
    });
  }

  // Function to toggle the expanded state of a category
  void _toggleExpanded(String category) {
    setState(() {
      _isExpanded[category] = !_isExpanded[category]!;
    });
  }

  // Function to collapse the dropdown after applying selections
  void _applyAndCollapse(String category) {
    setState(() {
      _isExpanded[category] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filterOptions.keys.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final category = _filterOptions.keys.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        category,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(
                        _isExpanded[category]!
                            ? Icons.expand_less
                            : Icons.chevron_right,
                        color: Colors.black,
                      ),
                      onTap: () => _toggleExpanded(category),
                    ),
                    if (_isExpanded[category]!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Column(
                              children:
                                  _filterOptions[category]!.map((option) {
                                    return GestureDetector(
                                      onTap:
                                          () => _toggleOption(category, option),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _selectedFilters[category]!
                                                      .contains(option)
                                                  ? const Color(
                                                    0xFFB188E3,
                                                  ).withOpacity(0.2)
                                                  : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFB188E3,
                                            ).withOpacity(0.5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFB188E3,
                                              ).withOpacity(0.2),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _applyAndCollapse(category),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  backgroundColor: const Color(0xFFB188E3),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final filtersToReturn = Map<String, List<String>>.from(
                    _selectedFilters,
                  )..removeWhere((key, value) => value.isEmpty);
                  Navigator.pushNamed(
                    context,
                    '/results',
                    arguments: filtersToReturn,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: const Color(0xFFB188E3),
                ),
                child: const Text(
                  'Show Results',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
