import 'package:flutter/material.dart';
import 'package:m_user/main.dart';
import 'package:m_user/payment.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> orderItems = [];

  double get totalAmount {
    return orderItems.fold(
      0.0, // Changed to 0.0 for double type consistency
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
          .maybeSingle().limit(1);

      if (response != null) {
        final items = response['tbl_item'] as List<dynamic>? ?? [];
        List<Map<String, dynamic>> cartItems = [];
        for (var item in items) {
          cartItems.add({
            "id": item['id'],
            "name": item['tbl_food']['food_name'] ?? "",
            "price": item['tbl_food']['food_price']?.toDouble() ?? 0.0, // Ensure double type
            "quantity": item['item_quantity'] ?? 0,
            "image": item['tbl_food']['food_photo'],
          });
        }

        print(cartItems);
        setState(() {
          orderItems = cartItems;
          bid = response['id'];
        });
      } else {
        print('No cart items found.');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await supabase.from('tbl_item').delete().eq('id', id);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Deleted")));
      await fetchCartItems(); // Added await for consistency
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await delete(itemId); // Delete if quantity is 0 or less
      } else {
        await supabase
            .from('tbl_item')
            .update({'item_quantity': newQuantity})
            .eq('id', itemId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Quantity updated to $newQuantity")),
        );
      }
      await fetchCartItems(); // Refresh cart
    } catch (e) {
      print('Error updating quantity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating quantity")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: orderItems.isEmpty
          ? const Center(
              child: Text("No items in the cart"),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16), // Fixed 'Heathrow' typo
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(orderItems[index]);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${totalAmount.toStringAsFixed(2)}", // Fixed currency symbol
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentGatewayScreen(
                                    id: bid,
                                    amt: totalAmount.toInt(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25A18B),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
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
      margin: const EdgeInsets.only(bottom: 8), // Fixed 'bottom' instead of 'custom'
      padding: const EdgeInsets.all(12),
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
              item['image'] ?? '', // Added null check
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${item['price'].toStringAsFixed(2)}", // Fixed price formatting
                  style: const TextStyle(
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
                onPressed: () async {
                  final newQuantity = (item['quantity'] as int) - 1;
                  await updateQuantity(item['id'].toString(), newQuantity);
                },
                icon: Icon(Icons.remove_circle, color: Colors.green.shade400),
              ),
              Text(
                "${item['quantity']}",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () async {
                  final newQuantity = (item['quantity'] as int) + 1;
                  await updateQuantity(item['id'].toString(), newQuantity);
                },
                icon: Icon(Icons.add_circle, color: Colors.green.shade400),
              ),
              IconButton(
                onPressed: () {
                  delete(item['id'].toString());
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}