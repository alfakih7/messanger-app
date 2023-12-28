import 'package:flutter/material.dart';
import 'package:messanger/components/mybuttons.dart';
import 'package:messanger/components/mytextfield.dart';
import 'package:messanger/services/auth/authservices.dart';
import 'package:provider/provider.dart';

class RegistrePage extends StatefulWidget {
  final void Function()? onTap;
  const RegistrePage({super.key, required this.onTap});

  @override
  State<RegistrePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegistrePage> {
  //text controller email and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up user
  void SignUp() async {
    print('Password: $passwordController');
    print('Confirm Password: $confirmPasswordController');
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('password do not match'),
        ),
      );
      return;
    }
    //get auth services
    final authServices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authServices.signUpWithEmailAndPassword(
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  'let\'s Create an account for u',
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
                  height: 10,
                ),
                MyTextField(
                    controller: confirmPasswordController,
                    hintext: 'Confirm Password',
                    isObsecureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  onTap: SignUp,
                  text: 'Sign Up',
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member ?'),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
