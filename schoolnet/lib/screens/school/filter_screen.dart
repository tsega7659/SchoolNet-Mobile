import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final Map<String, List<String>> _selectedFilters = {
    'Price': [],
    'Grade Level': [],
    'School Type': [],
    'Location': [],
  };

  final Map<String, bool> _isExpanded = {
    'Price': false,
    'Grade Level': false,
    'School Type': false,
    'Location': false,
  };

  final Map<String, List<String>> _filterOptions = {
    'Price': ['1000-3000', '4000-6000', '7000-10000', '>10000'],
    'Grade Level': ['kg', 'primary', 'middle', 'high'],
    'School Type': ['public', 'private', 'international', 'faith'],
    'Location': [
      'Addis Ababa',
      'Bole',
      'Kirkos',
      'Lideta',
      'Arada',
      'Gulele',
      'Kolfe Keranio',
      'Akaky',
      'Yeka',
      'Addis Ketema',
      'Nifas Silk-Lafto Kemekem',
      'Arada',
    ],
  };

  final AuthService _authService = AuthService();

  Future<bool> _checkUserProfile() async {
    await _authService.ensureInitialized();
    final jwtToken = _authService.jwtToken;
    if (jwtToken == null) return false;

    try {
      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Cookie': 'jwt=$jwtToken',
        },
      );

      print('Profile check response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success' && data['data'] != null;
      } else if (response.statusCode == 401) {
        await _authService.logout();
        Navigator.pushNamed(context, '/login');
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking user profile: $e');
      return false;
    }
  }

  void _toggleOption(String category, String option) {
    setState(() {
      if (_selectedFilters[category]!.contains(option)) {
        _selectedFilters[category]!.remove(option);
      } else {
        _selectedFilters[category]!.add(option);
      }
    });
  }

  void _toggleExpanded(String category) {
    setState(() {
      _isExpanded[category] = !_isExpanded[category]!;
    });
  }

  void _applyAndCollapse(String category) {
    setState(() {
      _isExpanded[category] = false;
    });
  }

  Future<void> _applyFiltersAndNavigate(BuildContext context) async {
    await _authService.ensureInitialized();
    final jwtToken = _authService.jwtToken;
    if (jwtToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No authentication token available. Please log in.')),
      );
      Navigator.pushNamed(context, '/login');
      return;
    }

    final isProfileComplete = await _checkUserProfile();
    if (!isProfileComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your profile setup.')),
      );
      Navigator.pushNamed(context, '/school_filter');
      return;
    }

    try {
      // First fetch all schools
      final allSchoolsResponse = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/schools'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
          'Cookie': 'jwt=$jwtToken',
        },
      );

      if (allSchoolsResponse.statusCode == 200) {
        final allSchoolsData = jsonDecode(allSchoolsResponse.body);
        List<dynamic> schools = [];

        // Handle the response structure
        if (allSchoolsData['status'] == 'success' &&
            allSchoolsData['data'] != null) {
          if (allSchoolsData['data'] is List) {
            schools = allSchoolsData['data'];
          } else if (allSchoolsData['data'] is Map) {
            final data = allSchoolsData['data'];
            if (data['parentProfile'] != null &&
                data['parentProfile']['favoriteSchools'] != null) {
              schools = data['parentProfile']['favoriteSchools'];
            } else if (data['schools'] != null) {
              schools = data['schools'];
            } else {
              // If no schools array found, create a list with the single school
              schools = [data];
            }
          }
        }

        print('Found ${schools.length} schools before filtering');

        // Apply filters locally
        if (_selectedFilters['School Type']!.isNotEmpty) {
          schools = schools.where((school) {
            final schoolType =
                school['schoolType']?.toString().toLowerCase() ?? '';
            return _selectedFilters['School Type']!
                .any((type) => schoolType.toLowerCase() == type.toLowerCase());
          }).toList();
          print('After school type filter: ${schools.length} schools');
        }

        if (_selectedFilters['Location']!.isNotEmpty) {
          schools = schools.where((school) {
            final location =
                school['address']?[0]?['subCity']?.toString().toLowerCase() ??
                    '';
            return _selectedFilters['Location']!
                .any((loc) => location.toLowerCase() == loc.toLowerCase());
          }).toList();
          print('After location filter: ${schools.length} schools');
        }

        print('Found ${schools.length} schools after filtering');

        Navigator.pushNamed(
          context,
          '/results',
          arguments: {
            'filters': _selectedFilters,
            'schools': schools,
          },
        );
      } else if (allSchoolsResponse.statusCode == 401) {
        await _authService.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Session expired. Please log in again.')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to fetch schools: ${allSchoolsResponse.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching schools: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
                              children: _filterOptions[category]!.map((option) {
                                return GestureDetector(
                                  onTap: () => _toggleOption(category, option),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedFilters[category]!
                                              .contains(option)
                                          ? const Color(0xFFB188E3)
                                              .withOpacity(0.2)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: const Color(0xFFB188E3)
                                            .withOpacity(0.5),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFB188E3)
                                              .withOpacity(0.2),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                onPressed: () async {
                  await _applyFiltersAndNavigate(context);
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
