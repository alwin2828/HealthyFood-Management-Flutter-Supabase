import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  // Mock order data
  final List<Map<String, dynamic>> orders = [
    {
      "orderId": "ORD001",
      "date": "2025-03-15",
      "status": "Delivered",
      "total": 25.98,
      "items": [
        {"name": "Grilled Chicken", "quantity": 2, "price": 12.99},
      ]
    },
    {
      "orderId": "ORD002",
      "date": "2025-03-14",
      "status": "Delivered",
      "total": 15.98,
      "items": [
        {"name": "Omelette", "quantity": 1, "price": 6.99},
        {"name": "Pancakes", "quantity": 1, "price": 8.99},
      ]
    },
    {
      "orderId": "ORD003",
      "date": "2025-03-13",
      "status": "Processing",
      "total": 12.99,
      "items": [
        {"name": "Grilled Chicken", "quantity": 1, "price": 12.99},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        // backgroundColor: Colors.green.shade200,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.green.shade200,
          //     Colors.white,
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
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
                "Order #${order['orderId']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order['status'] == "Delivered"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: order['status'] == "Delivered"
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
            "Date: ${order['date']}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          ...order['items'].map<Widget>((item) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item['quantity']} × ${item['name']}",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )),
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
                "\$${order['total'].toStringAsFixed(2)}",
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
            child: OutlinedButton(
              onPressed: () {
                // Handle reorder action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Reordering #${order['orderId']}...")),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Reorder",
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}