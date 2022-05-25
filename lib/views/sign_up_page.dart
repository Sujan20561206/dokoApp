import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/views/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data_form.dart';
import '../validation_mixin.dart';
import 'forget_password_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with ValidationMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _loading;
  late bool _visible;
  late bool _cvisible;

  @override
  void initState() {
    _loading = false;
    _visible = true;
    _cvisible = true;
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
                      return value!.isEmpty ? 'Name cannot be empty' : null;
                    },
                    hintText: 'Your name',
                    controller: nameController,
                    isPass: false,
                    keyboardtype: TextInputType.name,
                    textinputaction: TextInputAction.next,
                    icondata: Icons.person,
                  ),
                  DataForm(
                    validator: (value) {
                      // validation call (ctrl + isEmailValid)
                      return isEmailValid(value!) ? null : 'Invalid email';
                    },
                    hintText: 'Your email',
                    controller: emailController,
                    isPass: false,
                    keyboardtype: TextInputType.emailAddress,
                    textinputaction: TextInputAction.next,
                    icondata: Icons.mail,
                  ),
                  DataForm(
                      validator: (value) {
                        // phone number validation check
                        return isPhoneValid(value!)
                            ? null
                            : 'Invalid phone number';
                      },
                      hintText: 'Mobile number',
                      controller: mobileController,
                      isPass: false,
                      keyboardtype: TextInputType.phone,
                      textinputaction: TextInputAction.next,
                      icondata: Icons.contact_mail),
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
                          if (isPasswordValid(value!) &&
                              passwordController.text ==
                                  confirmPasswordController.text) {
                            return null;
                          } else if (isPasswordValid(value) &&
                              passwordController.text !=
                                  confirmPasswordController.text) {
                            return 'Passwords do not match';
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
                          if (isPasswordValid(value!) &&
                              passwordController.text ==
                                  confirmPasswordController.text) {
                            return null;
                          } else if (isPasswordValid(value) &&
                              passwordController.text !=
                                  confirmPasswordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return 'Minimum 8 characters required!';
                          }
                        },
                        enabled: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.black,
                        obscureText: _cvisible ? true : false,
                        controller: confirmPasswordController,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1C1C).withOpacity(0.7)),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _cvisible
                                      ? _cvisible = false
                                      : _cvisible = true;
                                });
                              },
                              icon: _visible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          hintText: 'Confirm password',
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
                      // validation call for all
                      : SignUpButton(onTap: () async {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _loading = true;
                            });
                            // signup detail server ma pathaucha(ctrl+ApiClient)
                            final result = await ApiClient().signUp(data: {
                              "name": nameController.text,
                              "email": emailController.text,
                              "phone": mobileController.text,
                              "password": passwordController.text,
                              "cpassword": confirmPasswordController.text
                            });

                            setState(() {
                              _loading = false;
                            });
                            if (result == "success") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Registration Successful")));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Email is already taken")));
                            }
                          }
                        }),
                  const Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
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
