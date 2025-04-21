import 'package:flutter/material.dart';
import 'package:shop/components/custom_appbar.dart';

import 'package:shop/screens/dashboard.dart';
import 'package:shop/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String dob = "";
  String gender = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  Future<void> update() async {
    try {
      await supabase.from('tbl_user').update({
        'user_name': nameController.text,
        'user_email': emailController.text,
        'user_dob': dobController.text,
        'user_contact': contactController.text,
      }).eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> fetchUser() async {
    try {
      String uid = Supabase.instance.client.auth.currentUser!.id;
      final response = await Supabase.instance.client
          .from("tbl_user")
          .select()
          .eq('id', uid)
          .single();
      setState(() {
        nameController.text = response['user_name'];
        emailController.text = response['user_email'];
        dobController.text = response['user_dob'];
        contactController.text = response['user_contact'];
        gender = response['user_gender'];
      });
    } catch (e) {
      print("User not found: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        showBackButton: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
        
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: SizedBox( 
                height: 600,            
                width: 500,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            nameController.text.isNotEmpty
                                ? nameController.text[0]
                                : "A",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildProfileField("Name", nameController, Icons.person, true),
                    buildProfileField("Mobile", contactController, Icons.phone, true),
                    buildProfileField("Email", emailController, Icons.email, false),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          prefixIcon: Icon(Icons.wc, color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: TextEditingController(text: gender),
                      ),
                    ),
                    buildDatePickerField("Date of Birth", dobController, Icons.cake),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        update();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25A18B),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Update Profile"),
                    ),
                    SizedBox(height: 20),
                     ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25A18B),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Change Password"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller,
      IconData icon, bool isEditable) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditable,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isEditable
              ? TextButton(
                  onPressed: () {},
                  child: Text("CHANGE", style: TextStyle(color: Colors.red)))
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget buildDatePickerField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              dob = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              controller.text = dob;
            });
          }
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
