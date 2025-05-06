import 'package:flutter/material.dart';
import 'package:schoolnet/screens/widgets/bottom_navbar.dart';

class AddmissionsScreen extends StatefulWidget {
  const AddmissionsScreen({super.key});

  @override
  State<AddmissionsScreen> createState() => _AddmissionsScreenState();
}

class _AddmissionsScreenState extends State<AddmissionsScreen> {
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admissions',
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
            const Text(
              'Admissions Criteria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Applicants to Dandiboru School must meet age requirements, submit previous academic records, and may need to take an entrance assessment.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              'Admissions Criteria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildNumberedList([
              'Complete the Application Form: Download from our website or request a physical copy.',
              'Submit Required Documents:',
              'Register for Entrance Assessment: Include this in your application.',
              'Attend the Interview: Schedule with our admissions team.',
              'Receive Admission Notification: You\'ll be informed of your child\'s status after the assessment and interview.',
            ]),
            const SizedBox(height: 8),
            _buildBulletedList([
              'Recent passport-sized photographs',
              'Previous academic records',
              'Recommendation letter (if applicable)',
            ]),
            const SizedBox(height: 20),
            const Text(
              'Application Timeline',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildBulletedList(['Application Open Date: [Insert Date]']),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(child: Text(items[index])),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBulletedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0, left: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '\u2022 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Text(item)),
                ],
              ),
            );
          }).toList(),
    );
  }
}
