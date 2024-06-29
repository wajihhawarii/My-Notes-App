import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfiled_add.dart';

class EditCategorise extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategorise({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategorise> createState() => _AddCategoriseState();
}

class _AddCategoriseState extends State<EditCategorise> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isloading = false;

  updateCategories() async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        //  await categories.doc("11111").set({"name:name.text", "id": FirebaseAuth.instance.currentUser?.uid,setOption(merge:true) // من اجل الا تحذف الحقول التي لم تتعدل //});    add تقوم بانشاء واحد  يعني تقوم بوظيفة id  ايضا تستخدم لتعديل الحقل ولكن اذا لم يكن موجود ال
        await categories.doc(widget.docid).update({
          //  هنا لا تقوم بانشاء واحد  id الخاص به اذا لم يوجد  id  لتعديل اسم الحقل يجب ان نعرف ال
          "name": name.text,
        }); //التي سوف نعدل عليه id
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {});
        print(
            "111111111111111111111111111111111111111111111111 ${e} 1111111111111111111111111111111111111 ");
      }
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose(); //نضعها افضل من اجل ان لايعطي اخطاء
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Categories",
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
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
                      padding: const EdgeInsets.all(10),
                      child: CustomTextFormFiledAdd(
                        hinttext: "Enter Name",
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
                    const Spacer(),
                    CustomButtonAuth(
                      title: "Update",
                      onPressed: () {
                        updateCategories();
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
