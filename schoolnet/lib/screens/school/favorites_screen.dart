import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _savedSchools = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchSavedSchools();
  }

  Future<void> _fetchSavedSchools() async {
    setState(() => _isLoading = true);
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found')),
      );
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
      );
      print('Favorites response status: ${response.statusCode}');
      print('Favorites response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final profile = data['data']['parentProfile'] ?? {};
          final savedSchools = profile['favoriteSchools'] as List? ?? [];
          print('Found ${savedSchools.length} favorite schools');

          setState(() {
            _savedSchools =
                savedSchools.map((e) => e as Map<String, dynamic>).toList();
          });
        } else {
          print('No profile data found in response');
          setState(() {
            _savedSchools = [];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to fetch favorites: ${response.statusCode}')),
        );
        print('Failed to fetch favorites. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching favorites: $e')),
      );
      print('Error fetching favorites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchools = _savedSchools.where((school) {
      final name = (school['name'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Favorites', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        Navigator.pushNamed(context, '/filters');
                      }, // Add filter logic if needed
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Last Added',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSchools.isEmpty
                      ? const Center(child: Text('No favorites found'))
                      : ListView.builder(
                          itemCount: filteredSchools.length,
                          itemBuilder: (context, index) {
                            final school = filteredSchools[index];
                            final address = school['address'] is List &&
                                    (school['address'] as List).isNotEmpty
                                ? (school['address'][0] as Map<String, dynamic>)
                                : {'city': 'Unknown', 'subCity': 'Unknown'};
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/school1.jpg',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Center(child: Text('?')),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  school['name'] ?? 'Unknown School',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                            '${address['subCity'] ?? 'Unknown'}, ${address['city'] ?? 'Unknown'}'),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        _buildTag(
                                            school['schoolType'] ?? 'Unknown'),
                                        const SizedBox(width: 8),
                                        _buildTag(
                                            '${school['studentCount'] ?? '0'}'),
                                        const SizedBox(width: 8),
                                        _buildTag('4.9 ★'),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {}, // Add follow/unfollow logic
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5A3B82),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Follow'),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
