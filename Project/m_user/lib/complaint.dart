import 'package:flutter/material.dart';

class ComplainPage extends StatefulWidget {
  final Map<String, dynamic>? product; // Optional product data if linked to a specific item

  const ComplainPage({super.key, this.product});

  @override
  _ComplainPageState createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedRating;

  // Sample rating options
  final List<Map<String, dynamic>> _ratingOptions = [
    {'value': '1', 'label': '1 Star'},
    {'value': '2', 'label': '2 Stars'},
    {'value': '3', 'label': '3 Stars'},
    {'value': '4', 'label': '4 Stars'},
    {'value': '5', 'label': '5 Stars'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      // Placeholder for submitting complaint data
      final complaintData = {
        'product_id': widget.product?['id'], // If linked to a product
        'title': _titleController.text,
        'description': _descriptionController.text,
        'rating': _selectedRating,
      };
      print("Complaint Submitted: $complaintData");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint submitted successfully!'),
          backgroundColor: Color(0xFF25A18B),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedRating = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color as requested
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "File a Complaint",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Info (if provided)
              if (widget.product != null) ...[
                Text(
                  "Product: ${widget.product!['food_name'] ?? 'Unknown'}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Complaint Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Complaint Title",
                  labelStyle: TextStyle(color: Colors.grey[800]),
                  prefixIcon: Icon(Icons.title, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF25A18B), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Complaint Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.grey[800]),
                  prefixIcon: Icon(Icons.description, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF25A18B), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

             
              SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF25A18B), // Button color as requested
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    elevation: 2,
                  ),
                  child: Text(
                    "Submit Complaint",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage in main.dart or another page
void main() {
  runApp(MaterialApp(
    home: ComplainPage(
      product: {'id': '1', 'food_name': 'Grilled Chicken'}, // Optional product data
    ),
  ));
}