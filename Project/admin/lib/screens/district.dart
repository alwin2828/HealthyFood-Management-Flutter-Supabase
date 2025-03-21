import 'package:admin/main.dart';
import 'package:flutter/material.dart';

class Distrect extends StatefulWidget {
  const Distrect({super.key});

  @override
  State<Distrect> createState() => _DistrectState();
}

class _DistrectState extends State<Distrect> {
  TextEditingController district = TextEditingController();
  List<Map<String, dynamic>> fechdistrict = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> insert() async {
    try {
      await supabase.from("tbl_district").insert({"district_name": district.text});
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        fechdistrict = response;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_district').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting: $e");
    }
  }

  int editId = 0;

  Future<void> update() async {
    try {
      await supabase.from("tbl_district").update({"district_name": district.text}).eq('id', editId);
      fetchdata();
      district.clear();
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
            "District",
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
                  controller: district,
                  decoration: InputDecoration(
                    hintText: 'Enter district',
                    labelText: "District",
                    prefixIcon: Icon(Icons.location_city, color: Colors.teal),
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
              itemCount: fechdistrict.length,
              itemBuilder: (context, index) {
                final _district = fechdistrict[index];
                return ListTile(
                  leading: Icon(Icons.location_city, color: Colors.teal),
                  title: Text(
                    _district['district_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => delete(_district['id']),
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            district.text = _district['district_name'];
                            editId = _district['id'];
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
