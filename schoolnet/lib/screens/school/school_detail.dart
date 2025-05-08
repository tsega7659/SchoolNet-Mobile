import 'package:flutter/material.dart';
import 'package:schoolnet/screens/widgets/bottom_navbar.dart';

class SchoolDetailPage extends StatefulWidget {
  final Map<String, dynamic> schoolDetails;

  const SchoolDetailPage({Key? key, required this.schoolDetails})
    : super(key: key);

  @override
  State<SchoolDetailPage> createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {

  @override
  Widget build(BuildContext context) {
    final schoolDetails = widget.schoolDetails;
    final String name = schoolDetails['name'] ?? 'John F. Kennedy School';
    final String location = schoolDetails['location'] ?? 'Bole, Addis Ababa';
    final String type = schoolDetails['type'] ?? 'Private';
    final String level = schoolDetails['level'] ?? 'K-12';
    final String rating = schoolDetails['rating'] ?? '4.9';
    final String reviews = schoolDetails['reviews'] ?? '150 reviews';
    final String imagePath =
        schoolDetails['imagePath'] ?? 'assets/images/school1.jpg';
    // final String contact =
    //     schoolDetails['contact'] ??
    //     'Phone: +251-911-123-456\nEmail: info@jfkschool.edu';
    final String admissions =
        schoolDetails['admissions'] ?? 'Admissions and scholarships available';
    final String fees = schoolDetails['fees'] ?? 'Fees and scholarships';
    final String staff = schoolDetails['staff'] ?? 'Staff';
    final String review =
        schoolDetails['review'] ??
        'Lorem ipsum dolor sit amet consectetur. Suspendisse cursus. First lorem dolor quam adipiscing.';
    final String reviewer = schoolDetails['reviewer'] ?? 'John Smith';
    final String reviewerRole = schoolDetails['reviewerRole'] ?? 'Parent';

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
                  errorBuilder:
                      (context, error, stackTrace) => Container(
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
                              'Mixed',
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
                        child: Row(
                          children: [
                            const Icon(
                              Icons.group,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "500 Students",
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
                            "+251-911-123-456",
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
                            "school@school.com",
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
                            "www.school.com",
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
                          reviewer,
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
                              reviewerRole,
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
                        Text(review, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Follow Button
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add "Add To My List" logic here
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
                          'Add To My List',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
