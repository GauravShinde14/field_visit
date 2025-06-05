import 'dart:convert';
import 'dart:io';

import 'package:field_visit/auth/notification_service.dart';
import 'package:field_visit/constants/constant.dart';
import 'package:field_visit/models/comment_model.dart';
import 'package:field_visit/models/comment_notification.dart';
import 'package:field_visit/models/form_ans_model.dart';
import 'package:field_visit/models/office_type.dart';
import 'package:field_visit/models/taluka_model.dart';
import 'package:field_visit/models/user_model.dart';
import 'package:field_visit/models/village_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<String> login(String mobileno, String password) async {
    final fcmToken = await NotificationService.instance.getFcmToken();
    print("**********************fcm token while logging $fcmToken");
    try {
      final response = await http.post(
        Uri.parse(Constant.login),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'username': mobileno,
          "password": password,
          "token": fcmToken
        }),
      );
      if (kDebugMode) {
        print("Constant.login ${Constant.login}");
        print("Login response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          final userMap = jsonresponse["details"];
          UserModel user = UserModel.fromJson(userMap);
          if (kDebugMode) {
            print("user logged in ${user.toString()}");
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userid", user.id);

          prefs.setString("name", user.name);
          prefs.setString("email", user.email);
          prefs.setString("phoneNo", user.mobile);
          prefs.setString("userType", user.userType);
          prefs.setString("userDesignation", user.designation);

          return jsonresponse['message'];
        } else if (jsonresponse['status'] == "failed") {
          return jsonresponse['message'];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return "Server Error";
    }
    return "Server Error 2";
  }

  static Future<List<OfficeType>> fetchOfficeTypes() async {
    try {
      final response = await http.get(
        Uri.parse(Constant.officeType),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.officeType ${Constant.officeType}");
        print("officeType response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList:${responseList.toString()}");

          List<OfficeType> officeTypeList = responseList.map((data) {
            return OfficeType.fromJson(data);
          }).toList();
          return officeTypeList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("OfficeTypeList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<TalukaModel>> fetchTaluka() async {
    try {
      final response = await http.get(
        Uri.parse(Constant.talukaList),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.talukaList ${Constant.talukaList}");
        print("talukaList response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          if (kDebugMode) {
            print(
                "-------------------------responseList:${responseList.toString()}");
          }

          List<TalukaModel> talukaModelList = responseList.map((data) {
            return TalukaModel.fromJson(data);
          }).toList();
          return talukaModelList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("talukaList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<VillageModel>> fetchVillage(
      String talukaid, String officeTypeId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Constant.baseurl}office_list?taluka_id=$talukaid&office_type_id=$officeTypeId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print(
            "Constant.talukaList${Constant.baseurl}office_list?taluka_id=$talukaid&office_type_id=$officeTypeId");
        print("villagelist response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          if (kDebugMode) {
            print(
                "-------------------------responseList:${responseList.toString()}");
          }

          List<VillageModel> villageModelList = responseList.map((data) {
            return VillageModel.fromJson(data);
          }).toList();
          return villageModelList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("villageModelList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<FormAnsModel>> fetchVisitedFormList(
      String talukaId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userid")!;
      final response = await http.get(
        Uri.parse("${Constant.visitList}?user_id=$userId&taluka_id=$talukaId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.visitList ${Constant.visitList}");
        print("visitList response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList visitedFormList:${responseList.toString()}");

          List<FormAnsModel> visitedFormList = responseList.map((data) {
            return FormAnsModel.fromJson(data);
          }).toList();
          return visitedFormList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("visitedFormList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<CommentModel>> fetchCommentList(String formId) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userId = prefs.getString("userid")!;
      final response = await http.get(
        Uri.parse("${Constant.commentList}$formId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.commentList ${Constant.commentList}$formId");
        print("commentList response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList commentList:${responseList.toString()}");

          List<CommentModel> commentList = responseList.map((data) {
            return CommentModel.fromJson(data);
          }).toList();
          return commentList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("commentList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<bool> addremark(
    String commentId,
    String remark,
    String remarktime,
    File? imageFile, // <-- Add image file param
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userid")!;

      var uri = Uri.parse(Constant.addremark);
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['comment_id'] = commentId;
      request.fields['remark'] = remark;
      request.fields['remark_at'] = remarktime;
      request.fields['remark_by'] = userId;

      // Add image if exists
      if (imageFile != null) {
        // final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        // final mimeSplit = mimeType.split('/');
        print("api service --------------------$imageFile");
        request.files.add(
          await http.MultipartFile.fromPath(
            'remark_image', // <-- field name in backend
            imageFile.path,
          ),
        );
      }
      print("api service --------------------$imageFile");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("Constant.addremark ${Constant.addremark}");
        print("addremark response: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success" &&
            jsonresponse['message'] == "Remark Added Successfully.") {
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("addremark Error $e");
      }
      return false;
    }
    return false;
  }

  static Future<Map<String, dynamic>> fetchDashboardVisitCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userid")!;
      final response = await http.get(
        Uri.parse("${Constant.dashboardVisitCount}?user_id=$userId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.dashboardVisitCount ${Constant.dashboardVisitCount}");
        print("dashboardVisitCount response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          Map<String, dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList commentList:${responseList.toString()}");

          return responseList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("commentList Error $e");
      }
      return {"error": "error in commentList"};
    }
    return {"error": "error in commentList"};
  }

  static Future<List<CommentNotification>>
      fetchCommentNotificationList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userid")!;
      print("notification user Id- $userId");
      final response = await http.get(
        Uri.parse("${Constant.commentNotificationList}?user_id=$userId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print(
            "Constant.commentNotificationList ${Constant.commentNotificationList}");
        print("commentNotificationList response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList commentNotificationList:${responseList.toString()}");

          List<CommentNotification> commentNotificationList =
              responseList.map((data) {
            return CommentNotification.fromJson(data);
          }).toList();
          return commentNotificationList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("commentNotificationList Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<FormAnsModel?> fetchFormDetails(String formId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userid")!;
      final response = await http.get(
        Uri.parse("${Constant.formDetails}?user_id=$userId&form_id=$formId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.formDetails ${Constant.visitList}");
        print("formDetails response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          final formDetailsJson = jsonresponse["details"];
          FormAnsModel formDetails = FormAnsModel.fromJson(formDetailsJson);
          print(
              "-------------------------responseList formDetails:${response.toString()}");
          return formDetails;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("formDetails Error $e");
      }
      return null;
    }
    return null;
  }

  static Future<bool> markCommentAsRead(String commentId) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userId = prefs.getString("userid")!;
      final response = await http.get(
        Uri.parse("${Constant.markAsReadNotification}?comment_id=$commentId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print(
            "Constant.markAsReadNotification ${Constant.markAsReadNotification}");
        print("markAsReadNotification response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          // final formDetailsJson = jsonresponse["details"];
          // FormAnsModel formDetails = FormAnsModel.fromJson(formDetailsJson);
          // print(
          // "-------------------------responseList formDetails:${response.toString()}");
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("formDetails Error $e");
      }
      return false;
    }
    return false;
  }
}
