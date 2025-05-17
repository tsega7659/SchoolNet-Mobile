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
      final response = await http.post(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/schools/filter'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filters),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          schools = data['schools'] ?? [];
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
