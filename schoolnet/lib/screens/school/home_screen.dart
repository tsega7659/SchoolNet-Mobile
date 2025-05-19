import 'package:flutter/material.dart';
import 'package:schoolnet/screens/widgets/bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, List<String>> filterAnswers;

  const HomeScreen({Key? key, required this.filterAnswers}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  List<Map<String, dynamic>> _schools = [];
  List<Map<String, dynamic>> _allSchools = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  Map<String, List<String>> _filterAnswers = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterAnswers = widget.filterAnswers;
    print('Initial _filterAnswers in initState: $_filterAnswers');
    _fetchFilteredSchools();
    _fetchAllSchools();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allSchools
            .where((school) =>
                school['name']?.toString().toLowerCase().contains(query) ??
                false)
            .toList();
      }
    });
    print('Search query: $query, Results count: ${_searchResults.length}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    print('Raw arguments received in HomeScreen: $args');
    if (args != null && args is Map<String, List<String>>) {
      setState(() {
        _filterAnswers = args;
      });
      print(
          'HomeScreen received filterAnswers from arguments: \n$_filterAnswers');
    } else {
      print('HomeScreen did not receive filterAnswers from arguments.');
    }
  }

  Future<void> _fetchFilteredSchools() async {
    setState(() => _isLoading = true);
    try {
      final token = _authService.jwtToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      print('Fetching schools with filters: $_filterAnswers');

      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/schools'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final allSchools = data['data']['schools'] as List;
          print('Total schools fetched: ${allSchools.length}');

          // Filter schools based on location and category
          final filteredSchools = allSchools.where((school) {
            // Location filter
            final userLocations = _filterAnswers['location']
                    ?.map((loc) => loc.toLowerCase().trim())
                    .toList() ??
                [];
            final schoolAddress = school['address'] as List?;
            String? subCity;
            if (schoolAddress != null && schoolAddress.isNotEmpty) {
              final address = schoolAddress[0] as Map<String, dynamic>;
              subCity = address['subCity']?.toString().toLowerCase().trim();
            }
            final locationMatch =
                subCity != null && userLocations.contains(subCity);

            // Category filter
            final categoryMatch = _selectedCategory == null ||
                _mapCategoryToGradeLevel(_selectedCategory!) ==
                    (school['schoolType']?.toString().toLowerCase().trim() ??
                        'unknown');

            return locationMatch && categoryMatch;
          }).toList();

          print('Filtered schools count: ${filteredSchools.length}');
          print('Filtered schools: $filteredSchools');

          setState(() {
            _schools = filteredSchools
                .map((school) => school as Map<String, dynamic>)
                .toList();
          });
        } else {
          print('API returned unsuccessful status: ${data['status']}');
          setState(() {
            _schools = [];
          });
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to load schools: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in _fetchFilteredSchools: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching schools: $e')),
      );
      setState(() {
        _schools = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchAllSchools() async {
    try {
      final token = _authService.jwtToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/schools'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
      );

      print('All schools response status: ${response.statusCode}');
      print('All schools response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _allSchools = (data['data']['schools'] as List)
                .map((school) => school as Map<String, dynamic>)
                .toList();
          });
          print('Total schools fetched: ${_allSchools.length}');
        }
      }
    } catch (e) {
      print('Error fetching all schools: $e');
    }
  }

  String? _mapCategoryToGradeLevel(String category) {
    switch (category) {
      case 'KG':
        return 'Kindergarten';
      case 'Primary schools':
        return 'Primary';
      case 'Middle schools':
        return 'Middle';
      case 'High schools':
        return 'High';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search by school name',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      suffixIcon:
                                          _searchController.text.isNotEmpty
                                              ? IconButton(
                                                  icon: const Icon(Icons.clear,
                                                      color: Colors.grey),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                  },
                                                )
                                              : null,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/filters');
                                      },
                                      icon: const Icon(Icons.filter_list),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/notifications',
                                        );
                                      },
                                      icon: const Icon(Icons.notifications),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A3B82),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Start your search with extensive filters',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/home_screen_image.png",
                                    width: 150,
                                    height: 150,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Text('Image Placeholder'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Popular Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See all',
                                  style: TextStyle(color: Color(0xFFB188E3)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryButton(
                                  'All',
                                  'assets/images/highschool_image.png',
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = null;
                                      _fetchFilteredSchools();
                                    });
                                  },
                                ),
                                _buildCategoryButton(
                                  'KG',
                                  'assets/images/primary_image.png',
                                ),
                                _buildCategoryButton(
                                  'Primary schools',
                                  'assets/images/primary_image.png',
                                ),
                                _buildCategoryButton(
                                  'Middle schools',
                                  'assets/images/middleschool_inage.png',
                                ),
                                _buildCategoryButton(
                                  'High schools',
                                  'assets/images/highschool_image.png',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _searchController.text.isNotEmpty
                                    ? 'Search Results'
                                    : 'Schools Near You',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See all',
                                  style: TextStyle(color: Color(0xFFB188E3)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _searchController.text.isNotEmpty
                              ? _searchResults.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Text(
                                          'No schools found for this search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: _searchResults.map((school) {
                                          final address = school['address']
                                                      is List &&
                                                  (school['address'] as List)
                                                      .isNotEmpty
                                              ? (school['address'][0]
                                                  as Map<String, dynamic>)
                                              : {
                                                  'city': 'Unknown',
                                                  'subCity': 'Unknown'
                                                };

                                          return _buildSchoolCard(
                                            school['name'] ?? 'Unknown School',
                                            '${address['subCity'] ?? 'Unknown'}, ${address['city'] ?? 'Unknown'}',
                                            school['schoolType'] ?? 'Unknown',
                                            'K-12',
                                            '4.0',
                                            'assets/images/school1.jpg',
                                            fullSchoolObj: school,
                                          );
                                        }).toList(),
                                      ),
                                    )
                              : _schools.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Text(
                                          'No schools found in ${_filterAnswers['location']?.join(', ') ?? 'selected location'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: _schools.map((school) {
                                          final address = school['address']
                                                      is List &&
                                                  (school['address'] as List)
                                                      .isNotEmpty
                                              ? (school['address'][0]
                                                  as Map<String, dynamic>)
                                              : {
                                                  'city': 'Unknown',
                                                  'subCity': 'Unknown'
                                                };

                                          return _buildSchoolCard(
                                            school['name'] ?? 'Unknown School',
                                            '${address['subCity'] ?? 'Unknown'}, ${address['city'] ?? 'Unknown'}',
                                            school['schoolType'] ?? 'Unknown',
                                            'K-12',
                                            '4.0',
                                            'assets/images/school1.jpg',
                                            fullSchoolObj: school,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Schools by States',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See all',
                                  style: TextStyle(color: Color(0xFFB188E3)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildLocationCard(
                            _filterAnswers['location'] != null &&
                                    _filterAnswers['location']!.isNotEmpty
                                ? _filterAnswers['location']!.join(', ')
                                : 'Unknown Location',
                            '${_schools.length} schools',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Our Schools',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See all',
                                  style: TextStyle(color: Color(0xFFB188E3)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _allSchools.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      'No schools found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: _allSchools.map((school) {
                                      final address =
                                          school['address'] is List &&
                                                  (school['address'] as List)
                                                      .isNotEmpty
                                              ? (school['address'][0]
                                                  as Map<String, dynamic>)
                                              : {
                                                  'city': 'Unknown',
                                                  'subCity': 'Unknown'
                                                };

                                      return _buildSchoolCard(
                                        school['name'] ?? 'Unknown School',
                                        '${address['subCity'] ?? 'Unknown'}, ${address['city'] ?? 'Unknown'}',
                                        school['schoolType'] ?? 'Unknown',
                                        'K-12',
                                        '4.0',
                                        'assets/images/school1.jpg',
                                        fullSchoolObj: school,
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCategoryButton(String title, String imagePath,
      {VoidCallback? onTap}) {
    bool isSelected = _selectedCategory == title;

    return GestureDetector(
      onTap: onTap ??
          () {
            setState(() {
              _selectedCategory = _selectedCategory == title ? null : title;
              _fetchFilteredSchools(); // Refetch and filter schools based on category
            });
          },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB188E3)
                    : const Color.fromRGBO(254, 254, 255, 1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Center(child: Text('?')),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolCard(String name, String location, String type,
      String level, String rating, String imagePath,
      {required Map<String, dynamic> fullSchoolObj}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/schooldetailpage',
          arguments: fullSchoolObj,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('Image Placeholder'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: Color(0xFFB188E3),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "WorkSans",
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            color: const Color(0xFFE9E8FC),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            color: const Color(0xFFE9E8FC),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                level,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFDB022),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(rating, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(String location, String count) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.location_pin, color: Color(0xFFB188E3), size: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
