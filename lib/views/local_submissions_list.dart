// lib/views/local_submissions_list.dart

import 'package:flutter/material.dart';
import '../models/submission.dart';

class LocalSubmissionsList extends StatelessWidget {
  final List<Submission> localSubmissions;

  // ignore: use_super_parameters
  const LocalSubmissionsList({Key? key, required this.localSubmissions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: localSubmissions.length,
        itemBuilder: (context, index) {
          final submission = localSubmissions[index];
          return SizedBox(
            height: 160,
            width: 200,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(submission.message,style: const TextStyle(overflow: TextOverflow.ellipsis),maxLines: 4,),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(submission.firstName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(submission.email),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
