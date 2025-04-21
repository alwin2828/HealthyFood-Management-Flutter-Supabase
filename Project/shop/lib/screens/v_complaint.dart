import 'package:flutter/material.dart';
import 'package:shop/components/header.dart';
import 'package:shop/components/main_layout.dart';
import 'package:shop/main.dart';
import 'package:intl/intl.dart';

class ShopComplaintsPage extends StatefulWidget {
  
  const ShopComplaintsPage({super.key, });

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load complaints')));
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
    return MainLayout(
      currentPage: "Complaints",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: HeaderBar(
              title: 'View Complaints',
              subtitle: 'View all complaints for your shop',
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25A18B))))
              : complaints.isEmpty
                  ? Center(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.comment, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('No complaints available', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchComplaints,
                      color: const Color(0xFF25A18B),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = complaints[index];
                          final date = DateTime.parse(complaint['complaint_date'] ?? DateTime.now().toIso8601String());
                          final userId = complaint['user_id'] ?? 'Unknown User';

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xFF25A18B).withOpacity(0.1),
                                            child: const Icon(Icons.person, color: Color(0xFF25A18B)),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(userId, style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                        child: Text(
                                          complaint['complaint_status'] == '0' ? 'Pending' : 'Resolved',
                                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(DateFormat('MMM dd, yyyy • HH:mm').format(date), style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600])),
                                  const Divider(height: 24, thickness: 1),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      complaint['complaint_content'] ?? 'No content',
                                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                                    ),
                                  ),
                                  if (complaint['complaint_reply'] != null && complaint['complaint_reply'].isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        'Reply: ${complaint['complaint_reply']}',
                                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.blue[700]),
                                      ),
                                    ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final TextEditingController _replyController = TextEditingController();
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          title: Text(
                                            'Reply to Complaint #${complaint['id']}',
                                            style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2A3547)),
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
                                                style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF25A18B), fontSize: 16),
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
                                                backgroundColor: Color(0xFF25A18B),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                elevation: 4,
                                              ),
                                              child: Text(
                                                'Submit Reply',
                                                style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF25A18B),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 4,
                                    ),
                                    child: Text(
                                      'Reply',
                                      style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14),
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