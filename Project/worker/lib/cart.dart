import 'package:flutter/material.dart';
import 'package:worker/main.dart';

class Cart extends StatefulWidget {
  final List<int> food;
  const Cart({super.key, required this.food});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  Map<int, int> quantities = {}; // foodId -> quantity

  double get totalAmount {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['food_price'] ?? 0.0) * (quantities[item['id']] ?? 1)),
    );
  }

  Future<void> proceed() async {
    try {
      final staff = await supabase
          .from("tbl_staff")
          .select('shop_id')
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      final shopId = staff['shop_id'];
      final response = await supabase
          .from('tbl_order')
          .insert({'shop_id': shopId})
          .select()
          .single();
      final orderId = response['id'];

      // Insert each food item and its quantity into tbl_item
      for (var entry in quantities.entries) {
        await supabase.from('tbl_item').insert({
          'order_id': orderId,
          'food_id': entry.key,
          'item_quantity': entry.value,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      // Optionally, clear cart or navigate away
    } catch (e) {
      print('Error proceeding to checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    }
  }

  Future<void> fetchCartItems() async {
    try {
      if (widget.food.isEmpty) {
        setState(() {
          cartItems = [];
        });
        return;
      }
      final response = await supabase
          .from('tbl_food')
          .select()
          .inFilter('id', widget.food);

      setState(() {
        cartItems = List<Map<String, dynamic>>.from(response);
        for (var item in cartItems) {
          quantities[item['id']] ??= 1; // Default quantity is 1
        }
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void updateQuantity(int foodId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        quantities.remove(foodId);
        cartItems.removeWhere((item) => item['id'] == foodId);
      } else {
        quantities[foodId] = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: cartItems.isEmpty
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
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(cartItems[index]);
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
                              "₹${totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
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
                            onPressed: proceed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25A18B),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Confirm Order",
                              style: TextStyle(
                                fontSize: 18,
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
    final foodId = item['id'];
    final quantity = quantities[foodId] ?? 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              item['food_photo'] ?? '',
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
                  item['food_name'] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${(item['food_price'] ?? 0.0).toStringAsFixed(2)}",
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
                onPressed: () {
                  updateQuantity(foodId, quantity - 1);
                },
                icon: Icon(Icons.remove_circle, color: Colors.green.shade400),
              ),
              Text(
                "$quantity",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  updateQuantity(foodId, quantity + 1);
                },
                icon: Icon(Icons.add_circle, color: Colors.green.shade400),
              ),
              IconButton(
                onPressed: () {
                  updateQuantity(foodId, 0);
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