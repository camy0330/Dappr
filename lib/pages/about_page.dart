// lib/pages/about_page.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Function to launch a URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // If the URL cannot be launched, show a SnackBar
      debugPrint('Could not launch $url');
      // In a real app, you might show a more user-friendly error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dappr', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white)), // Changed title color to white
        backgroundColor: Colors.deepOrange, // Consistent theme color
        iconTheme: const IconThemeData(color: Colors.white), // For the back arrow icon, changed to white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Combined Lottie and App Name into a single centered column
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
                children: [
                  Lottie.asset(
                    'assets/animations/dappr_logo_wrapped.json', // Your Lottie file path
                    width: 160,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 160,
                        height: 150,
                        color: Colors.red.shade900, // Strong red for error visibility
                        alignment: Alignment.center,
                        child: const Text(
                          'Lottie asset failed to load. Check pubspec.yaml and path.',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Dappr',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // This SizedBox now separates the logo/name block from description
            // App Description
            const Text(
              'Dappr is your ultimate culinary companion, designed to simplify your cooking journey. '
              'Discover new recipes, plan your meals, manage shopping lists, and set cooking timers '
              'all in one intuitive app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87, // Kept as black87 for good contrast on white background
                fontFamily: 'Montserrat',
              ),
            ),
            const Divider(height: 40, thickness: 1),
            // Version Information
            _buildInfoRow('Version:', '1.0.0'),
            _buildInfoRow('Developed by:', 'Dappr Team'),
            const SizedBox(height: 20),
            // Contact Information
            const Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.black87, // Changed text color to black87
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.deepOrange),
              title: const Text('support@dappr.com', style: TextStyle(fontFamily: 'Montserrat', color: Colors.black87)), // Changed text color to black87
              onTap: () => _launchUrl('mailto:support@dappr.com?subject=Dappr App Support'),
            ),
            ListTile(
              leading: const Icon(Icons.web, color: Colors.deepOrange),
              title: const Text('www.dappr.com', style: TextStyle(fontFamily: 'Montserrat', color: Colors.black87)), // Changed text color to black87
              onTap: () => _launchUrl('https://www.dappr.com'), // Replace with your actual website
            ),
            const Divider(height: 40, thickness: 1),
            // Legal Links
            const Text(
              'Legal:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Colors.black87, // Changed text color to black87
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.policy, color: Colors.deepOrange),
              title: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Montserrat', color: Colors.black87)), // Changed text color to black87
              onTap: () => _launchUrl('https://www.dappr.com/privacy-policy'), // Replace with your actual privacy policy
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.deepOrange),
              title: const Text('Terms of Service', style: TextStyle(fontFamily: 'Montserrat', color: Colors.black87)), // Changed text color to black87
              onTap: () => _launchUrl('https://www.dappr.com/terms-of-service'), // Replace with your actual terms
            ),
            const SizedBox(height: 30),
            // Rate Us Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show a SnackBar as a placeholder for rating action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for rating Dappr!', style: TextStyle(fontFamily: 'Montserrat')),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // For a real app, you'd launch the app store review page here
                  // _launchUrl('market://details?id=your.app.package.name'); // Android
                  // _launchUrl('itms-apps://itunes.apple.com/app/idYOUR_APP_ID'); // iOS
                },
                icon: const Icon(Icons.star, color: Colors.white),
                label: const Text(
                  'Rate Us',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '© 2025 Dappr. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Montserrat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: Colors.black87, // Changed text color to black87
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey, // Kept as grey for subtle distinction
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
