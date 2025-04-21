 import 'package:flutter/material.dart';
import 'package:m_user/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

bool _isObscure = true;
bool _isObscure2 = true;
bool _isObscure3 = true;

class _ChangePasswordState extends State<ChangePassword> {

  final TextEditingController _password = TextEditingController();
  final TextEditingController _npassword = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();

Future<void> ChangePassword() async {
  try {
      final response = await supabase.auth.signInWithPassword(
        email: supabase.auth.currentUser!.email!,
        password: _password.text,
      );

      if (response.user == null) {
        throw Exception('Current password is incorrect');
      }

      // If sign in was successful, update the password
      await supabase.auth.updateUser(
        UserAttributes(
          password: _npassword.text,
        ),
      );

      await supabase.from('tbl_user').update({
        'user_password': _npassword.text,
      }).eq('id', supabase.auth.currentUser!.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  } catch (e) {
    
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "Change Your Password",
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
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Old Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Your Old Passsword",
                    label: Text("Old Password"),
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
                  controller: _npassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your New Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Your New Passsword",
                    label: Text("New Password"),
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
                 TextFormField(
                  controller: _cpassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Your New Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Confirm Your New Passsword",
                    label: Text("Confirm New Password"),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure3
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure3 = !_isObscure3;
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
                    ChangePassword();
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