// view_orders.dart
import 'package:flutter/material.dart';
import 'package:shop/components/header.dart';
import 'package:shop/components/main_layout.dart';
import 'package:shop/main.dart';
import 'package:intl/intl.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrder> {
  List<Map<String, dynamic>> orderList = [];
  bool _isLoading = true;

  Future<void> fetchOrders() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await supabase
          .from('tbl_order')
          .select("*,tbl_user(*),tbl_item(*,tbl_food(*))")
          .eq('order_status', 1)
          .eq('shop_id', supabase.auth.currentUser!.id);
      setState(() {
        orderList = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load orders')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: "Orders",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: HeaderBar(title:'View Order', subtitle: " View all orders placed by customers"),
          ),
          
          _isLoading
              ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25A18B))))
              : orderList.isEmpty
                  ? Center(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('No orders available', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchOrders,
                      color: const Color(0xFF25A18B),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          final order = orderList[index];
                          final items = List.from(order['tbl_item']);
                          final username = order['tbl_user']['user_name'] ?? 'Unknown User';
                          final date = DateTime.tryParse(order['order_date']?.toString() ?? '') ?? DateTime.now();
                          final amount = (order['order_amount'] as num?)?.toDouble() ?? 0.0;
          
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
                                          Text(username, style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                        child: Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green[700])),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(DateFormat('MMM dd, yyyy • HH:mm').format(date), style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600])),
                                  const Divider(height: 24, thickness: 1),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    itemBuilder: (context, itemIndex) {
                                      final item = items[itemIndex];
                                      final food = item['tbl_food'];
                                      final quantity = (item['item_quantity'] as num?)?.toInt() ?? 0;
                                      final price = (food['food_price'] as num?)?.toDouble() ?? 0.0;
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(color: const Color(0xFF25A18B).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                              child: Text('${quantity}×', style: TextStyle(color: const Color(0xFF25A18B), fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(food['food_name'] ?? 'Unnamed Item', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                                                  const SizedBox(height: 4),
                                                  Text('${food['food_type'] ?? ''} - ${food['food_description'] ?? ''}', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey[600])),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('\$${(price * quantity).toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                                          ],
                                        ),
                                      );
                                    },
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