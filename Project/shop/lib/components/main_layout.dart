// main_layout.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/screens/dashboard.dart';
import 'package:shop/screens/my_profile.dart';
import 'package:shop/screens/staff_details.dart';
import 'package:shop/screens/v_complaint.dart';
import 'package:shop/screens/view_orders.dart';
import 'package:shop/screens/settings.dart'; // Add this import

class MainLayout extends StatefulWidget {
  final Widget content;
  final String currentPage;

  const MainLayout({super.key, required this.content, required this.currentPage});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const primaryColor = Colors.white70;
  static const blackColor = Colors.black;
  static const accentColor = Color(0xFF25A18B);
  bool isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSidebar(),
          Expanded(child: SingleChildScrollView(child: widget.content)),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSidebarExpanded ? 260 : 80,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // child: const Icon(Icons.store, color: Colors.white), // Added icon
                ),
                if (isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    "Nutri-Q",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: Column(
              children: [
                _buildSidebarItem("Dashboard", Icons.dashboard, onTap: () {
                  if (widget.currentPage != "Dashboard") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                  }
                }, isSelected: widget.currentPage == "Dashboard"),
                _buildSidebarItem("Staff", Icons.people, onTap: () {
                  if (widget.currentPage != "Staff") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StaffDetails()));
                  }
                }, isSelected: widget.currentPage == "Staff"),
                _buildSidebarItem("Orders", Icons.shopping_bag, onTap: () {
                  if (widget.currentPage != "Orders") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ViewOrder()));
                  }
                }, isSelected: widget.currentPage == "Orders"),
                _buildSidebarItem("Inventory", Icons.inventory),
                _buildSidebarItem("Complaints", Icons.report, onTap: () {
                  if (widget.currentPage != "Complaints") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ShopComplaintsPage()));
                  }
                }, isSelected: widget.currentPage == "Complaints"),
                
                
                _buildSidebarItem("Settings", Icons.settings, onTap: () {
                  if (widget.currentPage != "Settings") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Settings()));
                  }
                }, isSelected: widget.currentPage == "Settings"),
              ],
            ),
          ),
          // Footer
          _buildSidebarItem("Logout", Icons.logout, onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
          }),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, {VoidCallback? onTap, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isSelected ? accentColor : blackColor),
        title: isSidebarExpanded
            ? Text(
                title,
                style: GoogleFonts.poppins(
                  color: isSelected ? accentColor : blackColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              )
            : null,
        tileColor: isSelected ? Colors.white.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}