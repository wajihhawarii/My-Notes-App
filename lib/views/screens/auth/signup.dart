import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //تختبر حالة المستخدم اذا كان مسجل دخول او لاء
      if (user == null) {
        print(FirebaseAuth.instance.currentUser); //المستخدم الحالي

        print(
            '111111111111 User is currently signed out! 1111111111111111111111111');
      } else {
        print(
            '222222222222 User is signed in! 22222222222222222222222222222222222');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.black, Colors.grey, Colors.black])),
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formstate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                const Text("SignUp",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("SignUp To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 20),
                const Text(
                  "username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "can't To be Empty";
                      } else {
                        return null;
                      }
                    },
                    hinttext: "ُEnter Your username",
                    mycontroller: username),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "can't To be Empty";
                      } else {
                        return null;
                      }
                    },
                    hinttext: "ُEnter Your Email",
                    mycontroller: email),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "can't To be Empty";
                      } else {
                        return null;
                      }
                    },
                    hinttext: "ُEnter Your Password",
                    mycontroller: password),
                Container(
                  height: 10,
                ),
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextForm(
                  hinttext: "Enter Your Phone",
                  mycontroller: phonenumber,
                  validator: (val) {
                    if (val!.length <= 7) {
                      return "Your Number Lenght is Short";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 40,
          ),
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          CustomButtonAuth(
            title: "SignUp",
            onPressed: () async {
              if (formstate.currentState!.validate()) {
                try {
//////////////////////////////////////    دالة انشاء مستخدم جديد    ///////////////////////////////
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  FirebaseAuth.instance.currentUser!
                      .sendEmailVerification(); //ترسل  رابط تاكيد البريد الالكتروني الى الحساب
                  // ignore: use_build_context_synchronously
                  print(
                      "11111111111111111111111111111111111111111111111111111111");
                  // ignore: use_build_context_synchronously
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.info,
                    body: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Please verify your account through the link sent to your email',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    btnOkText: "LogIn",
                    btnOkOnPress: () {
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                  ).show();
                  print(credential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    // ignore: use_build_context_synchronously
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.error,
                      body: const Center(
                        child: Text(
                          'The password provided is too weak.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'This is Ignored',
                      desc: 'This is also Ignored',
                      btnOkOnPress: () {},
                    ).show();
                  } else if (e.code == 'email-already-in-use') {
                    // ignore: use_build_context_synchronously
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.error,
                      body: const Center(
                        child: Text(
                          'email-already-in-use.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'This is Ignored',
                      desc: 'This is also Ignored',
                      btnOkOnPress: () {},
                    ).show();
                  }
                } catch (e) {
                  print(e);
                }
              } else {}
            },
          ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          Container(height: 10),
          InkWell(
            onTap: () async {
              // await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushReplacementNamed("login");
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
