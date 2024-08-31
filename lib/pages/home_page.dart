import 'package:flutter/material.dart';
import 'package:formtask/pages/custom/myheading.dart';
import 'package:formtask/pages/widgets/local_submissions_list.dart';
import 'package:formtask/pages/widgets/myform.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(child: const Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0,top: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Myheading(title: 'User details',size: 20,),
          SizedBox(height: 12,),
          MyForm(),
          SizedBox(height: 20),
          Myheading(title: 'submitted message',size: 20,),
          SizedBox(height: 16,),
          LocalSubmissionsList(),
        ],
      ),
    )),
    );
  }
}
