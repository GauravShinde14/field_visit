import 'dart:convert';
import 'dart:io';
import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/constants/constant.dart';
import 'package:field_visit/models/form_field_model.dart';
import 'package:field_visit/widgets/customer_field_visit_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FieldFormScreen extends StatefulWidget {
  final String officeTypeId;
  final String talukaId;

  final String villageId;

  const FieldFormScreen(
      {super.key,
      required this.officeTypeId,
      required this.talukaId,
      required this.villageId});

  @override
  State<FieldFormScreen> createState() => _FieldFormScreenState();
}

class _FieldFormScreenState extends State<FieldFormScreen> {
  List<FormFieldModel> formFields = [];
  Map<String, dynamic> formValues = {};

  @override
  void initState() {
    super.initState();
    fetchFormFields();
  }

  Future<void> fetchFormFields() async {
    final url =
        "${Constant.questionList}?office_type_id=${widget.officeTypeId}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> details = jsonResponse['details'];
        setState(() {
          formFields = details.map((e) => FormFieldModel.fromJson(e)).toList();
        });
      } else {
        print("Failed to load form fields");
      }
    } catch (e) {
      print("Error fetching form fields: $e");
    }
  }

  Widget buildFormField(FormFieldModel field) {
    switch (field.type) {
      case 'radio':
        final options = field.dropdownValue.split(',');
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.required ? "${field.label} *" : field.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...options.map((opt) => RadioListTile<String>(
                      title: Text(opt),
                      value: opt,
                      groupValue: formValues[field.id],
                      onChanged: (value) {
                        setState(() {
                          formValues[field.id] = value;
                        });
                      },
                    )),
              ],
            ),
          ),
        );

      case 'textarea':
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: field.required ? "${field.label} *" : field.label,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) => formValues[field.id] = value,
            ),
          ),
        );

      case 'file':
        final File? selectedFile = formValues[field.id] as File?;
        final fileName = selectedFile?.path.split('/').last;

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.required ? "${field.label} *" : field.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                    );

                    if (result != null && result.files.single.path != null) {
                      File file = File(result.files.single.path!);
                      setState(() {
                        formValues[field.id] = file;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Center(
                    child: Text(
                      "फोटो किंवा PDF अपलोड करा",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (fileName != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    "निवडलेली फाईल: $fileName",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  void handleSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userid")!;
    print("*********************userid while submitting form $userId");
    bool hasError = false;

    for (var field in formFields) {
      final value = formValues[field.id];

      if (field.required) {
        if (value == null || (value is String && value.trim().isEmpty)) {
          hasError = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("कृपया '${field.label}' हे फील्ड भरा."),
            backgroundColor: Colors.red,
          ));
          break;
        }
        if (field.type == "file" && value is! File) {
          hasError = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("कृपया '${field.label}' साठी फाइल अपलोड करा."),
            backgroundColor: Colors.red,
          ));
          break;
        }
      }
    }

    if (hasError) return;

    // Build answer map
    Map<String, dynamic> answer = {};
    for (var entry in formValues.entries) {
      if (entry.value is File) {
        File file = entry.value;
        List<int> fileBytes = await file.readAsBytes();
        String base64File = base64Encode(fileBytes);

        answer[entry.key.toString()] = {
          "type": "file",
          "value": base64File,
        };
      } else {
        answer[entry.key.toString()] = {
          "type": "text",
          "value": entry.value.toString(),
        };
      }
    }

    Map<String, dynamic> body = {
      "user_id": userId,
      "office_type_id": int.parse(widget.officeTypeId),
      "taluka_id": int.parse(widget.talukaId),
      "village_id": int.parse(widget.villageId),
      "answer": answer,
    };

    try {
      final response = await http.post(
        Uri.parse(Constant.insertForm),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Form submitted successfully!");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("फॉर्म यशस्वीरीत्या सबमिट झाला."),
          backgroundColor: Colors.green,
        ));
        // Wait a short delay so the user sees the snackbar before pop
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context); // ✅ Close the screen
      } else {
        print("Error: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception during submission: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomFieldVisitAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: formFields.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: formFields.map(buildFormField).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "सबमिट करा",
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
    );
  }
}
