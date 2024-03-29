import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_service_app/views/homeView.dart';
import "package:home_service_app/dataClasses/User.dart";
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:home_service_app/views/loginView.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final conpassController = TextEditingController();
  bool isLogin = true;
  bool wrongcred = false;
  bool validated = false;
  String errorComparePasswords = '';
  Color errorComparePassworsColor = Colors.red;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('[Login View : Start ]');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 100),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 15.0),
                //padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLogin = true;
                        print(
                            '[ElevatedButton(Login)] : isLogin Updated -> $isLogin');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Login",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(4, 30, 81, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    side: BorderSide(color: Colors.black))))),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 15.0),
                //padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLogin = false;
                        print(
                            '[ElevatedButton(Signup)] : isLogin Updated -> $isLogin');
                        
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Signup",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(195, 166, 96, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    side: BorderSide(color: Colors.white))))),
              ),
            ],
          ),
          isLogin == true
              ? Container(
                  //height: 600,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(229, 229, 229, 1),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(7.0, 8.0))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "Email",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          key: Key('email'),
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 55, top: 15),
                        child: Text(
                          "Password",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          key: const Key('password'),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onSubmitted: (String value) {},
                          controller: passController,
                        ),
                      ),
                      if (wrongcred)
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 25,
                            child: Text(
                              "Wrong Email or Password",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 200),
                        child: Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              key: Key("loginButton"),
                              onPressed: () {
                                if (emailController.text == '' ||
                                    passController.text == '') {
                                  showToast('Please Fill Out Fields!');
                                  return;
                                }
                                authenticateUser();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(75, 10, 75, 10),
                                child: Text(
                                  "Login",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(195, 166, 96, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))))),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  //height: 700,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(229, 229, 229, 1),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(7.0, 8.0))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "Email",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "First Name",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 0, 55, 0),
                        child: TextField(
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: fnameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "Last Name",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: lnameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "Password",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: passController,
                          onChanged: (text) {
                            _validateSamePass();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 55),
                        child: Text(
                          "Confirm Password",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 10, 55, 0),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          controller: conpassController,
                          onChanged: (text) {
                            _validateSamePass();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 35, 0),
                        child: passController.text == '' &&
                                conpassController.text == ''
                            ? Text('')
                            : Text(
                                errorComparePasswords,
                                style:
                                    TextStyle(color: errorComparePassworsColor),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25,bottom: 100),
                        child: Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () {
                                final email = emailController.text;
                                final name = fnameController.text +
                                    " " +
                                    lnameController.text;
                                final password = passController.text;
                                var bytes = utf8.encode(conpassController.text);
                                String digest =
                                    sha256.convert(bytes).toString();
                                signUp(
                                    name: name, email: email, password: digest);
                                showToast('Account Created! Login to Continue');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => loginView()));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(75, 10, 75, 10),
                                child: Text(
                                  "Signup",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(195, 166, 96, 1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )))),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _validateSamePass() {
    var bytes_1 = utf8.encode(passController.text);
    String digest_1 = sha256.convert(bytes_1).toString();
    var bytes_2 = utf8.encode(conpassController.text);
    String digest_2 = sha256.convert(bytes_2).toString();
    if (digest_1.compareTo(digest_2) != 0) {
      setState(() {
        errorComparePasswords = "Passwords don't match!";
        errorComparePassworsColor = Colors.red;
        return;
      });
    } else {
      setState(() {
        errorComparePasswords = "Passwords match!";
        errorComparePassworsColor = Colors.green;
      });
    }
  }

  loadUserProfile() async {}

  Future signUp(
      {required String name,
      required String email,
      required String password}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User.register(docUser.id, name, email, password);
    //print(user.toString());
    final jsonData = user.toJson();
    await docUser.set(jsonData);
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, webPosition: 'center', timeInSecForIosWeb: 4);
  }

  authenticateUser() async {
    String check = '';
    String id = '';
    var bytes = utf8.encode(passController.text);
    String digest = sha256.convert(bytes).toString();
    final value = await FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: emailController.text)
        .get();
    if (value.size == 0) {
      showToast('Account Doesn`t Exist, Verify Email Spelling');
      return;
    }
    for (var doc in value.docs) {
      check = doc.get('Password');
      id = doc.get('ID');
    }
    if (check != digest) {
      showToast('Incorrect Password!');
      return;
    }
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final snapshot = await docUser.get();
    Map<String, dynamic>? jsonData = snapshot.data();
    User user = User.fromJson(jsonData!);
    print('Login Passed!');
   // print(user.toString());
    showToast('Logged In!');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeView(
                  user: user,
                )));
  }
}
