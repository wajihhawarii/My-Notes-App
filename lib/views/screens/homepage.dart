import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteapp222_firebase/views/screens/categories/add.dart';
import 'package:noteapp222_firebase/views/screens/categories/edit.dart';
import 'package:noteapp222_firebase/views/screens/notes/view.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  List<QueryDocumentSnapshot> categoriesList = [];
  bool isloading = true;

  getDate() async {
    //String id = await FirebaseFirestore.instance.collection("categories").id;//   الرقم التعريفي للمجوعة وهذا نحن ننشئه عند انشاء المجموعة
    //QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("categories").doc("ot8n5tKzeakb0yocnYMO").collection("notes").get();      //للوصول للمجموعة متداخلة
    //QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("categories").where("name", isEqualTo: "wajih").limit(1).get(); //document مفتاح موجود في قاعدة البيانات هو احد الحقول الموجودة في كل
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .get(); // الموجودة في قاعدة البانات  لdocument جميع
    categoriesList.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    print("111111111111111111111111111111111");
    print(FirebaseAuth.instance.currentUser!
        .uid); // رقم التعريف للمستخدم المسجل دخوله وهي تنشا تلقائيا عند تسجيل الدخول
    print("111111111111111111111111111111111");
    getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: const Text(
            "My Categories",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn
                    .disconnect(); //من اجل ان تسجل الخروج من غوغل اذا كنت مسجل الدخول اللاىالتطبيق عن طريق حساب ب غوغل
                await FirebaseAuth.instance.signOut(); //تعليمة تسجيل الخروج
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("startpage", (route) => false);
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black.withOpacity(0.3),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) {
              return const AddCategorise();
            }));
          },
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
        body: isloading == true
            ? Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Colors.black, Colors.grey, Colors.black])),
                child: const Center(child: CircularProgressIndicator()),
              )
            : Container(
                padding: const EdgeInsets.all(5),
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Colors.black, Colors.grey, Colors.black])),
                child: categoriesList.isEmpty
                    ? Image.asset(
                        "images/emptyy.png",
                        color: Colors.orange,
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: categoriesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.infoReverse,
                                body: const Center(
                                  child: Text(
                                    'Are Your sure from delete ',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                title: 'Error',
                                desc: 'Error',
                                dialogBackgroundColor: Colors.white,
                                btnOkOnPress: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return EditCategorise(
                                        docid: categoriesList[index].id,
                                        oldname: categoriesList[index]["name"]);
                                  }));
                                },
                                btnOkText: "Edite",
                                btnCancelText: "delete",
                                btnCancelOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection("categories")
                                      .doc(categoriesList[index]
                                          .id) //id spectial document
                                      .delete();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context)
                                      .pushReplacementNamed("homepage");
                                },
                              ).show();
                            },
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) {
                                return NoteView(
                                    categoriID: categoriesList[index].id);
                              }));
                            },
                            child: Card(
                                elevation: 10,
                                color: Colors.white24,
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      "images/folder.png",
                                      height: 140,
                                      width: 140,
                                    ),
                                  ),
                                  Text(
                                    categoriesList[index]["name"],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ), // map عبارة عن document هي مفتاح موجود في قاعدة البيانات بحيث كل  name
                                ])),
                          );
                        },
                      ),
              ));
  }
}







//pinterst app