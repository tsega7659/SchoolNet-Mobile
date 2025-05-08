import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Profile Picture and Name
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sabrina Aryan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'SabrinaAryan20@gmail.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Edit Profile Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profil');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A3B82),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          // Profile Options
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(
                  context,
                  icon: Icons.favorite_border,
                  title: 'Favourites',
                  onTap: () {
                    // Add navigation to Favourites
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  onTap: () {
                    // Add navigation to Location
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
