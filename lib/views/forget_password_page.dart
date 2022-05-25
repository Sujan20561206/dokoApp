import 'package:doko_app/app/core/api_client.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "please enter your email",
                  border: InputBorder.none,
                ),
              ),
            ),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(primary: Colors.red),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      // to send reset link to user (ctrl+postData)
                      await ApiClient().postData(data: {
                        "email": emailController.text,
                      }, endpoint: "forget-password");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Password reset link has been sent to your email"),
                      ));
                      Navigator.pop(context);
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text("Send password reset link"))
          ],
        ),
      ),
    );
  }
}
