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
      print("inserted");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("inserted")));
    } catch (e) {
      print("error $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("error $e")));
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        fechdistrict = response;
      });
    } catch (e) {
      print("Error District $e");
    }
  }

  Future<void> fetchdatap() async {
    try {
      final response =
          await supabase.from("tbl_place").select('*,tbl_district(*)');
      print(response);
      setState(() {
        fechplace = response;
      });
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_place').delete().eq('id', id);
      fetchdata();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (e) {
      print("Error Deleting $e");
    }
  }

  String? selectedDist;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "District",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(255, 24, 157, 72),
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        value: selectedDist,
                        items: fechdistrict.map((district) {
                          return DropdownMenuItem(
                              value: district['id'].toString(),
                              child: Text(district['district_name']));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDist = value;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: placeController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 24, 157, 72)),
                        ),
                        hintText: 'Enter Your Place',
                        label: Text("Place"),
                        prefixIcon: Icon(Icons.location_city_rounded),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      insert();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25A18B)),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fechplace.length,
                itemBuilder: (context, index) {
                  final _PlaceState = fechplace[index];
                  return ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(
                        _PlaceState['place_name'],
                      ),
                      subtitle:
                          Text(_PlaceState['tbl_district']['district_name']),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  delete(_PlaceState['id']);
                                },
                                icon: Icon(Icons.delete_outline)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    // district.text=_district['district_name'];
                                    // editId=_district['id'];
                                  });
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
