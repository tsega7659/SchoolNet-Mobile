import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart'; // Assuming AuthService provides the JWT token
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, List<String>>? filterAnswers;

  const ProfileScreen({Key? key, this.filterAnswers}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  Map<String, List<String>>? _filterAnswers;
  int? _budgetMin;
  int? _budgetMax;

  @override
  void initState() {
    super.initState();
    _loadFilterAnswers();
    _fetchProfile();
    _fetchUser();
  }

  Future<void> _loadFilterAnswers() async {
    print('Loading filter answers from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final savedProfile = prefs.getString('parent_profile');

    if (savedProfile != null) {
      print('Found saved filter answers');
      final Map<String, dynamic> decodedProfile = jsonDecode(savedProfile);
      setState(() {
        _filterAnswers = Map<String, List<String>>.from(
          decodedProfile.map((key, value) => MapEntry(
                key,
                (value is List)
                    ? value.map((e) => e.toString()).toList()
                    : [value.toString()],
              )),
        );
        // Parse tuitionFee into budgetMin and budgetMax
        final tuitionFee = _filterAnswers?['tuitionFee']?.first;
        if (tuitionFee != null && tuitionFee.contains('-')) {
          final parts = tuitionFee.split('-').map(int.parse).toList();
          _budgetMin = parts[0];
          _budgetMax = parts[1];
        } else if (tuitionFee == 'above 15000') {
          _budgetMin = 15001;
          _budgetMax = 999999; // Arbitrary large number for "above"
        } else {
          _budgetMin = 0;
          _budgetMax = 0;
        }
      });
      print(
          'Filter answers loaded: $_filterAnswers, Budget: $_budgetMin - $_budgetMax');
    } else if (widget.filterAnswers != null) {
      print('Using filter answers from widget: ${widget.filterAnswers}');
      setState(() {
        _filterAnswers = widget.filterAnswers;
        // Parse tuitionFee into budgetMin and budgetMax
        final tuitionFee = _filterAnswers?['tuitionFee']?.first;
        if (tuitionFee != null && tuitionFee.contains('-')) {
          final parts = tuitionFee.split('-').map(int.parse).toList();
          _budgetMin = parts[0];
          _budgetMax = parts[1];
        } else if (tuitionFee == 'above 15000') {
          _budgetMin = 15001;
          _budgetMax = 999999; // Arbitrary large number for "above"
        } else {
          _budgetMin = 0;
          _budgetMax = 0;
        }
      });
    } else {
      print('No filter answers found');
    }
  }

  Future<void> _fetchUser() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      print('No authentication token found');
      if (mounted) {
        setState(() {
          isLoading = false;
          userData = {'error': 'Authentication token not found'};
        });
      }
      return;
    }

    try {
      print('Fetching user data...');
      final response = await http.get(
        Uri.parse(
            'https://schoolnet-be.onrender.com/api/v1/users/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User data received: $data');

        if (data['status'] == 'success' && data['data'] != null) {
          final user = data['data']['user'] ?? data['data'];
          setState(() {
            userData = user;
            isLoading = false;
          });
          print('User data set successfully: $user');
        } else {
          print('No user data found in response');
          setState(() {
            userData = {'error': 'No user data found'};
            isLoading = false;
          });
        }
      } else {
        print('Failed to load user: ${response.statusCode}');
        setState(() {
          userData = {'error': 'Failed to load user: ${response.statusCode}'};
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user: $e');
      if (!mounted) return;
      setState(() {
        userData = {'error': 'Error fetching user: $e'};
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProfile() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      print('No authentication token found');
      if (mounted) {
        setState(() {
          isLoading = false;
          profileData = {'error': 'Authentication token not found'};
        });
      }
      return;
    }

    try {
      print('Fetching parent profile...');
      final response = await http.get(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Profile data received: $data');

        if (data['status'] == 'success' && data['data'] != null) {
          final profile = data['data']['parentProfile'] ?? data['data'];
          setState(() {
            profileData = profile;
            isLoading = false;
            _budgetMin = profile['budgetMin'] ?? _budgetMin;
            _budgetMax = profile['budgetMax'] ?? _budgetMax;
          });
          print('Profile data set successfully: $profile');
        } else {
          print('No profile data found in response');
          setState(() {
            profileData = {'error': 'No profile data found'};
            isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        print('Parent profile not found, attempting to create one...');
        await _createParentProfile();
      } else {
        print('Failed to load profile: ${response.statusCode}');
        setState(() {
          profileData = {
            'error': 'Failed to load profile: ${response.statusCode}'
          };
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      if (!mounted) return;
      setState(() {
        profileData = {'error': 'Error fetching profile: $e'};
        isLoading = false;
      });
    }
  }

  Future<void> _createParentProfile() async {
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      print('No authentication token found for profile creation');
      return;
    }

    // Use filterAnswers to populate initial profile data
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
    );
    request.headers.addAll({
      'Cookie': 'jwt=$token',
    });

    // Default values or from filterAnswers
    request.fields['firstName'] = userData?['email']?.split('@')[0] ?? 'User';
    request.fields['lastName'] = '';
    request.fields['numberOfChildren'] =
        _filterAnswers?['numChildren']?.first ?? 'One';
    request.fields['childrenDetails'] = jsonEncode({
      'gradeLevels': _filterAnswers?['gradeLevel'] ?? ['KG'],
      'schoolType': _filterAnswers?['schoolType'] ?? ['Private'],
      'sameSchool': _filterAnswers?['sameSchool']?.first ?? 'No',
    });
    request.fields['address'] = jsonEncode({
      'city': 'Addis Ababa',
      'subCity': _filterAnswers?['location']?.first ?? 'Bole',
    });
    request.fields['budgetMin'] = (_budgetMin ?? 0).toString();
    request.fields['budgetMax'] = (_budgetMax ?? 0).toString();

    try {
      print('Creating parent profile with data: ${request.fields}');
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        final data = jsonDecode(respStr);
        setState(() {
          profileData = data['data'];
          _budgetMin = int.tryParse(request.fields['budgetMin'] ?? '0');
          _budgetMax = int.tryParse(request.fields['budgetMax'] ?? '0');
        });
        print('Parent profile created successfully: $data');
      } else {
        print(
            'Failed to create parent profile: ${response.statusCode} - $respStr');
        setState(() {
          profileData = {
            'error': 'Failed to create parent profile: ${response.statusCode}'
          };
        });
      }
    } catch (e) {
      print('Error creating parent profile: $e');
      setState(() {
        profileData = {'error': 'Error creating parent profile: $e'};
      });
    }
  }

  Future<void> _updateUser(String? email, String? phoneNumber) async {
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found')),
      );
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/users/updateMe'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'jwt=$token',
        },
        body: jsonEncode({
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['data']['updatedUser'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update user: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    }
  }

  Future<void> _updateParentProfile({
    String? firstName,
    String? lastName,
  }) async {
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
    );
    request.headers.addAll({
      'Cookie': 'jwt=$token',
    });

    if (firstName != null) request.fields['firstName'] = firstName;
    if (lastName != null) request.fields['lastName'] = lastName;

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(respStr);
        setState(() {
          profileData = data['data'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parent profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to update profile: ${response.statusCode} - $respStr')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Construct profile image URL
    String? profileImageUrl;
    final imgPath = profileData?['img']?.toString();
    if (imgPath != null && imgPath.isNotEmpty && imgPath != 'default.png') {
      profileImageUrl = 'https://schoolnet-be.onrender.com/uploads/$imgPath';
      print('Attempting to load profile image: $profileImageUrl');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF5A3B82),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(
                            profileImageUrl,
                            headers: {
                              'Cookie': 'jwt=${AuthService().jwtToken ?? ''}',
                            },
                          )
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                    onBackgroundImageError: profileImageUrl != null
                        ? (exception, stackTrace) {
                            print('Failed to load profile image: $exception');
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileData?['firstName'] != null &&
                            profileData?['lastName'] != null
                        ? '${profileData?['firstName']} ${profileData?['lastName']}'
                        : profileData?['name'] ?? 'Parent',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit_profile',
                        arguments: {
                          'profileData': profileData,
                          'userData': userData,
                          'filterAnswers': _filterAnswers,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3B82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferences',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A3B82),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPreferenceItem(
                          'Number of Children',
                          profileData?['numberOfChildren'] is List
                              ? ((profileData?['numberOfChildren'] as List)
                                      .isNotEmpty
                                  ? (profileData?['numberOfChildren'] as List)
                                      .first
                                      .toString()
                                  : _filterAnswers?['numChildren']?.first ??
                                      'Not specified')
                              : profileData?['numberOfChildren']?.toString() ??
                                  _filterAnswers?['numChildren']?.first ??
                                  'Not specified',
                        ),
                        if ((profileData?['numberOfChildren'] is List &&
                                ((profileData?['numberOfChildren'] as List)
                                        .contains('two') ||
                                    (profileData?['numberOfChildren'] as List)
                                        .contains('more than two'))) ||
                            (_filterAnswers?['numChildren']?.first == 'Two' ||
                                _filterAnswers?['numChildren']?.first ==
                                    'More than two'))
                          _buildPreferenceItem(
                            'Same School Preference',
                            profileData?['childrenDetails']?['sameSchool']
                                    ?.toString() ??
                                _filterAnswers?['sameSchool']?.first ??
                                'Not specified',
                          ),
                        _buildPreferenceItem(
                          'Preferred School Type',
                          (profileData?['childrenDetails']?['schoolType']
                                      as List<dynamic>?)
                                  ?.map((e) => e.toString())
                                  .join(', ') ??
                              _filterAnswers?['schoolType']?.join(', ') ??
                              'Not specified',
                        ),
                        _buildPreferenceItem(
                          'Grade Level',
                          (profileData?['childrenDetails']?['gradeLevels']
                                      as List<dynamic>?)
                                  ?.map((e) => e.toString())
                                  .join(', ') ??
                              _filterAnswers?['gradeLevel']?.join(', ') ??
                              'Not specified',
                        ),
                        _buildPreferenceItem(
                          'Budget Range',
                          '${profileData?['budgetMin'] ?? _budgetMin ?? 'Not specified'} - ${profileData?['budgetMax'] ?? _budgetMax ?? 'Not specified'}',
                        ),
                        _buildPreferenceItem(
                          'Location',
                          profileData?['address']?['subCity']?.toString() ??
                              _filterAnswers?['location']?.first ??
                              'Not specified',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildProfileOption(
                        context,
                        icon: Icons.favorite_border,
                        title: 'Favourites',
                        onTap: () {
                          Navigator.pushNamed(context, '/favorites');
                        },
                      ),
                      _buildProfileOption(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Setting',
                        onTap: () {
                          // Add navigation to Settings
                        },
                      ),
                      const Divider(),
                      _buildProfileOption(
                        context,
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: () {
                          // Add log out logic
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildPreferenceItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
