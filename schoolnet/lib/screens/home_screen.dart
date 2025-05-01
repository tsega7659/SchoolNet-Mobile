import 'package:flutter/material.dart';
import 'package:schoolnet/screens/school_filter_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        title: Text(
          'SchoolNet',
          style: TextStyle(
            color: const Color(0xFF4A2C2A),
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsivePadding(context, 24),
          ),
          height: ResponsiveUtils.getResponsiveHeight(context, 56),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A2C2A), Color(0xFFB188E3)],
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveWidth(context, 16),
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchoolFilterScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveWidth(context, 16),
                ),
              ),
            ),
            child: Text(
              'Explore Schools',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.w600,
                fontFamily: 'WorkSans',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
