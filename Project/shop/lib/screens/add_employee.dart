import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shop/components/custom_textfield.dart';
import 'package:shop/screens/dashboard.dart';
import 'package:shop/main.dart';
import 'package:shop/services/auth_service.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  PlatformFile? pickedImage;
  PlatformFile? pickedLicense;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _photo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();
  final AuthService _authService = AuthService();

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
      print("Email: ${_email.text}");
      print("Password: ${_password.text}");
    final auth = await supabase.auth.signUp(email:_email.text, password:_password.text);
    String uid = auth.user!.id;
    print("User ID: 1: $uid");
    String? photoUrl = await uploadFile(pickedImage, "photo", uid);
    await _authService.relogin();
    print("User ID: 2: $uid");
    final userData = {
      'id': uid,
      "staff_name": _name.text,
      "staff_email": _email.text,
      "staff_photo": photoUrl ?? '',
      "staff_password": _password.text, // Encrypt before saving!
    };

    await supabase.from('tbl_staff').insert(userData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration Successful')),
    );
  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
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
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: _name,
                    ),
                    CustomTextField(
                      label: 'Email',
                      icon: Icons.email,
                      controller: _email,
                    ),
                    CustomTextField(
                      label: 'Photo',
                      icon: Icons.image,
                      controller: _photo,
                      onTap: handleImagePick,
                      readOnly: true,
                    ),
                    CustomTextField(
                      label: 'Password',
                      icon: Icons.lock,
                      pass: true,
                      controller: _password,
                    ),
                    CustomTextField(
                      label: 'Confirm Password',
                      icon: Icons.lock,
                      pass: true,
                      controller: _cpassword,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: registerUser,
                        child: const Text('Register'),
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
