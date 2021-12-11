import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handong_chapel_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';
import 'add.dart';

class QnAPage extends StatefulWidget {
  const QnAPage(
      {Key? key,
      required this.addQuestionToQuestionBook,
      required this.questions,
      required this.answerQuestion,
      required this.pastors})
      : super(key: key);

  final FutureOr<void> Function(String question) addQuestionToQuestionBook;
  final FutureOr<void> Function(String documentId, String answer)
      answerQuestion;
  final List<questionInfo> questions;
  final List<String> pastors;

  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  bool pressed = false;
  bool authorized = false;

  void getUser() {
    var collection = FirebaseFirestore.instance
        .collection('pastorBook')
        .snapshots()
        .listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        var userId = data['pastorId']; // <-- Retrieving the value.
        if (userId == FirebaseAuth.instance.currentUser!.uid) {
          authorized = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(title: Text("Q&A")),
            floatingActionButton: Container(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                  backgroundColor: Color(0xFF4A90E2),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        await MaterialPageRoute(
                            builder: (context) => AddQuestionPage(
                                addQuestion: (question) => widget
                                    .addQuestionToQuestionBook(question))));
                  }),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: ListView(children: [
              for (var question in widget.questions)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      //color: Color(0xffF8F2EE),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Question',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(
                              height: 10,
                              thickness: 1,
                              indent: 50,
                              endIndent: 50,
                              color: Colors.grey,
                            ),
                            Text('${question.question}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            authorized
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            await MaterialPageRoute(
                                                builder: (context) =>
                                                    AddAnswerPage(
                                                      addAnswer: (documentId,
                                                              answer) =>
                                                          widget.answerQuestion(
                                                              documentId,
                                                              answer),
                                                      documentId:
                                                          question.questionId,
                                                      question:
                                                          question.question,
                                                    )));
                                      },
                                      child: Text(
                                        'Answer',
                                        style: TextStyle(
                                            color: Color(0xFF4A90E2),
                                            fontSize: 12),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    question.answer != "waiting for pastor's answer"
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            clipBehavior: Clip.antiAlias,
                            //color: Colors.white,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Answer',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Divider(
                                    height: 10,
                                    thickness: 1,
                                    indent: 50,
                                    endIndent: 50,
                                    color: Colors.grey,
                                  ),
                                  Text('${question.answer}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ],
                              ),
                            ),
                          )
                        : Container(child: Text(" ")),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.white,
                    ),
                  ],
                )
            ]),
          );
        });
  }
}
