import 'package:admin/screens/manage_food.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your screen components
import 'package:admin/dietplan.dart';
import 'package:admin/screens/diettype.dart';
import 'package:admin/screens/district.dart';
import 'package:admin/screens/add_food.dart';
import 'package:admin/screens/place.dart';
import 'package:admin/screens/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isSidebarCollapsed = false;

  // Page definitions
  final List<PageInfo> pages = [
    PageInfo(
      title: 'Profile',
      icon: Icons.account_circle_outlined,
      selectedIcon: Icons.account_circle,
      content: Profile(),
    ),
    PageInfo(
      title: 'District',
      icon: Icons.location_on_outlined,
      selectedIcon: Icons.location_on,
      content: Distrect(),
    ),
    PageInfo(
      title: 'Diet Type',
      icon: Icons.emoji_food_beverage_outlined,
      selectedIcon: Icons.emoji_food_beverage,
      content: Diettype(),
    ),
    PageInfo(
      title: 'Place',
      icon: Icons.location_city_outlined,
      selectedIcon: Icons.location_city,
      content: Place(),
    ),
    PageInfo(
      title: 'Diets',
      icon: Icons.no_food_outlined,
      selectedIcon: Icons.no_food,
      content: DitePlan(),
    ),
    PageInfo(
      title: 'Add Food',
      icon: Icons.fastfood_sharp,
      selectedIcon: Icons.food_bank,
      content: AddFood(),
    ),
    PageInfo(
      title: 'Manage Food',
      icon: Icons.food_bank_outlined,
      selectedIcon: Icons.food_bank,
      content: ManageFood(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  void _changePage(int index) {
    setState(() {
      selectedIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarCollapsed = !isSidebarCollapsed;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isSidebarCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and toggle button
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEEF2F6), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (!isSidebarCollapsed) ...[
                        Text(
                          "NutriAdmin",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A3547),
                          ),
                        ),
                        Spacer(),
                      ],
                      IconButton(
                        icon: Icon(
                          isSidebarCollapsed ? Icons.menu_open : Icons.menu,
                          color: Color(0xFF2A3547),
                        ),
                        onPressed: _toggleSidebar,
                      ),
                    ],
                  ),
                ),

                // Admin profile
                if (!isSidebarCollapsed)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF25A18B), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFF5F7FA),
                          child: Icon(Icons.person, color: Color(0xFF25A18B)),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Admin User",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2A3547),
                                ),
                              ),
                              Text(
                                "Administrator",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Color(0xFF7C8FAC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEEF2F6), width: 1),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFF5F7FA),
                      child: Icon(Icons.person, color: Color(0xFF25A18B)),
                    ),
                  ),

                // Navigation menu
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    children: [
                      if (!isSidebarCollapsed)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            "MENU",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7C8FAC),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      for (int index = 0; index < pages.length; index++)
                        _buildNavItem(index),
                    ],
                  ),
                ),

                // Logout button
                Container(
                  padding: EdgeInsets.all(isSidebarCollapsed ? 10 : 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFEEF2F6), width: 1),
                    ),
                  ),
                  child: isSidebarCollapsed
                      ? IconButton(
                          icon: Icon(Icons.logout, color: Colors.white),
                          onPressed: () {},
                        )
                      : ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.logout, color: Colors.white),
                          label: Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF25A18B),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        pages[selectedIndex].title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A3547),
                        ),
                      ),
                      Spacer(),
                      // IconButton(
                      //   icon: Icon(Icons.search, color: Color(0xFF7C8FAC)),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(Icons.notifications_none_outlined, color: Color(0xFF7C8FAC)),
                        onPressed: () {},
                        tooltip: "Notifications",
                      ),
                      SizedBox(width: 15),
                      IconButton(
                        icon: Icon(Icons.settings_outlined, color: Color(0xFF7C8FAC)),
                        onPressed: () {},
                        tooltip: "Settings",
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: pages[selectedIndex].content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = selectedIndex == index;
    final PageInfo page = pages[index];

    return InkWell(
      onTap: () => _changePage(index),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(
          horizontal: isSidebarCollapsed ? 10 : 15,
          vertical: 5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSidebarCollapsed ? 0 : 15,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(61, 37, 161, 138) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              isSelected ? page.selectedIcon : page.icon,
              color: isSelected ? Color(0xFF25A18B) : Color(0xFF7C8FAC),
              size: 22,
            ),
            if (!isSidebarCollapsed) ...[
              SizedBox(width: 15),
              Text(
                page.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Color(0xFF25A18B) : Color(0xFF7C8FAC),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Helper class to organize page information
class PageInfo {
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Widget content;

  PageInfo({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.content,
  });
}