import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resola/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading=false;
  final _auth=FirebaseAuth.instance;
  void _submitAuthScreen(
      String email,
      String password,
      String userName,
      File image,
      bool isLogin,
      BuildContext ctxt)
  async {
    UserCredential userCredential;
    try{
      setState(() {
        _isLoading=true;
      });
      if(isLogin){
     userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);

    }else{
      userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final ref=FirebaseStorage.instance.ref().child('user_image').child(userCredential.user.uid + '.jpg');
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').document(userCredential.user.uid).setData({
        'username':userName,
        'email':email,
        'image_url':url,
      });
    }

    }on PlatformException catch(err){
      var message= 'An error occurred, Please check your credential';
      if(err.message!=null){
        message= err.message;
      }
      // Scaffold.of(ctxt).showSnackBar(
      //     SnackBar(content:Text(message),
      //       duration: Duration(seconds: 2),
      //       backgroundColor:Theme.of(ctxt).accentColor,
      //     ));
      showDialog(context: ctxt,builder: (ctxt)=>AlertDialog(
        content:Text(message),
        actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Cancel"))
        ],
      ));
      setState(() {
        _isLoading=false;
      });
    }catch(err){
      print(err);
      setState(() {
        _isLoading=false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body:AuthForm(_submitAuthScreen,_isLoading),
    );
  }
}
