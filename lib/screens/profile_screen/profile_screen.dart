import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutz_app/core/theme_controller.dart';
import 'package:nutz_app/screens/auth/login_screen/controller/login_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: size.height * 0.025, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.height * 0.018),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: size.height * 0.075,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Icon(Icons.person,
                            size: size.height * 0.075, color: Colors.grey)
                        : null,
                  ),
                  Container(
                    padding: EdgeInsets.all(size.height * 0.007),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(size.height * 0.025),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: size.height * 0.022,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.012),
              Text(
                user?.displayName ?? 'No Name',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.007),
              Text(
                user?.email ?? 'No Email',
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: size.height * 0.025),
              _buildProfileCard(
                size: size,
                icon: Icons.calendar_today,
                title: 'Account Created',
                value: user?.metadata.creationTime?.toString().split(' ')[0] ??
                    'Unknown',
              ),
              _buildProfileCard(
                size: size,
                icon: Icons.update,
                title: 'Last Sign In',
                value:
                    user?.metadata.lastSignInTime?.toString().split(' ')[0] ??
                        'Unknown',
              ),
              _buildProfileCard(
                size: size,
                icon: Icons.verified_user,
                title: 'Provider',
                value: user?.providerData.first.providerId
                        .replaceAll('.com', '') ??
                    'Unknown',
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer<ThemeController>(
                  builder: (context, themeController, _) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => themeController.toggleTheme(),
                      icon: Icon(themeController.themeMode == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode),
                      label: Text(themeController.themeMode == ThemeMode.light
                          ? 'Dark Mode'
                          : 'Light Mode'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.012),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.012),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await loginController.signOut();
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.012),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.height * 0.012),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required Size size,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.015),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.02),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.height * 0.017,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
