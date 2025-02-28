import 'package:flutter/material.dart';
import 'package:m_user/dashboard.dart';
import 'package:m_user/login.dart';
import 'package:m_user/main.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

bool _isObscure = true;
bool _isObscure2 = true;

class _RegistrationState extends State<Registration> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _cnum = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();
  final TextEditingController _dob = TextEditingController();

  String selectedGender = '';

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime minDate = currentDate.subtract(Duration(days: 365 * 18));  // 18 years ago from today

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? minDate,
      firstDate: DateTime(1900),
      lastDate: minDate,  // Set the last selectable date to 18 years ago
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dob.text = "${_selectedDate?.toLocal()}".split(' ')[0];  // Display as yyyy-MM-dd
      });
    }
  }
  Future<void> register() async {
    try {
      final authentication = await supabase.auth.signUp(password: _password.text, email: _email.text);
      String uid = authentication.user!.id;
      signUp(uid);
    } catch (e) {
      print("Error Auth: $e");
    }
  }

  Future<void> signUp(String uid) async {
    try {
      await supabase.from("tbl_user").insert({
        "id":uid,
        "user_name" : _name.text,
        "user_email": _email.text,
        "user_contact": _cnum.text,
        "user_password" : _password.text,
        "user_dob" : _dob.text,
        "user_gender": selectedGender,
      });
      print("Instered");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("mission accomplished")));
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
    } catch (e) {
      print("Error Registration: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("mission failed || cause of failuer => $e")));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "Registration",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox.expand(
        child: Center(
          child: Form(
            child: ListView(
              padding: EdgeInsets.all(25.0),
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                      hintText: 'Enter Your Name',
                      label: Text("Name"),
                      prefixIcon: Icon(Icons.account_circle_outlined)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                      hintText: 'Enter Your Email',
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.alternate_email_outlined)),
                ),
                SizedBox(
                  height: 10,
                ),
               TextFormField(
                      controller: _dob,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                          
                          hintText: 'DOB here...',
                          prefixIcon: Icon(Icons.calendar_month_outlined)),
                    ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Gender : ",
                      textAlign: TextAlign.left,
                    ),
                    Radio(
                      value: "Male",
                      groupValue: selectedGender,
                      onChanged: (e) {
                        setState(() {
                          selectedGender = e!;
                        });
                      },
                    ),
                    const Text("Male"),
                    Radio(
                      value: "Female",
                      groupValue: selectedGender,
                      onChanged: (e) {
                        setState(() {
                          selectedGender = e!;
                        });
                      },
                    ),   
                    const Text("Female"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _cnum,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                      hintText: 'Enter Your Contact Number',
                      label: Text("Contact Number"),
                      prefixIcon: Icon(Icons.phone_outlined)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.black45),
                    ),
                    hintText: "Enter Your Passsword",
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _cpassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.black45),
                    ),
                    hintText: "Confirm Your Passsword",
                    label: Text("Confirm Password"),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure2
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure2 = !_isObscure2;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure2,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF25A18B)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
