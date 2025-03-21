import 'package:admin/main.dart';
import 'package:flutter/material.dart';

class Place extends StatefulWidget {
  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  TextEditingController placeController = TextEditingController();
  List<Map<String, dynamic>> fechdistrict = [];
  List<Map<String, dynamic>> fechplace = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
    fetchdatap();
  }

  Future<void> insert() async {
    try {
      await supabase.from("tbl_place").insert(
          {"place_name": placeController.text, "district_id": selectedDist});

      fetchdata();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        fechdistrict = response;
      });
    } catch (e) {
      print("Error fetching districts: $e");
    }
  }

  Future<void> fetchdatap() async {
    try {
      final response =
          await supabase.from("tbl_place").select('*,tbl_district(*)');
      setState(() {
        fechplace = response;
      });
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_place').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error deleting: $e");
    }
  }

  String? selectedDist;

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
                DropdownButtonFormField(
                  value: selectedDist,
                  items: fechdistrict.map((district) {
                    return DropdownMenuItem(
                      value: district['id'].toString(),
                      child: Text(district['district_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDist = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Select District",
                    prefixIcon: Icon(Icons.map, color: Colors.teal),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: placeController,
                  decoration: InputDecoration(
                    hintText: 'Enter place name',
                    labelText: "Place",
                    prefixIcon: Icon(Icons.location_city_rounded, color: Colors.teal),
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
                      insert();
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
              itemCount: fechplace.length,
              itemBuilder: (context, index) {
                final _place = fechplace[index];
                return ListTile(
                  leading: Icon(Icons.place, color: Colors.teal),
                  title: Text(
                    _place['place_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(_place['tbl_district']['district_name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => delete(_place['id']),
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            placeController.text = _place['place_name'];
                            selectedDist = _place['tbl_district']['id'].toString();
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
