import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:icar/DialogBox/errorDialog.dart';
import 'package:icar/HomeScreen.dart';
import 'package:icar/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icar/globalVar.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =TextEditingController();
  final TextEditingController _phoneConfirmController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  'images/register.png',
                  height: 270.0,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  CustomTextField(
                      controller: _phoneConfirmController,
                      data: Icons.person,
                      hintText: 'Phone',
                      isObsecure: false),
                  CustomTextField(
                      controller: _emailController,
                      data: Icons.email,
                      hintText: 'Email',
                      isObsecure: false),
                  CustomTextField(
                      controller: _imageController,
                      data: Icons.camera_alt_outlined,
                      hintText: "Image URL",
                      isObsecure: false),
                  CustomTextField(
                      controller: _passwordController,
                      data: Icons.password,
                      hintText: "Password",
                      isObsecure: true),
                  CustomTextField(
                      controller: _passwordConfirmController,
                      data: Icons.password,
                      hintText: 'Confirm Password',
                      isObsecure: true)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
void saveUserData(){
    Map<String,dynamic> userData={
      'userName':_nameController.text.trim(),
      'uid': userId,
      'userNumber': _phoneConfirmController.text.trim(),
      'imgPro': _imageController.text.trim(),
      'time': DateTime.now(),
    };
    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
}


void _register()async{
    User currentUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    ).then((auth){
      currentUser=auth.user;
      userId=currentUser.uid;
      userEmail=currentUser.email;
      getUserName = _nameController.text.trim();
      saveUserData();
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (con){
        return ErrorAlertDialog(message: error.message.toString()
        );
      });
    });
    if(currentUser!=null) {
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    }
}



}

