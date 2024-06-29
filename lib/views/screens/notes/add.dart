import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfiled_add.dart';
import 'package:noteapp222_firebase/views/screens/notes/view.dart';
import "package:path/path.dart";

class AddNotes extends StatefulWidget {
  final String docid;
  const AddNotes({super.key, required this.docid});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteBody = TextEditingController();

  bool isloading = false;
  File? fileCamera;
  String? url;
  int joker = 1;

  getImageFromCamera(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera = await picker.pickImage(source: source);
    fileCamera = File(imageCamera!.path);
    var imagename = basename(imageCamera.path); //يستخرج اسم الصورة من المسار
    //var refStorage = FirebaseStorage.instance.ref("images").child(imagename); //Storge تحديد اسم الملف على ال
    joker = 0;
    setState(() {});
    var refStorage = FirebaseStorage.instance
        .ref("images/$imagename"); //Storge تحديد اسم الملف على ال
    await refStorage.putFile(fileCamera!); // storge تعليمة رفع الملف على ال
    url = await refStorage.getDownloadURL(); //تعليمة جلب رابط  تحميل الملف
    joker = 1;
    setState(() {});
    print("111111111111111111111111111111");
    print(url);
    print("1111111111111111111111111111111");
  }

  addNotes(BuildContext context) async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("notes");
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await notes.add({
          "title": noteTitle.text,
          "body": noteBody.text,
          "url": url ??
              "none", // none اذا  كان الرابط يساوري الصفر تقوم باستبدال  بالكلمة
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return NoteView(categoriID: widget.docid);
        }), (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {});
      }
    } else {
      print("Error");
    }
  }

  @override
  void dispose() {
    noteTitle.dispose();
    noteBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add  Your Note",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
      body: isloading == true
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.black, Colors.grey, Colors.black])),
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
                        hinttext: "Enter Your Title",
                        mycontroller: noteTitle,
                        validator: (val) {
                          if (val == "") {
                            return "can't To Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextFormFiledAdd(
                        hinttext: "Enter Your body",
                        mycontroller: noteBody,
                        validator: (val) {
                          if (val == "") {
                            return "can't To Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButtonUpload(
                      title: "Pick From Camera",
                      isSelected: true,
                      onPressed: () {
                        getImageFromCamera(ImageSource.camera);
                      },
                    ),
                    CustomButtonUpload(
                      title: "Pick From Gallary",
                      isSelected: true,
                      onPressed: () {
                        getImageFromCamera(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(
                      height: 444,
                    ),
                    joker == 1
                        ? CustomButtonAuth(
                            title: "Add Note",
                            onPressed: () async {
                              addNotes(context);
                            },
                          )
                        : const Column(
                            children: [
                              Text(
                                "Wait To Upload The File .....",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator(),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
