import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/models/form_ans_model.dart';
import 'package:field_visit/screens/form_details_screen/form_details_screen.dart';
import 'package:field_visit/widgets/loading_popup.dart';
import 'package:flutter/material.dart';
import 'package:field_visit/widgets/customer_field_visit_appbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormListScreen extends StatefulWidget {
  final String talukaId;

  const FormListScreen({super.key, required this.talukaId});

  @override
  State<FormListScreen> createState() => _FormListScreenState();
}

class _FormListScreenState extends State<FormListScreen> {
  late Future<List<FormAnsModel>> _formListFuture;

  @override
  void initState() {
    super.initState();
    _formListFuture = Auth.fetchVisitedFormList(widget.talukaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomFieldVisitAppBar(),
      body: FutureBuilder<List<FormAnsModel>>(
        future: _formListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return const LoadingPopup();
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text("त्रुटी आली. कृपया नंतर प्रयत्न करा."));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("कोणतीही माहिती उपलब्ध नाही."));
          }

          final formList = snapshot.data!;

          return ListView.builder(
            itemCount: formList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final form = formList[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'फॉर्म आयडी : ${form.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'दिनांक : ${form.createdAt.split(" ").take(3).join(" ")}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Office Type
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'कार्यालय प्रकार : ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: form.officeType,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Village
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'गाव  :  ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: form.village,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  reverseDuration:
                                      const Duration(milliseconds: 200),
                                  child: FormDetailsScreen(
                                    formData: form,
                                  )));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'पहा',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
