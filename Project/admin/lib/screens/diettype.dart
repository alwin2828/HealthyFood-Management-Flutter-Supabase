import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Diettype extends StatefulWidget {
  const Diettype({super.key});

  @override
  State<Diettype> createState() => _DiettypeState();
}

class _DiettypeState extends State<Diettype> {
  TextEditingController diettype = TextEditingController();
  List<Map<String, dynamic>> fechdiettype = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> insert() async {
    try {
      await supabase.from("tbl_diettype").insert({"diettype_name": diettype.text});
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_diettype").select();
      setState(() {
        fechdiettype = response;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_diettype').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting: $e");
    }
  }

  int editId = 0;

  Future<void> update() async {
    try {
      await supabase.from("tbl_diettype").update({"diettype_name": diettype.text}).eq('id', editId);
      fetchdata();
      diettype.clear();
      setState(() {
        editId = 0;
      });
    } catch (e) {
      print("Error updating: $e");
    }
  }

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
            "Diet Type",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                TextField(
                  controller: diettype,
                  decoration: InputDecoration(
                    hintText: 'Enter diet type',
                    labelText: "Diet Type",
                    prefixIcon: Icon(Icons.restaurant_menu, color: Colors.teal),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (editId == 0) {
                        insert();
                      } else {
                        update();
                      }
                    },
                    child: Text("Submit", style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: fechdiettype.length,
              itemBuilder: (context, index) {
                final _diettype = fechdiettype[index];
                return ListTile(
                  leading: Icon(Icons.local_dining, color: Colors.teal),
                  title: Text(
                    _diettype['diettype_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => delete(_diettype['id']),
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            diettype.text = _diettype['diettype_name'];
                            editId = _diettype['id'];
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.teal),
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
