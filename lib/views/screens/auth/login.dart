import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstae = GlobalKey<FormState>();
  bool isloading = false;

  Future signInWithGoogle() async {
    //دالة جاهزة لتسجيل الدخول من خلال حساب  غوغل
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.black, Colors.grey, Colors.black])),
              child: ListView(children: [
                Form(
                  key: formstae,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 50),
                      const Text("Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      const Text("Login To Continue Using The App",
                          style: TextStyle(color: Colors.grey)),
                      Container(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(height: 10),
                      CustomTextForm(
                          validator: (val) {
                            if (val == "") {
                              return "can't To bo Empty";
                            } else {
                              return null;
                            }
                          },
                          hinttext: "ُEnter Your Email",
                          mycontroller: email),
                      Container(height: 10),
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(height: 10),
                      CustomTextForm(
                          validator: (val) {
                            if (val == "") {
                              return "can't To bo Empty";
                            } else {
                              return null;
                            }
                          },
                          hinttext: "ُEnter Your Password",
                          mycontroller: password),
                      InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            AwesomeDialog(
                              //  barrierColor: Colors.yellow,      لون الواجهة خلف الديالوغ
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.error,
                              body: const Center(
                                child: Text(
                                  'Enter Your Email To Reset Password ',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              dialogBackgroundColor: Colors.white,
                              btnOkOnPress: () {},
                              //  btnCancelOnPress: () {},
                            ).show();
                            return;
                          }

                          await FirebaseAuth
                              .instance //يقوم بارسال كلمة المرور الى الحساب
                              .sendPasswordResetEmail(email: email.text);

                          // ignore: use_build_context_synchronously
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.info,
                            body: const Center(
                              child: Text(
                                '    go To your Email And Click on The Link To Reset Password , if The Link dont appear sure from The Email Enter ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            dialogBackgroundColor: Colors.white,
                            btnOkOnPress: () {},
                          ).show();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                CustomButtonAuth(
                    title: "login",
                    onPressed: () async {
                      if (formstae.currentState!.validate()) {
                        try {
                          // ignore: unused_local_variable
                          isloading = true;
                          setState(() {});

                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          if (credential.user!.emailVerified) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                          } else {
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification(); //ترسل البريد الالكتروني الى الحساب
                            // ignore: use_build_context_synchronously
                            AwesomeDialog(
                              //  barrierColor: Colors.yellow,      لون الواجهة خلف الديالوغ
                              dismissOnTouchOutside: false,
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.info,
                              body: Container(
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'pleace veriyfied your email form The link in Your Email Account',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              dialogBackgroundColor: Colors.white,
                              btnOkOnPress: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("login");
                              },
                              //  btnCancelOnPress: () {},
                            ).show();
                          }
                        } catch (e) {
                          isloading = false;
                          setState(() {});
                          // ignore: use_build_context_synchronously
                          AwesomeDialog(
                            // dismissOnTouchOutside:
                            //     false, // تعيينها إلى false لمنع الإغلاق عند النقر على الخلفية

                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.error,
                            body: Center(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 50,
                                width: double.infinity,
                                child: const Center(
                                  child: Text(
                                    'Email Or PassWord Is Not Valid',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnOkOnPress: () {
                              // Navigator.of(context)
                              //     .pushReplacementNamed("login");
                            },
                          ).show();
                        }
                      } else {
                        print(
                            "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
                      }
                    }),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                Container(height: 10),
                MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.red[700],
                    textColor: const Color.fromRGBO(255, 255, 255, 1),
                    onPressed: () {
                      //////////////////////////////
                      signInWithGoogle();
                      // signInWithFacebook();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/login.png",
                          width: 30,
                        ),
                        const Text("  Login With Google"),
                      ],
                    )),
                Container(height: 20),
                // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("signup");
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                          text: "Register",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ])),
                  ),
                )
              ]),
            ),
    );
  }
}
