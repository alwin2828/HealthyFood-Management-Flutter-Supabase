import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shop/components/custom_dropdown.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
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

  List<Map<String, dynamic>> district = [];
  List<Map<String, dynamic>> place = [];
  String? selectedDistrict;
  String? selectedPlace;

  int _currentImageIndex = 0;
  late AnimationController _animationController;

  final List<String> _images = [
    'assets/shop2.jpg',
    'assets/diet_2.jpg',
    'assets/shop1.jpg',
    'assets/shop3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    getDistrict();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentImageIndex = (_currentImageIndex + 1) % _images.length;
          });
          _animationController.forward(from: 0);
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _name.dispose();
    _email.dispose();
    _cnum.dispose();
    _address.dispose();
    _photo.dispose();
    _license.dispose();
    _password.dispose();
    _cpassword.dispose();
    super.dispose();
  }

  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
        _photo.text = pickedImage!.name;
      });
    }
  }

  Future<void> handleProofPick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
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

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      print("Registering user...");
      try {
        final auth = await supabase.auth.signUp(email: _email.text, password: _password.text);
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
          "shop_password": _password.text,
          "place_id": selectedPlace,
        };

        await supabase.from('tbl_shop').insert(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      } catch (e) {
        print("Error registering user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering user: $e')),
        );
      }
    }
  }

  Future<void> getDistrict() async {
    try {
      final response = await supabase.from('tbl_district').select();
      setState(() {
        district = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching districts: $e");
    }
  }

  Future<void> getPlace(String id) async {
    try {
      final response = await supabase.from('tbl_place').select().eq('district_id', id);
      setState(() {
        place = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    bool obscureText = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          prefixIcon: Icon(icon, color: Color(0xFF25A18B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF25A18B), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _formKey, // Attach the form key
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Image.asset(
                    _images[_currentImageIndex],
                    key: ValueKey<int>(_currentImageIndex),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Text(
                            'Image Not Found',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(-5, 0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Register Your Shop',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join us and start your journey',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Shop Name',
                        icon: Icons.store,
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Email',
                        icon: Icons.email,
                        controller: _email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Phone Number',
                        icon: Icons.phone,
                        controller: _cnum,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
                            return 'Please enter a valid phone number (e.g., 1234567890 or +1234567890)';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Address',
                        icon: Icons.location_on,
                        controller: _address,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Photo',
                        icon: Icons.image,
                        controller: _photo,
                        readOnly: true,
                        onTap: handleImagePick,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please upload a photo';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'License',
                        icon: Icons.assignment,
                        controller: _license,
                        readOnly: true,
                        onTap: handleProofPick,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please upload a license';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Password',
                        icon: Icons.lock,
                        controller: _password,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Confirm Password',
                        icon: Icons.lock,
                        controller: _cpassword,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (value != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown(
                        label: "District",
                        items: district,
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                            selectedPlace = null;
                            place = [];
                          });
                          if (value != null) getPlace(value);
                        },
                        displayKey: "district_name",
                        valueKey: "id",
                        icon: Icons.location_city,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown(
                        label: "Place",
                        items: place,
                        onChanged: (value) {
                          setState(() {
                            selectedPlace = value;
                          });
                        },
                        displayKey: "place_name",
                        valueKey: "id",
                        icon: Icons.place,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF25A18B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(double.infinity, 50),
                          elevation: 5,
                        ),
                        onPressed: registerUser,
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          ),
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Color(0xFF25A18B), fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}