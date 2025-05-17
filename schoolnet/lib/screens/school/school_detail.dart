import 'package:flutter/material.dart';
import 'package:schoolnet/screens/widgets/bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart';

class SchoolDetailPage extends StatefulWidget {
  final Map<String, dynamic> schoolDetails;

  const SchoolDetailPage({Key? key, required this.schoolDetails})
      : super(key: key);

  @override
  State<SchoolDetailPage> createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
  bool _isSavingFavorite = false;

  Future<void> _addToFavorites() async {
    setState(() => _isSavingFavorite = true);
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found')),
      );
      setState(() => _isSavingFavorite = false);
      return;
    }

    try {
      print('Adding school to favorites: ${widget.schoolDetails['_id']}');
      final response = await http.patch(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles/saveSchool'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token',
        },
        body: jsonEncode({
          'schoolId': widget.schoolDetails['_id'],
        }),
      );

      print('Add to favorites response: ${response.statusCode}');
      print('Add to favorites body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School added to favorites!')),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No parent profile found. Please complete onboarding or profile setup.')),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add school: ${error['message'] ?? response.body}')),
        );
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSavingFavorite = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolDetails = widget.schoolDetails;

    // Extract address information
    final address = schoolDetails['address'] is List &&
            (schoolDetails['address'] as List).isNotEmpty
        ? (schoolDetails['address'][0] as Map<String, dynamic>)
        : {'city': 'Unknown', 'subCity': 'Unknown'};

    final String name = schoolDetails['name'] ?? 'Unknown School';
    final String location =
        '${address['subCity'] ?? 'Unknown'}, ${address['city'] ?? 'Unknown'}';
    final String type = schoolDetails['schoolType'] ?? 'Unknown';
    final String level = schoolDetails['division']?.join(', ') ?? 'K-12';
    final String rating = '4.0'; // You might want to add this to your API
    final String reviews =
        '0 reviews'; // You might want to add this to your API
    final String imagePath = 'assets/images/school1.jpg'; // Default image
    final String phoneNumber = schoolDetails['phoneNumber'] ?? 'Not available';
    final String email = schoolDetails['email'] ?? 'Not available';
    final String website = schoolDetails['schoolWebsite'] ?? 'Not available';
    final String description =
        schoolDetails['description'] ?? 'No description available';
    final int studentCount = schoolDetails['studentCount'] ?? 0;
    final int yearEstablished = schoolDetails['yearEstablished'] ?? 0;
    final String schoolId = schoolDetails['_id'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  imagePath,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Image Placeholder')),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.favorite_border, color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.share, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // School Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                          Text(rating, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 34),
                          Text(
                            reviews,
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.group,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$studentCount Students',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              level,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Contact Details
                  const Text(
                    'Contact Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey, size: 18),
                          SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey, size: 18),
                          SizedBox(width: 4),
                          Text(
                            phoneNumber,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.grey, size: 18),
                          SizedBox(width: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.language, color: Colors.grey, size: 18),
                          SizedBox(width: 4),
                          Text(
                            website,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Admissions
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/acadamics');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Academics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admissions'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Admissions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/fees'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fees and Scholarships',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/staffs'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Staff',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  SizedBox(height: 16),
                  // Reviews
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/review_image.jpg',
                      ),
                      radius: 20,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'John Smith',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E8FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Parent',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFDB022),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text('4.8', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                            'Lorem ipsum dolor sit amet consectetur. Suspendisse cursus. First lorem dolor quam adipiscing.',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Follow Button
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _isSavingFavorite ? null : _addToFavorites,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A3B82),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                        child: _isSavingFavorite
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Add To My List',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 16), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Add "Follow" logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A3B82),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Increased roundness
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16, // Adjusted padding for better height
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ), // Full width button
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
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
