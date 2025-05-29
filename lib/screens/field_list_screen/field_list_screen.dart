import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/models/office_type.dart';
import 'package:field_visit/models/taluka_model.dart';
import 'package:field_visit/models/village_model.dart';
import 'package:field_visit/screens/field_form_screen/field_form_screen.dart';
import 'package:flutter/material.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({super.key});

  @override
  State<FieldListScreen> createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  String? selectedOfficeId;
  List<OfficeType> officeList = [];
  bool isLoading = true;

  String? selectedTalukaId;
  List<TalukaModel> talukaList = [];

  String? selectedVillageId;
  List<VillageModel> villageList = [];

  @override
  void initState() {
    super.initState();
    loadOfficeTypes();
    loadTalukaList();
  }

  Future<void> loadOfficeTypes() async {
    try {
      final offices = await Auth.fetchOfficeTypes();
      setState(() {
        officeList = offices;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading office types: $e");
      setState(() {
        isLoading = false;
      });
    }
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

  Future<void> loadVillageList() async {
    if (selectedTalukaId != null && selectedOfficeId != null) {
      try {
        final villages =
            await Auth.fetchVillage(selectedTalukaId!, selectedOfficeId!);
        setState(() {
          villageList = villages;
          selectedVillageId = null;
        });
      } catch (e) {
        print("Error loading villages: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("कृपया तालुका आणि ऑफिस निवडा")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: ColorConstants.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Field Visit App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                /// Office Dropdown
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey.shade100,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.brown),
                        value: selectedOfficeId,
                        hint: const Text(
                          'क्षेत्रीय भेट दिले त्या ठिकाणाचे ऑफिस निवडा',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        items: officeList.map((office) {
                          return DropdownMenuItem<String>(
                            value: office.id,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                office.officeType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedOfficeId = value;
                            selectedVillageId = null;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Taluka Dropdown
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey.shade100,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.brown),
                        value: selectedTalukaId,
                        hint: const Text(
                          'तालुका निवडा',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        items: talukaList.map((taluka) {
                          return DropdownMenuItem(
                            value: taluka.id,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                taluka.taluka,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTalukaId = value;
                            selectedVillageId = null;
                          });
                          loadVillageList();
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Village Dropdown
                GestureDetector(
                  onTap: () {
                    if (selectedTalukaId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("कृपया आधी तालुका निवडा")),
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: selectedTalukaId == null,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.grey.shade100,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.brown),
                            value: selectedVillageId,
                            hint: const Text(
                              'ग्रामपंचायत निवडा',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            items: villageList.map((village) {
                              return DropdownMenuItem(
                                value: village.villageId,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    village.villageName,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVillageId = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                /// Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (selectedOfficeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("कृपया ऑफिस निवडा")),
                      );
                    } else if (selectedTalukaId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("कृपया तालुका निवडा")),
                      );
                    } else if (selectedVillageId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("कृपया ग्रामपंचायत निवडा")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FieldFormScreen(
                            officeTypeId: selectedOfficeId!,
                            talukaId: selectedTalukaId!,
                            villageId: selectedVillageId!,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "पुढे जा",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
