import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/views/forget_password_page.dart';
import 'package:doko_app/views/homepage.dart';
import 'package:doko_app/views/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_form.dart';
import '../validation_mixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixin {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late bool _loading;
  late bool _visible;

  @override
  void initState() {
    _loading = false;
    _visible = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DOKO",
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataForm(
                    validator: (value) {
                      // email validation check
                      return isEmailValid(value!) ? null : 'Invalid email';
                    },
                    hintText: 'Your email',
                    controller: emailController,
                    isPass: false,
                    keyboardtype: TextInputType.emailAddress,
                    textinputaction: TextInputAction.next,
                    icondata: Icons.mail,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: const Color(0xFFCECECE), width: 0)),
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, bottom: 0, right: 4.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (value) {
                          // validation login(ctrl+isPasswordValid)
                          if (isPasswordValid(value!)) {
                            return null;
                          } else {
                            return 'Minimum 8 characters required!';
                          }
                        },
                        enabled: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.black,
                        obscureText: _visible ? true : false,
                        controller: passwordController,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1C1C).withOpacity(0.7)),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _visible ? _visible = false : _visible = true;
                                });
                              },
                              icon: _visible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF1C1C1C).withOpacity(0.3),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                        // validator: validator,
                      ),
                    ),
                  ),
                  _loading
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF00693E),
                          ),
                        ))
                      : InkWell(
                          onTap: () async {
                            //validation call email ra password ko
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _loading = true;
                              });

                              final result = await ApiClient().login(data: {
                                "email": emailController.text,
                                "password": passwordController.text
                              });

                              setState(() {
                                _loading = false;
                              });

                              if (result == "fail") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Email or password is incorrect")));
                              } else {
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                // admin or user role save
                                _prefs.setBool("login", true);
                                _prefs.setInt("userid", result["userid"]);
                                _prefs.setString("role", result["role"]);
                                _prefs.setString("token", result["token"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Successful")));
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => Homepage(
                                              role: result["role"],
                                            )));
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(32.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF00A86B),
                                  Color(0xFF00693E),
                                ],
                              ),
                            ),
                            child: const Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const Text(
                    'Create new account?',
                    textAlign: TextAlign.center,
                  ),
                  SignUpButton(onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupPage()));
                  }),
                  const Text(
                    'Forgot password?',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordPage()));
                        },
                        child: const Text("Reset your password")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(32.0),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF0073CF),
              Color(0xFF003366),
            ],
          ),
        ),
        child: const Text(
          'Signup',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
