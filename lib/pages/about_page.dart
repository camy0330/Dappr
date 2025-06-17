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
    // Get the current theme's text and background colors
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Determine if the current theme is dark
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark; // Still useful for body text colors

    // Define colors that change based on the theme for the body content
    final Color bodyTextColor = isDarkTheme ? Colors.white70 : Colors.black87; // For general text
    final Color bodySubtitleColor = isDarkTheme ? Colors.white54 : Colors.grey[700]!; // For descriptions/subtle text
    final Color bodyDividerColor = isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300; // For dividers

    return Scaffold(
      // Scaffold background will use the theme's scaffold background color
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Reverted to default theme background

      appBar: AppBar(
        title: Text(
          'About Dappr',
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white), // Title color is white for contrast
        ),
        // Apply the gradient here using flexibleSpace
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent], // Your desired gradient for the AppBar
              begin: Alignment.topLeft, // Start of the gradient (adjust as needed)
              end: Alignment.bottomRight, 
            ),
          ),
        ),
        // Ensure icon color contrasts with the gradient
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow icon color is white
        elevation: 0, // No shadow under the AppBar
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
                  Text(
                    'Dappr',
                    style: textTheme.headlineMedium!.copyWith(
                      color: colorScheme.primary, // Keep Dappr name deep orange (or adjust based on overall theme)
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // This SizedBox now separates the logo/name block from description
            // App Description
            Text(
              'Dappr is your ultimate culinary companion, designed to simplify your cooking journey. '
              'Discover new recipes, plan your meals, manage shopping lists, and set cooking timers '
              'all in one intuitive app.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge!.copyWith(
                color: bodyTextColor, // Use the dynamically determined bodyTextColor
                fontFamily: 'Montserrat',
              ),
            ),
            Divider(height: 40, thickness: 1, color: bodyDividerColor), // Use dynamic divider color
            // Version Information
            _buildInfoRow(
              context,
              'Version:',
              '1.0.0',
              labelColor: bodyTextColor,
              valueColor: bodySubtitleColor,
            ),
            _buildInfoRow(
              context,
              'Developed by:',
              'Dappr Team',
              labelColor: bodyTextColor,
              valueColor: bodySubtitleColor,
            ),
            const SizedBox(height: 20),
            // Contact Information
            Text(
              'Contact Us:',
              style: textTheme.titleLarge!.copyWith(
                color: bodyTextColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email, color: colorScheme.primary), // Use theme primary color
              title: Text('support@dappr.com', style: textTheme.bodyLarge!.copyWith(color: bodyTextColor, fontFamily: 'Montserrat')), // Use dynamic bodyTextColor
              onTap: () => _launchUrl('mailto:support@dappr.com?subject=Dappr App Support'),
            ),
            ListTile(
              leading: Icon(Icons.web, color: colorScheme.primary), // Use theme primary color
              title: Text('www.dappr.com', style: textTheme.bodyLarge!.copyWith(color: bodyTextColor, fontFamily: 'Montserrat')), // Use dynamic bodyTextColor
              onTap: () => _launchUrl('https://www.dappr.com'), // Replace with your actual website
            ),
            Divider(height: 40, thickness: 1, color: bodyDividerColor), // Use dynamic divider color
            // Legal Links
            Text(
              'Legal:',
              style: textTheme.titleLarge!.copyWith(
                color: bodyTextColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.policy, color: colorScheme.primary), // Use theme primary color
              title: Text('Privacy Policy', style: textTheme.bodyLarge!.copyWith(color: bodyTextColor, fontFamily: 'Montserrat')), // Use dynamic bodyTextColor
              onTap: () => _launchUrl('https://www.dappr.com/privacy-policy'), // Replace with your actual privacy policy
            ),
            ListTile(
              leading: Icon(Icons.description, color: colorScheme.primary), // Use theme primary color
              title: Text('Terms of Service', style: textTheme.bodyLarge!.copyWith(color: bodyTextColor, fontFamily: 'Montserrat')), // Use dynamic bodyTextColor
              onTap: () => _launchUrl('https://www.dappr.com/terms-of-service'), // Replace with your actual terms
            ),
            const SizedBox(height: 30),
            // Rate Us Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for rating Dappr!', style: TextStyle(fontFamily: 'Montserrat')),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.star, color: Colors.white), // Icon color white for contrast
                label: Text(
                  'Rate Us',
                  style: textTheme.labelLarge!.copyWith(
                    fontSize: 18,
                    color: Colors.white, // Text color white for contrast
                    fontFamily: 'Montserrat',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary, // Button color primary (deepOrange)
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '© 2025 Dappr. All rights reserved.',
                style: textTheme.bodySmall!.copyWith(
                  color: bodySubtitleColor, // Use dynamic bodySubtitleColor
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent info rows
  Widget _buildInfoRow(BuildContext context, String label, String value, {required Color labelColor, required Color valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: labelColor,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: valueColor,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}