import 'package:flutter/material.dart';
import 'package:m_user/main.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, dynamic>> orders = [];

  Future<void> fetchOrders() async {
    try {
      final respose = await supabase
          .from('tbl_order')
          .select("*,tbl_item(*,tbl_food(*))")
          .eq('user_id', supabase.auth.currentUser!.id);
      setState(() {
        orders = respose;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("My Orders"),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No Orders Yet",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(orders[index]);
                },
              ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    print(order);
    final items = order['tbl_item'] as List<dynamic>;

    String getStatusText(int status) {
      switch (status) {
        case 0:
          return "Pending";
        case 1:
          return "Processing";
        case 2:
          return "Delivered";
        default:
          return "Unknown";
      }
    }

    double calculateTotal() {
      return items.fold(0.0, (sum, item) {
        final food = item['tbl_food'];
        return sum + (food['food_price'] * item['item_quantity']);
      });
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
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
                "Order #${order['id']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order['order_status'] == 2
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getStatusText(order['order_status']),
                  style: TextStyle(
                    color: order['order_status'] == 2
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Date: ${DateTime.parse(order['order_date']).toLocal().toString().split('.')[0]}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          ...items.map<Widget>((item) {
            final food = item['tbl_food'];
            return Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item['item_quantity']} × ${food['food_name']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "\$${(food['food_price'] * item['item_quantity']).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${food['food_type']} - ${food['food_description']}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${calculateTotal().toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final TextEditingController _complaintController =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 8,
                          title: Text(
                            'Post Complaint for Order #${order['id']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A3547),
                            ),
                          ),
                          content: Container(
                            padding: EdgeInsets.all(16),
                            width: 300,
                            height: 200,
                            child: TextField(
                              controller: _complaintController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Enter your complaint here',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
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
                                style: TextStyle(
                                  color: Color(0xFF25A18B),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String complaint =
                                    _complaintController.text.trim();
                                if (complaint.isNotEmpty) {
                                  await supabase.from('tbl_complaint').insert({
                                    'shop_id': order['shop_id'],
                                    'complaint_content': complaint,
                                    'user_id': supabase.auth.currentUser!.id,
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Complaint submitted for Order #${order['id']}')),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF25A18B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report_problem,
                          color: Colors.red.shade400,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Complaint",
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      int selectedRating = 0;
                      final TextEditingController _ratingCommentController =
                          TextEditingController();
                      final items = order['tbl_item'] as List<dynamic>;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 8,
                              title: Text(
                                'Rate Order #${order['id']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2A3547),
                                ),
                              ),
                              content: Container(
                                padding: EdgeInsets.all(16),
                                width: 300,
                                height: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        return IconButton(
                                          icon: Icon(
                                            Icons.star,
                                            color: index < selectedRating
                                                ? Colors.orange
                                                : Colors.grey,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedRating = index + 1;
                                            });
                                          },
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      selectedRating == 1
                                          ? '😞'
                                          : selectedRating == 2
                                              ? '🙁'
                                              : selectedRating == 3
                                                  ? '😐'
                                                  : selectedRating == 4
                                                      ? '🙂'
                                                      : selectedRating == 5
                                                          ? '😊'
                                                          : '',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: _ratingCommentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment (optional)',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFF25A18B),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: selectedRating == 0
                                      ? null
                                      : () async {
                                          String comment =
                                              _ratingCommentController.text
                                                  .trim();
                                          try {
                                            // Insert rating for each food in the order
                                            for (var item in items) {
                                              await supabase
                                                  .from('tbl_review')
                                                  .insert({
                                                'food_id': item['tbl_food']
                                                    ['id'],
                                                'review_rating': selectedRating,
                                                'review_content':
                                                    comment.isEmpty
                                                        ? null
                                                        : comment,
                                                'user_id': supabase
                                                    .auth.currentUser!.id,
                                                
                                                'review_date': DateTime.now()
                                                    .toUtc()
                                                    .toIso8601String(), // Add timestamp
                                              });
                                            }
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Rating submitted for Order #${order['id']}')),
                                            );
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            print(
                                                'Error submitting review: $e');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to submit rating: $e')),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF25A18B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange.shade400,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Rating",
                          style: TextStyle(
                            color: Colors.orange.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
}
