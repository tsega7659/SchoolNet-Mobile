import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/services/auth_service.dart'; // Assuming AuthService provides the JWT token

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? profileData;
  final Map<String, dynamic>? userData;
  final Map<String, List<String>>? filterAnswers;

  const EditProfileScreen(
      {Key? key, this.profileData, this.userData, this.filterAnswers})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.profileData?['firstName'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.profileData?['lastName'] ?? '');
    _emailController =
        TextEditingController(text: widget.userData?['email'] ?? '');
    _phoneController =
        TextEditingController(text: widget.userData?['phoneNumber'] ?? '');
  }

  Future<void> _createParentProfile() async {
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      print('No authentication token found for profile creation');
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
    );
    request.headers.addAll({
      'Cookie': 'jwt=$token',
    });

    request.fields['firstName'] = _firstNameController.text.isNotEmpty
        ? _firstNameController.text
        : (widget.userData?['email']?.split('@')[0] ?? 'User');
    request.fields['lastName'] = _lastNameController.text;
    request.fields['numberOfChildren'] =
        widget.filterAnswers?['numChildren']?.first ?? 'One';
    request.fields['childrenDetails'] = jsonEncode({
      'gradeLevels': widget.filterAnswers?['gradeLevel'] ?? ['KG'],
      'schoolType': widget.filterAnswers?['schoolType'] ?? ['Private'],
      'sameSchool': widget.filterAnswers?['sameSchool']?.first ?? 'No',
    });
    request.fields['address'] = jsonEncode({
      'city': 'Addis Ababa',
      'subCity': widget.filterAnswers?['location']?.first ?? 'Bole',
    });
    final tuitionFee = widget.filterAnswers?['tuitionFee']?.first;
    int budgetMin = 0;
    int budgetMax = 0;
    if (tuitionFee != null && tuitionFee.contains('-')) {
      final parts = tuitionFee.split('-').map(int.parse).toList();
      budgetMin = parts[0];
      budgetMax = parts[1];
    } else if (tuitionFee == 'above 15000') {
      budgetMin = 15001;
      budgetMax = 999999;
    }
    request.fields['budgetMin'] = budgetMin.toString();
    request.fields['budgetMax'] = budgetMax.toString();

    try {
      print('Creating parent profile with data: ${request.fields}');
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        print('Parent profile created successfully: $respStr');
        return;
      } else {
        print(
            'Failed to create parent profile: ${response.statusCode} - $respStr');
        throw Exception(
            'Failed to create parent profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating parent profile: $e');
      throw Exception('Error creating parent profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isLoading = true);
    final authService = AuthService();
    final token = authService.jwtToken;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found')));
      setState(() => isLoading = false);
      return;
    }

    // Update user data (email, phoneNumber)
    final Map<String, dynamic> userBody = {};
    if (_emailController.text.isNotEmpty &&
        _emailController.text != (widget.userData?['email'] ?? '')) {
      userBody['email'] = _emailController.text;
    }
    if (_phoneController.text.isNotEmpty &&
        _phoneController.text != (widget.userData?['phoneNumber'] ?? '')) {
      userBody['phoneNumber'] = _phoneController.text;
    }

    // Update parent profile data (firstName, lastName)
    var parentRequest = http.MultipartRequest(
      'PATCH',
      Uri.parse('https://schoolnet-be.onrender.com/api/v1/parentProfiles'),
    );
    parentRequest.headers.addAll({'Cookie': 'jwt=$token'});

    if (_firstNameController.text.isNotEmpty &&
        _firstNameController.text != (widget.profileData?['firstName'] ?? '')) {
      parentRequest.fields['firstName'] = _firstNameController.text;
    }
    if (_lastNameController.text.isNotEmpty &&
        _lastNameController.text != (widget.profileData?['lastName'] ?? '')) {
      parentRequest.fields['lastName'] = _lastNameController.text;
    }

    // Log the updates being sent
    print('Updating user data with: $userBody');
    print('Updating parent profile with: ${parentRequest.fields}');

    try {
      if (userBody.isNotEmpty) {
        print('Sending user update request to /api/v1/users/updateMe');
        final userResponse = await http.patch(
          Uri.parse('https://schoolnet-be.onrender.com/api/v1/users/updateMe'),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'jwt=$token',
          },
          body: jsonEncode(userBody),
        );
        if (userResponse.statusCode != 200) {
          print(
              'User update failed: ${userResponse.statusCode} - ${userResponse.body}');
          throw Exception('Failed to update user: ${userResponse.statusCode}');
        } else {
          print('User update successful: ${userResponse.body}');
        }
      }

      if (parentRequest.fields.isNotEmpty) {
        print(
            'Sending parent profile update request to /api/v1/parentProfiles');
        final parentResponse = await parentRequest.send();
        final respStr = await parentResponse.stream.bytesToString();
        if (parentResponse.statusCode == 200) {
          print('Parent profile update successful: $respStr');
        } else if (parentResponse.statusCode == 404) {
          print('Parent profile not found, attempting to create one...');
          await _createParentProfile();
          // Retry the update after creation
          final retryResponse = await parentRequest.send();
          final retryRespStr = await retryResponse.stream.bytesToString();
          if (retryResponse.statusCode == 200) {
            print(
                'Parent profile update successful after creation: $retryRespStr');
          } else {
            print('Retry failed: ${retryResponse.statusCode} - $retryRespStr');
            throw Exception(
                'Failed to update parent profile after creation: ${retryResponse.statusCode}');
          }
        } else {
          print(
              'Parent profile update failed: ${parentResponse.statusCode} - $respStr');
          throw Exception(
              'Failed to update parent profile: ${parentResponse.statusCode}');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')));
      Navigator.pop(context, {
        'userData': userBody,
        'profileData': parentRequest.fields,
      });
    } catch (e) {
      print('Error during profile update: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A3B82),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A3B82),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/staff.jpg'),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF5A3B82),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Add logic to change profile picture
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                          label: 'FIRST NAME',
                          controller: _firstNameController),
                      const SizedBox(height: 16),
                      _buildTextField(
                          label: 'LAST NAME', controller: _lastNameController),
                      const SizedBox(height: 16),
                      _buildTextField(
                          label: 'EMAIL', controller: _emailController),
                      const SizedBox(height: 16),
                      _buildTextField(
                          label: 'PHONE NUMBER', controller: _phoneController),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A3B82),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          label: const Text(
                            'Save Profile',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
