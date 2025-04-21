import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopComplaintsPage extends StatefulWidget {
  const ShopComplaintsPage({super.key});

  @override
  State<ShopComplaintsPage> createState() => _ShopComplaintsPageState();
}

class _ShopComplaintsPageState extends State<ShopComplaintsPage> {
  List<Map<String, dynamic>> complaints = [];
  bool _isLoading = true;

  Future<void> fetchComplaints() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await supabase
          .from('tbl_complaint')
          .select('*')
          .eq('shop_id', supabase.auth.currentUser!.id)
          .eq('complaint_status', '0')
          .order('complaint_date', ascending: false);
      setState(() {
        complaints = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching complaints: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load complaints')),
      );
    }
  }

  Future<void> updateReply(int complaintId, String reply) async {
    try {
      await supabase
          .from('tbl_complaint')
          .update({'complaint_reply': reply}).eq('id', complaintId);
      fetchComplaints(); // Refresh the list after update
    } catch (e) {
      print('Error updating reply: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update reply: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Complaints',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2A3547),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : complaints.isEmpty
                  ? Center(
                      child: Text(
                        'No pending complaints found',
                        style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF7C8FAC)),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = complaints[index];
                          final date = DateTime.parse(complaint['complaint_date'] ?? DateTime.now().toIso8601String());
                          final userId = complaint['user_id'] ?? 'Unknown User';

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color(0xFF25A18B).withOpacity(0.1),
                                        child: const Icon(Icons.person, color: Color(0xFF25A18B)),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Complaint #${complaint['id']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2A3547),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'User: $userId',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: const Color(0xFF7C8FAC),
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MMM dd, yyyy • HH:mm').format(date),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: const Color(0xFF7C8FAC),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Content: ${complaint['complaint_content'] ?? 'No content'}',
                                    style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF2A3547)),
                                  ),
                                  if (complaint['complaint_reply'] != null && complaint['complaint_reply'].isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Reply: ${complaint['complaint_reply']}',
                                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue[700]),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      final TextEditingController _replyController = TextEditingController();
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          title: Text(
                                            'Reply to Complaint #${complaint['id']}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF2A3547),
                                            ),
                                          ),
                                          content: Container(
                                            padding: const EdgeInsets.all(16),
                                            width: 300,
                                            height: 150,
                                            child: TextField(
                                              controller: _replyController,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                hintText: 'Enter your reply here',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                                ),
                                                filled: true,
                                                fillColor: Colors.grey.shade50,
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(
                                                'Cancel',
                                                style: GoogleFonts.poppins(color: const Color(0xFF25A18B), fontSize: 16),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                String reply = _replyController.text.trim();
                                                if (reply.isNotEmpty) {
                                                  await updateReply(complaint['id'], reply);
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF25A18B),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                elevation: 4,
                                              ),
                                              child: Text(
                                                'Submit Reply',
                                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25A18B),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 4,
                                    ),
                                    child: Text(
                                      'Reply',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}