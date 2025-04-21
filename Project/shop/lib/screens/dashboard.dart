// dashboard.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/components/header.dart';
import 'package:shop/screens/add_employee.dart';
import 'package:shop/components/main_layout.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/my_profile.dart';
import 'package:shop/screens/view_orders.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const blackColor = Colors.black;
  static const accentColor = Color(0xFF25A18B);
  static const backgroundColor = Color(0xFFF5F7FA);

  List<Map<String, dynamic>> staffList = [];
  List<Map<String, dynamic>> orderList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStaffDetails();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await supabase
          .from('tbl_order')
          .select("*,tbl_user(*)")
          .eq('shop_id', supabase.auth.currentUser!.id)
          .eq('order_status', 1)
          .order('order_date', ascending: false)
          .limit(5);
      setState(() {
        orderList = response;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> _fetchStaffDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('tbl_staff').select();
      final List<Map<String, dynamic>> updatedStaffList = [];
      for (var staff in response) {
        final attendance = await supabase
            .from('tbl_attendence')
            .select()
            .eq('staff_id', staff['id'])
            .gte('attendence_date', '${DateTime.now().toUtc().toIso8601String().substring(0, 10)}T00:00:00Z')
            .lte('attendence_date', '${DateTime.now().toUtc().toIso8601String().substring(0, 10)}T23:59:59Z');
        staff['attendance'] = attendance.isNotEmpty;
        updatedStaffList.add(staff);
      }
      setState(() {
        staffList = updatedStaffList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching staff: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load staff details')));
    }
  }

  Future<void> markAttendance(dynamic staffId, bool isPresent) async {
    try {
      final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
      final validTimestamp = '$today 00:00:00Z';
      final staffIdString = staffId.toString();
      final attendance = await supabase
          .from('tbl_attendence')
          .select()
          .eq('staff_id', staffIdString)
          .eq('attendence_date', validTimestamp);
      if (attendance.isNotEmpty) {
        await supabase
            .from('tbl_attendence')
            .delete()
            .eq('staff_id', staffIdString)
            .eq('attendence_date', validTimestamp);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance removed successfully')));
      } else {
        await supabase.from('tbl_attendence').insert({'staff_id': staffIdString, 'attendence_date': validTimestamp});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance marked successfully')));
      }
      await _fetchStaffDetails();
    } catch (e) {
      print('Error marking attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update attendance')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: "Dashboard",
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderBar(title: 'Dashboard', subtitle: "Welcome back! Here's your overview"),
            const SizedBox(height: 20),
            _buildMetricsGrid(),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildStaffCard()),
                const SizedBox(width: 20),
                Expanded(child: _buildOrdersCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // _buildHeader, _buildMetricsGrid, _buildMetricCard, _buildStaffCard, _buildOrdersCard remain unchanged
  // Copy these methods from your original dashboard.dart as they are
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Welcome back! Here's your overview",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: blackColor),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Search functionality coming soon!')),
                  );
                },
                tooltip: 'Search',
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: accentColor,
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.white, size: 20),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProfile()),
                  ),
                  tooltip: 'Profile',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard("Total Staff", staffList.length.toString(),
            Icons.people, accentColor),
        _buildMetricCard(
            "Daily Revenue", "\$1,245", Icons.trending_up, Colors.green),
        _buildMetricCard("Pending Tasks", "8", Icons.task_alt, Colors.orange),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Staff Details",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEmployee()),
                ).then((_) => _fetchStaffDetails()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Add New",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: accentColor))
              : staffList.isEmpty
                  ? Center(
                      child: Text(
                        "No staff found",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: staffList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final staff = staffList[index];
                        bool attendanceExists = staff['attendance'] ?? false;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: staff['staff_photo'] != null
                                ? NetworkImage(staff['staff_photo'])
                                : null,
                            backgroundColor: staff['staff_photo'] == null
                                ? accentColor
                                : null,
                            child: staff['staff_photo'] == null
                                ? Text(
                                    staff['staff_name'][0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )
                                : null,
                          ),
                          title: Text(
                            staff['staff_name'],
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            staff['staff_email'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Switch(
                            value: attendanceExists,
                            onChanged: (value) async {
                              await markAttendance(staff['id'], value);
                            },
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  Widget _buildOrdersCard() {
    String _formatTimeAgo(DateTime orderDate) {
      final now = DateTime.now().toUtc(); // Use UTC to match timestampz
      final difference = now.difference(orderDate);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} seconds ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays > 1 && difference.inDays <= 7) {
        return '${difference.inDays} days ago';
      } else {
        // Fallback to full date (e.g., "2025-04-05")
        return orderDate.toLocal().toString().substring(0, 10);
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pending Orders",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              ElevatedButton(
               onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOrder(),));
               },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "View Orders",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orderList[index];
              String userName = order['tbl_user']['user_name'];
              final orderDate = DateTime.parse(order['order_date']).toUtc();
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag, color: accentColor),
                ),
                title: Text(
                  userName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _formatTimeAgo(orderDate),
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[600]),
                ),
                trailing: Text(
                  "Rs. ${order['order_amount']}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}