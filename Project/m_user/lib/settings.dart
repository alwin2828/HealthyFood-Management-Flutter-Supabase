import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_user/change_pass.dart';
import 'package:m_user/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        HapticFeedback.lightImpact();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Supabase.instance.client.auth.signOut();
        if (context.mounted) {
          HapticFeedback.heavyImpact();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deletion requested')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      HapticFeedback.selectionClick();
      // Implement theme switching logic here, e.g., using Provider or ThemeData
    });
  }

  void _changeLanguage(String? value) {
    if (value != null) {
      setState(() {
        _selectedLanguage = value;
        HapticFeedback.selectionClick();
        // Implement language change logic here, e.g., using a localization package
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preferences Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.brightness_6,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                            'Dark Mode',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing: Switch(
                            value: _isDarkMode,
                            onChanged: _toggleTheme,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.language,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                            'Language',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing: DropdownButton<String>(
                            value: _selectedLanguage,
                            items: ['English', 'Spanish', 'French']
                                .map((String language) =>
                                    DropdownMenuItem<String>(
                                      value: language,
                                      child: Text(language),
                                    ))
                                .toList(),
                            onChanged: _changeLanguage,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications,
                              color: Theme.of(context).primaryColor),
                          title: Text(
                            'Notifications',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // Navigate to notifications settings page
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Account Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'Account',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lock, color: Colors.blue),
                          title: Text(
                            'Change Password',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChangePassword()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: Text(
                            'Logout',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onTap: () => supabase.auth.signOut().then((_) {
                            HapticFeedback.lightImpact();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/login', (route) => false);
                          }),
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_forever,
                              color: Colors.red),
                          title: Text(
                            'Delete Account',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onTap: () => _deleteAccount(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // About Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'About',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info, color: Colors.blue),
                          title: Text(
                            'About App',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'About Nutri-Q',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                                content: SingleChildScrollView(
                                  child: Text(
                                    '''
Nutri-Q is an innovative platform designed to assist individuals in achieving their fitness and dietary goals through personalized meal plans and high-quality, fresh meal options. The system consists of a mobile application for end-users and a web-based interface for admins and shop owners, ensuring a seamless experience across all stakeholders.

The Nutri-Q mobile application empowers users to select meal plans tailored to their specific needs, whether for weight gain, weight loss, or maintenance. By integrating key features such as meal customization, dietary filters, and seamless order tracking, Nutri-Q prioritizes both health and convenience. The app also incorporates an allergy filter, allowing users to make informed meal choices without compromising their health.

On the administrative side, the web-based interface enables shop owners and administrators to manage operations efficiently. The platform facilitates inventory management, worker scheduling, order tracking, and secure transactions, ensuring smooth and optimized meal preparation services. Shop owners can monitor their businesses seamlessly, while workers can manage meal preparations and deliveries efficiently.

Nutri-Q is more than just a meal management system; it is a commitment to supporting a healthy lifestyle through technology. By offering a user-friendly mobile app for customers and a powerful web interface for business management, Nutri-Q revolutionizes the meal prep service industry, making healthy eating easier, safer, and more accessible for everyone.
                                    ''',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Close',
                                        style: GoogleFonts.poppins()),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.privacy_tip, color: Colors.blue),
                          title: Text(
                            'Privacy Terms',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Privacy Terms',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                                content: SingleChildScrollView(
                                  child: Text(
                                    '''
Your privacy is important to us. Nutri-Q collects only the information necessary to provide you with personalized meal plans and a seamless user experience. We do not share your personal data with third parties except as required to deliver our services or comply with legal obligations.

All user data is securely stored and handled in accordance with applicable privacy laws. You have the right to access, modify, or delete your information at any time through your account settings.

By using Nutri-Q, you agree to our privacy practices as outlined above. For more details, please contact our support team.
                                    ''',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Close',
                                        style: GoogleFonts.poppins()),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.support, color: Colors.blue),
                          title: Text(
                            'Help & Support',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // Navigate to support page
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'App Version: 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
