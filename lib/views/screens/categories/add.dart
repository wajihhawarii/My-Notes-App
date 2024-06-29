import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfiled_add.dart';

class AddCategorise extends StatefulWidget {
  const AddCategorise({super.key});

  @override
  State<AddCategorise> createState() => _AddCategoriseState();
}

class _AddCategoriseState extends State<AddCategorise> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories'); //Categories

  bool isloading = false;

  addCategoris() async {
    if (formstate.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed("homepage");
      } catch (e) {
        print("111111111111111111111111111111111111111111111");
        print("Error ${e}");
        print("11111111111111111111111111111111111111111111111");
      }
    } else {
      print("5555555555555555555555555555555555555555555555555");
    }
  }

  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  // addCategories() {
  //   if (formstate.currentState!.validate()) {
  //     isloading = true;
  //     setState(() {});
  //     return users
  //         .add(
  //             {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid})
  //         .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
  //             "homepage", (route) => false)) //تحذف جميع الواجهات
  //         // ignore: invalid_return_type_for_catch_error
  //         .catchError((error) => print("${error}"));
  //   } else {
  //     print("Error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("homepage", (route) => false);
            },
            icon: const Icon(
              Icons.arrow_forward_sharp,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
        backgroundColor: Colors.black.withOpacity(0.8),
        title: const Text(
          "Add Categories",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isloading == true
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.black, Colors.grey, Colors.black])),
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: CustomTextFormFiledAdd(
                        hinttext: "Enter Categorie Name",
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return "can't To Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    //const Spacer(),
                    CustomButtonAuth(
                      title: "Add",
                      onPressed: () {
                        addCategoris();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

///////////// FireStoer rules  ////////////////////

// rules_version = '2';
// 2
// ​
// 3
// service cloud.firestore {
// 4
//   match /databases/{database}/documents {
// 5
//     match /{document=**} {
// 6
//       allow read, write: if false;
// 7
//     }
// 8
//   }
// 9
// }







//flutter pub get
//flutter pub run flutter_launcher_icons