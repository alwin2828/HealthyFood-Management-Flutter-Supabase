import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/add_employee.dart';
import 'package:shop/my_profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const primaryColor = Color(0xFF2D3748);
  static const accentColor = Color(0xFF00BFA6);
  static const backgroundColor = Color(0xFFF7FAFC);
  static const cardColor = Colors.white;

  bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: accentColor,
            child: Icon(Icons.store, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            "Nutriq",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white70),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Colors.white70),
          onSelected: (value) {
            if (value == 'logout') {
              // Handle logout
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
              child: Text(
                'Profile',
                style: GoogleFonts.poppins(),
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text('Logout', style: GoogleFonts.poppins()),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _isSidebarExpanded ? 280 : 80,
      color: primaryColor,
      child: Column(
        children: [
          if (_isSidebarExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildSidebarItem(
                  "Overview",
                  Icons.dashboard,
                  isSelected: true,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  "Staff",
                  Icons.people,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  "Inventory",
                  Icons.inventory,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  "Reports",
                  Icons.analytics,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  "Settings",
                  Icons.settings,
                  onTap: () {},
                ),
              ],
            ),
          ),
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 22),
            if (_isSidebarExpanded) ...[
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dashboard Overview",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: primaryColor),
          onPressed: () {},
          tooltip: 'Filter',
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Row of small metric cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSmallMetricCard("Total Staff", "25", Icons.people, Colors.teal[100]!),
            _buildSmallMetricCard("Daily Sales", "\$1,245", Icons.attach_money, Colors.lime[100]!),
            _buildSmallMetricCard("Active Tasks", "8", Icons.task, Colors.amber[100]!),
          ],
        ),
        const SizedBox(height: 24),
        // Large cards
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildStaffListCard()),
              const SizedBox(width: 24),
              Expanded(child: _buildNewOrdersCard()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallMetricCard(String title, String value, IconData icon, Color bgColor) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffListCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Staff",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: GoogleFonts.poppins(
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Add_Employee()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(
                        "Add Staff",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => Divider(height: 20, color: Colors.grey[200]),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: accentColor,
                        child: Text(
                          "E${index + 1}",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Employee ${index + 1}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              "Active • Last seen: 2h ago",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewOrdersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Orders",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: GoogleFonts.poppins(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => Divider(height: 20, color: Colors.grey[200]),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shopping_cart, size: 20, color: primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${100 + index}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              "Placed: ${index + 1}h ago",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${(index + 1) * 50}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 