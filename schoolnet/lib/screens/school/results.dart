import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic> schools = [];
  Map<String, List<String>> filters = {};
  int resultCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        filters = Map<String, List<String>>.from(args['filters'] ?? {});
        schools = args['schools'] ?? [];
        resultCount = schools.length;
      });
    }
  }

  Future<void> _refetchSchools() async {
    try {
      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/schools'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> allSchools = [];

        // Handle the response structure
        if (data['status'] == 'success' && data['data'] != null) {
          if (data['data'] is List) {
            allSchools = data['data'];
          } else if (data['data'] is Map) {
            final responseData = data['data'];
            if (responseData['parentProfile'] != null &&
                responseData['parentProfile']['favoriteSchools'] != null) {
              allSchools = responseData['parentProfile']['favoriteSchools'];
            } else if (responseData['schools'] != null) {
              allSchools = responseData['schools'];
            } else {
              // If no schools array found, create a list with the single school
              allSchools = [responseData];
            }
          }
        }

        print('Found ${allSchools.length} schools before filtering');

        // Apply filters locally
        if (filters['School Type']?.isNotEmpty ?? false) {
          allSchools = allSchools.where((school) {
            final schoolType =
                school['schoolType']?.toString().toLowerCase() ?? '';
            return filters['School Type']!
                .any((type) => schoolType.toLowerCase() == type.toLowerCase());
          }).toList();
          print('After school type filter: ${allSchools.length} schools');
        }

        if (filters['Location']?.isNotEmpty ?? false) {
          allSchools = allSchools.where((school) {
            final location =
                school['address']?[0]?['subCity']?.toString().toLowerCase() ??
                    '';
            return filters['Location']!
                .any((loc) => location.toLowerCase() == loc.toLowerCase());
          }).toList();
          print('After location filter: ${allSchools.length} schools');
        }

        // Optional price filter
        if (filters['Price']?.isNotEmpty ?? false) {
          final priceRange = filters['Price']!.first.split('-');
          final minPrice =
              int.tryParse(priceRange[0].replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          final maxPrice = priceRange.length > 1
              ? int.tryParse(priceRange[1].replaceAll(RegExp(r'[^\d]'), '')) ??
                  0
              : 100000;

          allSchools = allSchools.where((school) {
            final price = school['price'] ?? 0;
            return price >= minPrice && price <= maxPrice;
          }).toList();
          print('After price filter: ${allSchools.length} schools');
        }

        // Optional grade level filter
        if (filters['Grade Level']?.isNotEmpty ?? false) {
          allSchools = allSchools.where((school) {
            final gradeLevels =
                school['division']?.toString().toLowerCase() ?? '';
            return filters['Grade Level']!.any(
                (grade) => gradeLevels.toLowerCase() == grade.toLowerCase());
          }).toList();
          print('After grade level filter: ${allSchools.length} schools');
        }

        print('Found ${allSchools.length} schools after filtering');

        setState(() {
          schools = allSchools;
          resultCount = schools.length;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch schools: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _removeFilter(String category, String option) {
    setState(() {
      filters[category]?.remove(option);
      if (filters[category]?.isEmpty ?? false) {
        filters.remove(category);
      }
    });
    _refetchSchools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.pushNamed(context, '/filters').then((_) {
                _refetchSchools();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (filters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: filters.entries.expand((entry) {
                  return entry.value.map((option) {
                    return Chip(
                      label: Text(
                        option,
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: const Color(0xFFB188E3).withOpacity(0.2),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                      onDeleted: () => _removeFilter(entry.key, option),
                    );
                  }).toList();
                }).toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$resultCount+ Results',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schools.length,
              itemBuilder: (context, index) {
                final school = schools[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150', // Placeholder image
                      ),
                    ),
                    title: Text(
                      school['name'] ?? 'Unknown School',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(school['location'] ?? 'Unknown Location'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(school['type'] ?? 'Unknown Type'),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.people,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text('${school['studentCount'] ?? 0}'),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text('${school['rating'] ?? 0.0}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFB188E3),
                            side: const BorderSide(color: Color(0xFFB188E3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('FOLLOW'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB188E3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('ADD'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFFB188E3),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
