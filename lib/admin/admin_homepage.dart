import 'package:flutter/material.dart';
import 'package:mind_guide_ui/signup_screen.dart';

import 'managePsychiatrists_screen.dart'; // Assuming RegisterPage is used for registration

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0064FA),
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                'Welcome to the Admin Panel',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0064FA),
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Effortlessly manage psychiatrists and patients.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),

              // Register New Psychiatrist and Patient Button
              buildCustomButton(
                text: 'Register New Psychiatrist & Patient',
                color: Color(0xff0064FA),
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SignupScreen(), // Navigate to register screen
                  ));
                },
              ),

              SizedBox(height: 20),

              // Manage Psychiatrists Button
              buildCustomButton(
                text: 'Manage Psychiatrists',
                color: Colors.green,
                icon: Icons.manage_accounts,
                onPressed: () {
                  // TODO: Implement manage psychiatrists navigation
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ManagePsychiatristsScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom button widget with an icon
  Widget buildCustomButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 26, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }
}
