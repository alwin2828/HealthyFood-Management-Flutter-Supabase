import 'package:flutter/material.dart';
import 'package:m_user/main.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // Mock cart items
  List<Map<String, dynamic>> orderItems = [];

  double get totalAmount {
    return orderItems.fold(
      0,
      (sum, item) => sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 0)),
    );
  }

  int bid = 0;

  Future<void> fetchCartItems() async {
    try {
      final response = await supabase
          .from('tbl_order')
          .select("*, tbl_item(*,tbl_food(*))")
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('order_status', 0)
          .maybeSingle();

      if (response != null) {
        final items = response['tbl_item'] as List<dynamic>? ?? [];
        List<Map<String, dynamic>> cartItems = [];
        for (var item in items) {
          cartItems.add({
            "id": item['id'],
            "name": item['tbl_food']['food_name'] ?? "",
            "price":
                item['tbl_food']['food_price'], // Default to 0.0 if null
            "quantity": item['item_quantity'] ?? 0, // Default to 0 if null
            "image": item['tbl_food']['food_photo'],
          });
        }
        print(cartItems);
        setState(() {
          orderItems = cartItems;
          // bid = response['id'];
        });
      } else {
        print('No cart items found.');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        // backgroundColor: Colors.green.shade200,
        elevation: 0,
      ),
      body: orderItems.isEmpty
          ? Center(
              child: Text("No items in the cart"),
            )
          : Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [
              //       Colors.green.shade200,
              //       Colors.white,
              //     ],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ),
              // ),
              child: Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(orderItems[index]);
                      },
                    ),
                  ),
                  // Total and Checkout Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\₹${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle checkout action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Proceeding to checkout...")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF25A18B),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
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

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "₹.${item['price']}",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (item['quantity'] > 1) item['quantity']--;
                  });
                },
                icon: Icon(Icons.remove_circle, color: Colors.green.shade400),
              ),
              Text(
                "${item['quantity']}",
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    item['quantity']++;
                  });
                },
                icon: Icon(Icons.add_circle, color: Colors.green.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
