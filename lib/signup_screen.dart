import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:task_management_app/login_screen.dart';
import 'package:task_management_app/utils/utils.dart';
import 'package:task_management_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signUp(){
    setState(() {
      loading= true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      setState(() {
        loading= false;
      });


    }).onError((error , stackTree){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });

    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Signup Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          helperText: 'enter email e.g asif@gmail.com',
                          prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value){
                        if (value!.isEmpty){
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10,),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 50,),
                  ],
                )),


            RoundButton(title: "Signup",
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  signUp();
                }

              },
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an account ?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                }, child: Text('Login'))
              ],
            )

          ],
        ),
      ),
    );
  }
}
