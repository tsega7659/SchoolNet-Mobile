import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class FilteredSchoolsScreen extends StatelessWidget {
  final Map<String, dynamic> filterAnswers;

  const FilteredSchoolsScreen({Key? key, required this.filterAnswers})
    : super(key: key);

  // Mock school data
  final List<Map<String, dynamic>> mockSchools = const [
    {
      'name': 'Ethiopian International School',
      'logo': 'assets/images/schoolnet1logo.svg',
      'curriculum': 'Ethiopian National',
      'type': 'Private',
      'location': 'Bole',
      'rating': 4.5,
    },
    {
      'name': 'Cambridge Academy',
      'logo': 'assets/images/schoolnet1logo.svg',
      'curriculum': 'Cambridge',
      'type': 'Private',
      'location': 'CMC',
      'rating': 4.8,
    },
    {
      'name': 'Montessori Kids',
      'logo': 'assets/images/schoolnet1logo.svg',
      'curriculum': 'Montessori',
      'type': 'Private',
      'location': 'Gerji',
      'rating': 4.3,
    },
    {
      'name': 'International School of Ethiopia',
      'logo': 'assets/images/schoolnet1logo.svg',
      'curriculum': 'IB',
      'type': 'Private',
      'location': 'Sarbet',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        title: Text(
          'Recommended Schools',
          style: TextStyle(
            color: const Color(0xFF4A2C2A),
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(
          ResponsiveUtils.getResponsivePadding(context, 16),
        ),
        itemCount: mockSchools.length,
        itemBuilder: (context, index) {
          final school = mockSchools[index];
          return Card(
            margin: EdgeInsets.only(
              bottom: ResponsiveUtils.getResponsiveHeight(context, 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveWidth(context, 16),
              ),
            ),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to school details screen
              },
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.getResponsiveWidth(context, 80),
                      height: ResponsiveUtils.getResponsiveHeight(context, 80),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveWidth(context, 8),
                        ),
                      ),
                      child: SvgPicture.asset(
                        school['logo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveWidth(context, 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school['name'],
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                18,
                              ),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4A2C2A),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.getResponsiveHeight(
                              context,
                              8,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  16,
                                ),
                                color: Colors.grey[600],
                              ),
                              SizedBox(
                                width: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  4,
                                ),
                              ),
                              Text(
                                school['curriculum'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        14,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  16,
                                ),
                              ),
                              Icon(
                                Icons.location_on,
                                size: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  16,
                                ),
                                color: Colors.grey[600],
                              ),
                              SizedBox(
                                width: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  4,
                                ),
                              ),
                              Text(
                                school['location'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        14,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveUtils.getResponsiveHeight(
                              context,
                              8,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (i) => Icon(
                                  i < school['rating'].floor()
                                      ? Icons.star
                                      : i < school['rating']
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  size: ResponsiveUtils.getResponsiveWidth(
                                    context,
                                    20,
                                  ),
                                  color: const Color(0xFFB188E3),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  8,
                                ),
                              ),
                              Text(
                                '${school['rating']}',
                                style: TextStyle(
                                  color: const Color(0xFF4A2C2A),
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
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
            ),
          );
        },
      ),
    );
  }
}
