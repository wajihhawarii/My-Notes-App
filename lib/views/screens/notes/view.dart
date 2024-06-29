import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:noteapp222_firebase/views/screens/notes/add.dart';
import 'edit.dart';

class NoteView extends StatefulWidget {
  final String categoriID;
  const NoteView({super.key, required this.categoriID});
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> notelist = [];
  bool isloding = true;

  getDate() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoriID)
        .collection("notes")
        .get(); // ومن ثم التوجه الى مجمعة جزئية بداخلها  id حسب ال   dcumention جلب
    notelist.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return AddNotes(docid: widget.categoriID);
            }));
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: const Text(
            'My Notes',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("homepage");
            },
          ),
        ),
        // ignore: unrelated_type_equality_checks
        body: isloding == true
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
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Colors.black, Colors.black45])),
                height: double.infinity,
                width: double.infinity,
                child: notelist.isEmpty
                    ? Image.asset(
                        "images/emptyy.png",
                        color: Colors.orange,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: notelist.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                onLongPress: () {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.infoReverse,
                                    body: const Center(
                                      child: Text(
                                        'Are Your sure from delete ',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    title: 'Error',
                                    desc: 'Error',
                                    dialogBackgroundColor: Colors.white,
                                    btnOkOnPress: () {},
                                    btnOkText: "cansel",
                                    btnCancelText: "delete",
                                    btnCancelOnPress: () async {
                                      await FirebaseFirestore.instance
                                          .collection("categories")
                                          .doc(widget.categoriID)
                                          .collection("notes")
                                          .doc(notelist[index].id)
                                          .delete();
                                      if (notelist[index]["url"] != "none") {
                                        FirebaseStorage
                                            .instance // Storge  من اجل حذف الملف من قاعدة البيانات ال
                                            .refFromURL(notelist[index]["url"])
                                            .delete();
                                      }
                                      //id spectial document

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) {
                                        return NoteView(
                                            categoriID: widget.categoriID);
                                      }));
                                    },
                                  ).show();
                                },
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return EditNotes(
                                      noteid: notelist[index].id,
                                      categorydocid: widget.categoriID,
                                      noteTitle: notelist[index]["title"],
                                      noteBody: notelist[index]["body"],
                                    );
                                  }));
                                },
                                child: Card(
                                    elevation: 10,
                                    color: Colors.white24,
                                    //color: Color.fromARGB(255, 182, 170, 184),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              notelist[index]["title"],
                                              style: const TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ), // map عبارة عن document هي مفتاح موجود في قاعدة البيانات بحيث كل  name
                                            Text(
                                              notelist[index]["body"],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (notelist[index]["url"] !=
                                                "none")
                                              Expanded(
                                                child: Image.network(
                                                  notelist[index]["url"],
                                                  fit: BoxFit.fill,
                                                  width: 150,
                                                  height: 150,
                                                ),
                                              ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                    )),
                              );
                            }),
                      ),
              ));
  }
}
