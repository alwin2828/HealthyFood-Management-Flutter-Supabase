import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopVerification extends StatefulWidget {
  const ShopVerification({super.key});

  @override
  State<ShopVerification> createState() => _ShopVerificationState();
}

class _ShopVerificationState extends State<ShopVerification> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<dynamic> pendingShops = [];
  List<dynamic> allShops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  

  // Fetch shops and categorize by shop_vstatus
  Future<void> fetchShops() async {
    try {
      final allResponse = await supabase.from('tbl_shop').select();
      final pendingResponse = await supabase.from('tbl_shop').select().eq('shop_vstatus', 0);

      print('All shops response: $allResponse');
      print('Pending shops response: $pendingResponse');

      if (allResponse.isNotEmpty && pendingResponse.isNotEmpty) {
        setState(() {
          allShops = allResponse;
          pendingShops = pendingResponse;
          isLoading = false;
        });
      } else {
        setState(() {
          allShops = allResponse;
          pendingShops = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No pending shops found. Total shops: ${allResponse.length}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print('Fetch error: $e');
    }
  }

  // Update shop_vstatus (1 for accepted, 2 for rejected)
  Future<void> updateShopStatus(String shopId, String status) async {
    try {
      final response = await supabase
          .from('tbl_shop')
          .update({'shop_vstatus': status})
          .eq('id', shopId);

      if (response.status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop ${status == '1' ? 'accepted' : 'rejected'} successfully')),
        );
        fetchShops();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: ${response.error?.message ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Calculate the number of shops by status
  int getAcceptedCount() => allShops.where((shop) => shop['shop_vstatus'] == '1' || shop['shop_vstatus'] == 1).length;
  int getRejectedCount() => allShops.where((shop) => shop['shop_vstatus'] == '2' || shop['shop_vstatus'] == 2).length;
  int getPendingCount() => pendingShops.length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shop Verification',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A3547),
            ),
          ),
          SizedBox(height: 20),
          // Enhanced cards for shop counts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Pending', getPendingCount(), Colors.orange, Icons.hourglass_empty),
              _buildStatCard('Accepted', getAcceptedCount(), Colors.green, Icons.check_circle),
              _buildStatCard('Rejected', getRejectedCount(), Colors.red, Icons.cancel),
            ],
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : pendingShops.isEmpty
                  ? Center(
                      child: Text(
                        'No shops pending verification',
                        style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF7C8FAC)),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: pendingShops.length,
                        itemBuilder: (context, index) {
                          final shop = pendingShops[index];
                          print('Rendering shop: $shop');
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(shop['shop_photo'] ?? ''),
                                        onBackgroundImageError: (exception, stackTrace) => Icon(Icons.error),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shop['shop_name'] ?? 'No Name',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF2A3547),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              shop['shop_email'] ?? 'No Email',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Color(0xFF7C8FAC),
                                              ),
                                            ),
                                            Text(
                                              shop['shop_contact'] ?? 'No Contact',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Color(0xFF7C8FAC),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Address: ${shop['shop_address'] ?? 'No Address'}',
                                    style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF2A3547)),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      if (shop['shop_license'] != null && shop['shop_license'].isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.network(shop['shop_license']),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('No license available')),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'View License',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color(0xFF25A18B),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => updateShopStatus(shop['id']?.toString() ?? '', '1'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF25A18B),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Accept',
                                          style: GoogleFonts.poppins(fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      OutlinedButton(
                                        onPressed: () => updateShopStatus(shop['id']?.toString() ?? '', '2'),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.red),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Reject',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
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

  // Enhanced stat card widget with icons
  Widget _buildStatCard(String title, int count, Color color, IconData icon) {
    return Container(
      width: 340, // Kept width at 140 as previously increased
      height: 150, // Kept height unchanged
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Vertical shadow
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3), width: 1), // Subtle border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30, // Added icon with a reasonable size
            color: color,
          ),
          SizedBox(height: 6), // Reduced height to fit icon
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          SizedBox(height: 6), // Reduced height to fit icon
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 4,
            width: 50, // Adjusted width of the strip to fit the larger card
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}