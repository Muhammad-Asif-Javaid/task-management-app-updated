import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management_app/TaskScreen.dart';
import 'package:task_management_app/signup_screen.dart';
import 'package:task_management_app/utils/utils.dart';
import 'package:task_management_app/widgets/round_button.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false ;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true ;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()).then((value){
          Utils().toastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Taskscreen()));
          setState(() {
            loading = false ;
          });
          
    }).onError((error , stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
}

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login Screen"),
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
      
      
              RoundButton(title: "Login",
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  login();
                }
              },
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account ?"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
                  }, child: Text('Sign Up'))
                ],
              )
      
            ],
          ),
        ),
      ),
    );
  }
}
