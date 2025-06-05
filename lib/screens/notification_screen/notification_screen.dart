import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/screens/form_details_screen/form_details_api_screen.dart';
import 'package:field_visit/widgets/loading_popup.dart';
import 'package:flutter/material.dart';

import 'package:field_visit/widgets/customer_field_visit_appbar.dart';
import 'package:field_visit/models/comment_notification.dart';
import 'package:page_transition/page_transition.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<CommentNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // final authProvider = Provider.of<Auth>(context, listen: false);
      final result = await Auth.fetchCommentNotificationList();
      setState(() {
        notifications = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomFieldVisitAppBar(),
      body: isLoading
          ? const LoadingPopup()
          : notifications.isEmpty
              ? const Center(child: Text('कोणतीही सूचना आढळली नाही.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return GestureDetector(
                      onTap: () async {
                        await Auth.markCommentAsRead(notif.id);
                        bool? result = await Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 200),
                            reverseDuration: const Duration(milliseconds: 200),
                            child: FormDetailsApiScreen(formId: notif.formId),
                          ),
                        );

                        if (result == true) {
                          fetchNotifications();
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/logo.png'),
                                        radius: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          children: [
                                            const TextSpan(
                                              text: 'अधिकारी : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            TextSpan(
                                              text: notif.name,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'फॉर्म आय डी: ${notif.formId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'दिनांक: ${notif.commentAt}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                'Comment: "${notif.comment}"',
                                style: const TextStyle(fontSize: 15),
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
