import 'package:flutter/material.dart';
import 'package:worker/dinein.dart';
import 'package:worker/login.dart';
import 'package:worker/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> orderList = [];
  List<bool> _isExpandedList = []; // Tracks expansion state for each order
  bool _isAvailable = false;
  String name = "";
  String imageUrl = "";

  getMessage<String>(int status){
    switch (status) {
      case 0:
        return 'Pending Order';
      case 1:
        return 'New Order';
      case 2:
        return 'Order Accepted';
      case 3:
        return 'Order Started Preparation';
      case 4:
        return 'Order Ready for Pickup';
      case 5:
        return 'Order Delivered';
      case 6:
        return 'Order Cancelled';
      default:
        return 'Unknown status';
    }
  }

  Future<void> _updateOrderStatus(int orderId, int status) async {
    try {
      await supabase.from('tbl_order').update({
        'order_status': status,
      }).eq('id', orderId);

      String message = getMessage(status); // Use the existing getMessage method
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );

      // Optionally refresh the order list after updating the status
      fetchOrders();
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update order status."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await supabase
          .from('tbl_staff')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      if (response.isNotEmpty) {
        final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
        final validTimestamp = '$today 00:00:00Z';
        final staffIdString = supabase.auth.currentUser!.id;
        final attendance = await supabase
            .from('tbl_attendence')
            .select()
            .eq('staff_id', staffIdString)
            .eq('attendence_date', validTimestamp);
        if (attendance.isNotEmpty) {
          final status = attendance[0]['attendence_status'];
          setState(() {
            _isAvailable = status;
          });
        } else {
          setState(() {
            _isAvailable = false;
          });
        }
        setState(() {
          name = response['staff_name'];
          imageUrl = response['staff_photo'] ?? "";
        });
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> fetchOrders() async {
    try {
      final worker = await supabase
          .from('tbl_staff')
          .select("shop_id")
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      final shopId = worker['shop_id'];

      // Get today's date in yyyy-MM-dd format
      final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);

      final response = await supabase
          .from('tbl_order')
          .select(
              "id,order_date,order_status,tbl_user(user_name),tbl_item(item_quantity,tbl_food(food_name,food_photo))")
          .eq('shop_id', shopId)
          .gte('order_status', 1)
          .gte('order_date', '$today 00:00:00')
          .lte('order_date', '$today 23:59:59')
          .order('order_date', ascending: false);

      print(response);
      setState(() {
        orderList = response;
        _isExpandedList =
            List.filled(orderList.length, false); // Initialize expansion state
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B82F6); // Blue
    const secondaryColor = Color(0xFF10B981); // Green
    const backgroundColor = Color(0xFFF9FAFB);
    const cardColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              supabase.auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false,
                );
              }).catchError((error) {
                print("Error signing out: $error");
              });
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  imageUrl == ""
                      ? CircleAvatar(
                          radius: 20,
                          child: Text(name.isNotEmpty ? name[0] : "U"),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isAvailable ? secondaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isAvailable ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    "Today's Orders",
                    "12",
                    Icons.shopping_bag_outlined,
                    primaryColor,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    "Completed",
                    "8",
                    Icons.check_circle_outline,
                    secondaryColor,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    "Pending",
                    "4",
                    Icons.pending_outlined,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Orders",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  final order = orderList[index];
                  final items = orderList[index]['tbl_item'];
                  final isExpanded = _isExpandedList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.fastfood,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order #${1000 + order['id']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      order['tbl_user']['user_name'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Colors.orange.withOpacity(0.1)
                                          : secondaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      getMessage(order['order_status']),
                                      style: TextStyle(
                                        color: order['order_status'] == 1
                                            ? Colors.orange
                                            : order['order_status'] == 2
                                                ? Colors.blue
                                                : order['order_status'] == 3
                                                    ? Colors.amber
                                                    : order['order_status'] == 4
                                                        ? secondaryColor
                                                        : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "10:${30 + index} AM",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          // Conditionally show food details based on isExpanded
                          if (isExpanded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Food Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...items.map<Widget>((item) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        item['tbl_food']['food_photo'],
                                      ),
                                    ),
                                    title: Text(
                                      item['tbl_food']['food_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Quantity: ${item['item_quantity']}",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                              ],
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isExpandedList[index] =
                                          !_isExpandedList[index];
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF25A18B),
                                    side: const BorderSide(
                                        color: Color(0xFF25A18B)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(isExpanded
                                      ? "Hide Details"
                                      : "View Details"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              order['order_status'] <= 4 ? Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Change function based on status
                                    if (order['order_status'] == 1) {
                                      _updateOrderStatus(order['id'], 2); // Accept Order
                                    } else if (order['order_status'] == 2) {
                                      _updateOrderStatus(order['id'], 3); // Start Preparation
                                    } else if (order['order_status'] == 3) {
                                      _updateOrderStatus(order['id'], 4); // Ready for Pickup
                                    } else if (order['order_status'] == 4) {
                                      _updateOrderStatus(order['id'], 5); // Order Picked Up
                                    } 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25A18B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    order['order_status'] == 1
                                        ? "Accept Order"
                                        : order['order_status'] == 2
                                            ? "Start Preparation"
                                            : order['order_status'] == 3
                                                ? "Ready for Pickup"
                                                : order['order_status'] == 4
                                                    ? "Order Picked Up"
                                                    : "Manage Order",
                                  ),
                                ),
                              ) : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DineIn(),
            ),
          );
        },
        backgroundColor: const Color(0xFF25A18B),
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
