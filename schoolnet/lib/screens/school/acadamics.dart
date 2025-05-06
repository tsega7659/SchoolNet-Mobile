import 'package:flutter/material.dart';
import 'package:schoolnet/screens/widgets/bottom_navbar.dart';

class AcadamicsScreen extends StatefulWidget {
  const AcadamicsScreen({super.key});

  @override
  State<AcadamicsScreen> createState() => _AcadamicsScreenState();
}

class _AcadamicsScreenState extends State<AcadamicsScreen> {
  int _currentIndex = 0;
  String? _selectedCategory;

  // Placeholder data for categories and academic items (replace with backend data later)
  final List<String> categories = [
    'All',
    'Science',
    'Math',
    'English',
    'History',
  ];

  final List<Map<String, dynamic>> academicItems = [
    {
      'title': 'Science Lab',
      'subtitle': 'Bole, Addis Ababa',
      'rating': '4.9',
      'imagePath': 'assets/images/science_lab.jpg',
    },
    {
      'title': 'Math Club',
      'subtitle': 'Bole, Addis Ababa',
      'rating': '4.8',
      'imagePath': 'assets/images/math_club.jpg',
    },
    {
      'title': 'English Literature',
      'subtitle': 'Bole, Addis Ababa',
      'rating': '4.7',
      'imagePath': 'assets/images/english_literature.jpg',
    },
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Add navigation logic here if needed
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.popUntil(context, ModalRoute.withName('/'));
        break;
      case 1:
        // Navigate to Favorites
        break;
      case 2:
        // Navigate to Chat
        break;
      case 3:
        // Navigate to Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Curriculum Section
            const Text(
              'Curriculum',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dandiboru School is dedicated to providing high-quality education through the British Curriculum.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            // Average Matrix Results
            const Text(
              'Average Matrix Results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 150,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAFF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    '450',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Extra Curriculum
            const Text(
              'Extra Curriculum',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Sports
            const Text(
              'Sports',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildPill('Tennis'),
                _buildPill('Soccer'),
                _buildPill('BasketBall'),
                _buildPill('BasketBall'),
                _buildPill('BasketBall'),
              ],
            ),
            const SizedBox(height: 20),
            // Academics
            const Text(
              'Academics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildPill('Mathematics'),
                _buildPill('Science'),
                _buildPill('Coding'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    bool isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = _selectedCategory == category ? null : category;
        });
        // Add backend filtration logic here later
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB188E3) : const Color(0xFFE9E8FC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicCard(
    String title,
    String subtitle,
    String rating,
    String imagePath,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Image Placeholder')),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFDB022),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontSize: 14)),
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
