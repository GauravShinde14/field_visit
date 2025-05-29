import 'dart:convert';

import 'package:field_visit/constants/constant.dart';
import 'package:field_visit/models/office_type.dart';
import 'package:field_visit/models/taluka_model.dart';
import 'package:field_visit/models/user_model.dart';
import 'package:field_visit/models/village_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<String> login(String mobileno, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.login),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'username': mobileno,
          "password": password,
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
}
