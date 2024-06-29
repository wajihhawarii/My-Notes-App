import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/components/custombuttonauth.dart';
import 'package:noteapp222_firebase/views/components/textformfiled_add.dart';
import 'package:noteapp222_firebase/views/screens/notes/view.dart';

class EditNotes extends StatefulWidget {
  final String noteid;
  final String categorydocid;
  final String noteTitle;
  final String noteBody;
  const EditNotes({
    super.key,
    required this.noteid,
    required this.categorydocid,
    required this.noteTitle,
    required this.noteBody,
  });

  @override
  State<EditNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<EditNotes> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteBody = TextEditingController();

  bool isloading = false;

  editNotes() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categorydocid)
        .collection("notes");
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await notes.doc(widget.noteid).update(
            {"title": noteTitle.text, "body": noteBody.text, "url": "none"});
        // await notes.add({
        //   "note": note.text,
        // });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return NoteView(categoriID: widget.categorydocid);
        }), (route) => false);
      } catch (e) {
        print("44444444444444444444444444444444444444444444");
        print("$e");
        isloading = false;
        setState(() {});
      }
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    noteTitle.text = widget.noteTitle;
    noteBody.text = widget.noteBody;
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
          "Edit Notes",
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
                        hinttext: "Enter Your Notes",
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
                        hinttext: "Enter Your Notes",
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
                      height: 30,
                    ),
                    CustomButtonAuth(
                      title: "Save Note",
                      onPressed: () {
                        editNotes();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
