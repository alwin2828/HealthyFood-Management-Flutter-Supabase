import 'package:admin/main.dart';
import 'package:flutter/material.dart';

class ManageFood extends StatefulWidget {
  const ManageFood({super.key});

  @override
  State<ManageFood> createState() => _ManageFoodState();
}

class _ManageFoodState extends State<ManageFood> {
  List<Map<String, dynamic>> fechfood = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_food").select();
      setState(() {
        fechfood = response;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_food').delete().eq('id', id);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted")));
      fetchdata();
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  String? selectedtype;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Food",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: fechfood.length,
              itemBuilder: (context, index) {
                final _food = fechfood[index];
                print('Food photo path: ${_food['food_photo']}'); // Debug
                return Card(
                  elevation: 4,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            _food['food_photo'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: $error');
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.fastfood, size: 50),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _food['food_name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              _food['food_description'],
                              style: TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _food['food_type'] == 'Veg'
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _food['food_type'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _food['food_type'] == 'Veg'
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                    ),
                                  ),
                                ),
                                Text(
                                  _food['food_price'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => delete(_food['id']),
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit, color: Colors.teal),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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