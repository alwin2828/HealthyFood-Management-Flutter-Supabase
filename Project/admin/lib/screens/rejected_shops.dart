import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RejectedShops extends StatefulWidget {
  const RejectedShops({super.key});

  @override
  State<RejectedShops> createState() => _RejectedShopsState();
}

class _RejectedShopsState extends State<RejectedShops> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> rejectedShops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    try {
      final response = await supabase.from('tbl_shop').select().eq('shop_vstatus', '2');
      print('Rejected shops response: $response');
      setState(() {
        rejectedShops = response;
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rejected Shops',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A3547),
            ),
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : rejectedShops.isEmpty
                  ? Center(
                      child: Text(
                        'No rejected shops found',
                        style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF7C8FAC)),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: rejectedShops.length,
                        itemBuilder: (context, index) {
                          final shop = rejectedShops[index];
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