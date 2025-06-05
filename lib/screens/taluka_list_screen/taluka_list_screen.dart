import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/models/taluka_model.dart';
import 'package:field_visit/screens/form_list_screen/form_list_screen.dart';
import 'package:field_visit/widgets/loading_popup.dart';
import 'package:flutter/material.dart';
import 'package:field_visit/widgets/customer_field_visit_appbar.dart';
import 'package:page_transition/page_transition.dart';

class TalukaListScreen extends StatefulWidget {
  const TalukaListScreen({super.key});

  @override
  State<TalukaListScreen> createState() => _TalukaListScreenState();
}

class _TalukaListScreenState extends State<TalukaListScreen> {
  bool isLoading = true;
  String? selectedTalukaId;
  List<TalukaModel> talukaList = [];

  @override
  void initState() {
    super.initState();
    loadTalukaList();
  }

  Future<void> loadTalukaList() async {
    try {
      final taluka = await Auth.fetchTaluka();
      setState(() {
        talukaList = taluka;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading taluka types: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomFieldVisitAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const LoadingPopup()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'भेट दिलेले तालुके',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: talukaList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 200),
                                    reverseDuration:
                                        const Duration(milliseconds: 200),
                                    child: FormListScreen(
                                      talukaId: talukaList[index].id,
                                    )));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  talukaList[index].taluka,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
