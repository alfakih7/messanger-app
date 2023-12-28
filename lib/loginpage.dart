// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:messanger/components/mybuttons.dart';
import 'package:messanger/components/mytextfield.dart';
import 'package:messanger/services/auth/authservices.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller email and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //Sign In user
  Future<void> SignIn() async {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authServices.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Icon(
                  Icons.message,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Welcome back u\'ve been missed',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //gmail textfield
              MyTextField(
                  controller: emailController,
                  hintext: 'Email',
                  isObsecureText: false),
              const SizedBox(
                height: 10,
              ),

              //password texfield
              MyTextField(
                  controller: passwordController,
                  hintext: 'Password',
                  isObsecureText: true),
              const SizedBox(
                height: 15,
              ),
              MyButton(
                onTap: SignIn,
                text: 'Sign In',
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member ?'),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Registre Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
