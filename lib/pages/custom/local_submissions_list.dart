import 'package:flutter/material.dart';
import 'package:formtask/Controllers/local_submission_controller.dart';
import 'package:get/get.dart';

class LocalSubmissionsList extends StatelessWidget {
  const LocalSubmissionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalSubmissionsController controller = Get.put(LocalSubmissionsController());

    return Obx(() {
      final submissions = controller.localSubmissions;
      if (submissions.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 24),
              Icon(Icons.inbox, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No submissions yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: 168,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final submission = submissions[index];
            return SizedBox(
              height: 168,
              width: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          submission.message,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 4,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                submission.firstName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                submission.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          if (!submission.isSynced)
                            const Icon(Icons.sync_problem, color: Colors.red),
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
    });
  }
}
