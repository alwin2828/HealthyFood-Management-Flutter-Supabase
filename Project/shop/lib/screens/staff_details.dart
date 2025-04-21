// staff_details.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop/components/header.dart';
import 'package:shop/components/main_layout.dart';
import 'package:shop/main.dart';

class StaffDetails extends StatefulWidget {
  const StaffDetails({super.key});

  @override
  State<StaffDetails> createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  List<Map<String, dynamic>> staffList = [];
  bool _isLoading = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchStaffAttendance(selectedDate);
  }

  Future<void> fetchStaffAttendance(DateTime date) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final staffResponse = await supabase
          .from('tbl_staff')
          .select('id, staff_name, staff_email')
          .eq('shop_id', supabase.auth.currentUser!.id);
      final List<Map<String, dynamic>> updatedStaffList = [];
      final dateString = date.toUtc().toIso8601String().substring(0, 10);
      final startOfDay = '$dateString 00:00:00Z';
      final endOfDay = '$dateString 23:59:59Z';
      for (var staff in staffResponse) {
        final attendance = await supabase
            .from('tbl_attendence')
            .select()
            .eq('staff_id', staff['id'].toString())
            .gte('created_at', startOfDay)
            .lte('created_at', endOfDay);
        staff['isPresent'] = attendance.isNotEmpty;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF25A18B), onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await fetchStaffAttendance(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: "Staff",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: HeaderBar(title: 'Staff Details', subtitle: "Manage your staff attendance"),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${selectedDate.toLocal().toString().substring(0, 10)}',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF25A18B), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '${staffList.where((staff) => staff['isPresent']).length} Present',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25A18B))))
                : staffList.isEmpty
                    ? Center(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text('No staff found for this date', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
                          ),
                        ),
                      )
                    : ListView.builder(
                      shrinkWrap: true,
                        itemCount: staffList.length,
                        itemBuilder: (context, index) {
                          final staff = staffList[index];
                          final isPresent = staff['isPresent'] ?? false;
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                child: Icon(Icons.person, color: isPresent ? Colors.green : Colors.red),
                              ),
                              title: Text(staff['staff_name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(staff['staff_email'], style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isPresent ? 'Present' : 'Absent',
                                  style: GoogleFonts.poppins(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.w500),
                                ),
                              ),
                              onTap: () => _showAttendanceHistory(context, staff),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // _showAttendanceHistory remains unchanged
  Future<void> _showAttendanceHistory(BuildContext context, Map<String, dynamic> staff) async {  }
}