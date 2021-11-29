import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'main.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key, required this.addQuestion})
      : super(key: key);

  final FutureOr<void> Function(String question) addQuestion;

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController _question = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();

  final Stream<QuerySnapshot> _questionStream =
      FirebaseFirestore.instance.collection('questionBook').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _questionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                leading: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 12),
                      primary: Colors.black,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await widget.addQuestion(_question.text);
                        _question.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      maxLines: null,
                      decoration: new InputDecoration(
                        labelText: "Question",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                      ),
                      controller: _question,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class AddAnswerPage extends StatefulWidget {
  const AddAnswerPage(
      {Key? key,
      required this.addAnswer,
      required this.documentId,
      required this.question})
      : super(key: key);

  final FutureOr<void> Function(String documentId, String question) addAnswer;
  final String documentId;
  final String question;

  @override
  _AddAnswerPageState createState() => _AddAnswerPageState();
}

class _AddAnswerPageState extends State<AddAnswerPage> {
  TextEditingController _answer = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();

  final Stream<QuerySnapshot> _questionStream =
      FirebaseFirestore.instance.collection('questionBook').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _questionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                leading: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 12),
                      primary: Colors.black,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await widget.addAnswer(widget.documentId, _answer.text);
                        _answer.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        //border: Border.all(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xffF8F2EE),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Question',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            indent: 50,
                            endIndent: 50,
                            color: Colors.grey,
                          ),
                          Text('${widget.question}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      )),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      maxLines: null,
                      decoration: new InputDecoration(
                        labelText: "Answer",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                      ),
                      controller: _answer,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
