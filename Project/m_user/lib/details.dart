import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m_user/services/cart_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> food;

  const ProductDetailsPage({super.key, required this.food});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1; // State for quantity selector
  double averageRating = 0.0;
  int ratingCount = 0;
  int complaintCount = 3; // Example static complaint count, replace with dynamic data

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
  }

  Future<void> fetchAverageRating() async {
    final response = await Supabase.instance.client
        .from('tbl_review')
        .select('review_rating')
        .eq('food_id', widget.food['id']);

    if (response != null && response is List && response.isNotEmpty) {
      double total = 0;
      for (var row in response) {
        total += (row['review_rating'] ?? 0).toDouble();
      }
      setState(() {
        ratingCount = response.length;
        averageRating = total / ratingCount;
      });
    } else {
      setState(() {
        averageRating = 0.0;
        ratingCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Product Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.food['food_name'] ?? 'Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1), // Dynamic rating
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "$ratingCount ratings", // Dynamic
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: widget.food['food_photo'] ?? '',
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 200,
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bestseller and Rating
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_offer, size: 16, color: Colors.brown),
                                SizedBox(width: 4),
                                Text(
                                  "Bestseller",
                                  style: TextStyle(fontSize: 14, color: Colors.brown),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.orange),
                                SizedBox(width: 4),
                                Text(
                                  "$averageRating ($ratingCount)", // Dynamic rating
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Food Type
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.food['food_type'] == 'Veg' ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.food['food_type'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.food['food_type'] == 'Veg' ? Colors.green[800] : Colors.red[800],
                            ),
                          ),
                        ),
                      ),

                      // Price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "₹${widget.food['food_price']?.toString() ?? '0'}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          widget.food['food_description'] ?? 'No description available',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ),

                      // Cooking Request Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add a cooking request (optional)",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "e.g. Don't make it too spicy",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildOptionChip("Without onion and garlic"),
                                _buildOptionChip("Less Spicy"),
                                _buildOptionChip("Non spicy"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Rating Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Customer Ratings",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to detailed ratings page or show dialog
                                    _showRatingDialog(context);
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  "$averageRating / 5.0",
                                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "(Based on $ratingCount reviews)", // Dynamic
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Complaint Viewing Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Customer Complaints",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to detailed complaints page or show dialog
                                    _showComplaintDialog(context);
                                  },
                                  child: Text(
                                    "View Details",
                                    style: TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red[400], size: 20),
                                SizedBox(width: 4),
                                Text(
                                  "$complaintCount Complaints",
                                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "(Resolved: ${complaintCount - 1})", // Example
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quantity Selector and Add Button
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ItemService().addToitem(context, widget.food['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to cart, Check cart to place order'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF25A18B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "Add Item ₹${(widget.food['food_price'] ?? 0) * quantity}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (selected) {},
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.red[100],
      labelStyle: TextStyle(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Customer Ratings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 24),
                SizedBox(width: 8),
                Text(
                  "$averageRating / 5.0",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Based on $ratingCount reviews", // Dynamic
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Sample Review: 'Great taste, fast delivery!'", // Placeholder
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showComplaintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Customer Complaints"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red[400], size: 24),
                SizedBox(width: 8),
                Text(
                  "$complaintCount Complaints",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Resolved: ${complaintCount - 1}", // Example
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Sample Complaint: 'Food was cold on delivery.'", // Placeholder
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}