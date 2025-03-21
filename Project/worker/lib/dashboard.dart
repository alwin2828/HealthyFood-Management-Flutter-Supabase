import 'package:flutter/material.dart';
import 'package:worker/view_details.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final mockOrder = {
  'id': 'ORD123456',
  'date': 'March 19, 2025',
  'time': '2:30 PM',
  'status': 'In Progress',
  'items': [
    {
      'name': 'Margherita Pizza',
      'quantity': 2,
      'price': 24.99,
      'options': 'Extra cheese, No basil',
    },
    {
      'name': 'Pepperoni Pizza',
      'quantity': 1,
      'price': 14.99,
      'options': 'Thin crust',
    },
    {
      'name': 'Garlic Bread',
      'quantity': 1,
      'price': 5.99,
    },
  ],
  'total': 65.97,
  'subtotal': 58.97,
  'tax': 4.00,
  'deliveryFee': 3.00,
  'paymentMethod': 'Credit Card',
  'orderType': 'Delivery',
  'customer': {
    'name': 'John Doe',
    'initials': 'JD',
    'phone': '+1 (555) 123-4567',
    'address': '123 Main Street, Apt 4B, New York, NY 10001',
  },
};
  // int _selectedIndex = 0;
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    // Theme colors
    const primaryColor = Color(0xFF3B82F6); // Blue
    const secondaryColor = Color(0xFF10B981); // Green
    const backgroundColor = Color(0xFFF9FAFB);
    const cardColor = Colors.white;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: secondaryColor ,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: const AssetImage('assets/restaurant.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                              _isAvailable ? "Available" : "Unavailable",
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
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeColor: secondaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Stats Section
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
            
            // New Orders Section
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
            
            // Orders List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
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
                                      "Order #${1000 + index}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Customer: Alex Johnson",
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
                                      index % 2 == 0 ? "New" : "Ready",
                                      style: TextStyle(
                                        color: index % 2 == 0
                                            ? Colors.orange
                                            : secondaryColor,
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
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetailsView(order: mockOrder,),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF25A18B),
                                    side: BorderSide(color: Color(0xFF25A18B)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("View Details"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF25A18B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Accept Order"),
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
            
            // Bottom Navigation
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
              // child: BottomNavigationBar(
              //   currentIndex: _selectedIndex,
              //   onTap: (index) {
              //     setState(() {
              //       _selectedIndex = index;
              //     });
              //   },
              //   selectedItemColor: primaryColor,
              //   unselectedItemColor: Colors.grey,
              //   showUnselectedLabels: true,
              //   type: BottomNavigationBarType.fixed,
              //   items: const [
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.dashboard_outlined),
              //       activeIcon: Icon(Icons.dashboard),
              //       label: 'Dashboard',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.list_alt_outlined),
              //       activeIcon: Icon(Icons.list_alt),
              //       label: 'Orders',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.history_outlined),
              //       activeIcon: Icon(Icons.history),
              //       label: 'History',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.person_outline),
              //       activeIcon: Icon(Icons.person),
              //       label: 'Profile',
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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

