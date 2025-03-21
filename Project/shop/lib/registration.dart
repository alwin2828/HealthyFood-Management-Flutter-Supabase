import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shop/components/custom_textfield.dart';
import 'package:shop/login.dart';
import 'package:shop/main.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  PlatformFile? pickedImage;
  PlatformFile? pickedLicense;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _cnum = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _photo = TextEditingController();
  final TextEditingController _license = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();

  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
        _photo.text = pickedImage!.name;
      });
    }
  }

  Future<void> handleProofPick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedLicense = result.files.first;
        _license.text = pickedLicense!.name;
      });
    }
  }

  Future<String?> uploadFile(PlatformFile? file, String prefix, String uid) async {
    if (file == null) return null;
    try {
      final filePath = "$prefix-$uid-${file.name}";
      await supabase.storage.from('shop').uploadBinary(filePath, file.bytes!);
      return supabase.storage.from('shop').getPublicUrl(filePath);
    } catch (e) {
      print("Error uploading $prefix: $e");
      return null;
    }
  }

  void registerUser() async {
    print("Registering user...");
    try {
    //   if (_name.text.isEmpty ||
    //     _email.text.isEmpty ||
    //     _cnum.text.isEmpty ||
    //     _address.text.isEmpty ||
    //     _password.text.isEmpty ||
    //     _cpassword.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please fill all fields')),
    //   );
    //   return;
    // }

    // if (_password.text != _cpassword.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Passwords do not match')),
    //   );
    //   return;
    // }

    final auth = await supabase.auth.signUp(email:_email.text, password:_password.text);
    String uid = auth.user!.id;

    String? photoUrl = await uploadFile(pickedImage, "photo", uid);
    String? licenseUrl = await uploadFile(pickedLicense, "license", uid);

    final userData = {
      "shop_name": _name.text,
      "shop_email": _email.text,
      "shop_contact": _cnum.text,
      "shop_address": _address.text,
      "shop_photo": photoUrl ?? '',
      "shop_license": licenseUrl ?? '',
      "shop_password": _password.text, // Encrypt before saving!
    };

    await supabase.from('tbl_shop').insert(userData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration Successful')),
    );
  Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
    } catch (e) {
      print("Error registering user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Full Name', icon: Icons.person, controller: _name),
                    CustomTextField(label: 'Email', icon: Icons.email, controller: _email),
                    CustomTextField(label: 'Phone Number', icon: Icons.phone, controller: _cnum),
                    CustomTextField(label: 'Address', icon: Icons.location_on, controller: _address),
                    CustomTextField(label: 'Photo', icon: Icons.image, controller: _photo, onTap: handleImagePick, readOnly: true),
                    CustomTextField(label: 'License', icon: Icons.assignment, controller: _license, onTap: handleProofPick, readOnly: true),
                    CustomTextField(label: 'Password', icon: Icons.lock, pass: true, controller: _password),
                    CustomTextField(label: 'Confirm Password', icon: Icons.lock, pass: true, controller: _cpassword),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: (){
                          registerUser();
                        },
                        child: Text('Register'),
                      ),
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
}
