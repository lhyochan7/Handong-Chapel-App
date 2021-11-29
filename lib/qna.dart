import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handong_chapel_app/main.dart';
import 'main.dart';
import 'add.dart';

class QnAPage extends StatefulWidget {
  const QnAPage(
      {Key? key,
      required this.addQuestionToQuestionBook,
      required this.questions,
      required this.answerQuestion})
      : super(key: key);

  final FutureOr<void> Function(String question) addQuestionToQuestionBook;
  final FutureOr<void> Function(String documentId, String answer)
      answerQuestion;
  final List<questionInfo> questions;

  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: Container(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
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
                      color: Color(0xffF8F2EE),
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Question',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${question.question}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey)),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    await MaterialPageRoute(
                                        builder: (context) => AddAnswerPage(
                                              addAnswer: (documentId, answer) =>
                                                  widget.answerQuestion(
                                                      documentId, answer),
                                              documentId: question.questionId,
                                              question: question.question,
                                            )));
                              },
                              child: Text(
                                'Answer',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    question.answer != "waiting for pastor's answer"
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Text(
                                  'Answer',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue),
                                ),
                                const Divider(
                                  height: 10,
                                  thickness: 1,
                                  indent: 50,
                                  endIndent: 50,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${question.answer}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black)),
                                ),
                              ],
                            ),
                          )
                        : Container(child: Text(" ")),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
            ]),
          );
        });
  }
}
