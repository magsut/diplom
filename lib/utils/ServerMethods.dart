import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ServerMethods {

  static Future<String> addUser(String password, String login, File image) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addUser');
    var request = http.MultipartRequest("POST", uri);
    request.fields['pass'] = password;
    request.fields['login'] = login;
    request.files.add(await http.MultipartFile.fromPath('photo', image.path));

    final response = await request.send();

    if(response.statusCode == 400){
      return "No data";
    } else if (response.statusCode != 200){
      return "Server error";
    }

    final respStr = await response.stream.bytesToString();

    print(respStr);

    return respStr;
  }

  static Future<String> addUserWithDefIm(String password, String login) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addUser');
    var request = http.MultipartRequest("POST", uri);
    request.fields['pass'] = password;
    request.fields['login'] = login;

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    print(respStr);

    return respStr;
  }

  static Future<String> addUserCar(
      String name, int cost, int millage, String token, File image, int operating_mode) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addUserCar');
    var request = http.MultipartRequest("POST", uri);
    request.fields['name'] = name;
    request.fields['cost'] = cost.toString();
    request.fields['millage'] = millage.toString();
    request.fields['token'] = token;
    request.fields['operating_mode'] = operating_mode.toString();
    request.files.add(await http.MultipartFile.fromPath('photo', image.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    print(respStr);

    return respStr;
  }

  static Future<String> addUserCarWithDefIm(
      String name, int cost, int millage, String token, int operating_mode) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addUserCar');
    var request = http.MultipartRequest("POST", uri);
    request.fields['name'] = name;
    request.fields['cost'] = cost.toString();
    request.fields['millage'] = millage.toString();
    request.fields['token'] = token;
    request.fields['operating_mode'] = operating_mode.toString();

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if(response.statusCode == 200){
      return respStr;
    } else {
      return "Error";
    }
  }

  static Future<String> updateUserCar(
      String name, int cost, int millage, int operating_mode, int id) async {
    final uri = Uri.parse('http://192.168.0.121:3000/updateUserCar');
    var request = http.MultipartRequest("POST", uri);
    request.fields['name'] = name;
    request.fields['cost'] = cost.toString();
    request.fields['millage'] = millage.toString();
    request.fields['operating_mode'] = operating_mode.toString();
    request.fields['id'] = id.toString();

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if(response.statusCode == 200){
      return respStr;
    } else {
      return "Error";
    }
  }

  static Future<String> addSpending(int carId, String name, String desc,
      bool isPlanned, String date, int millage, String type, int cost) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addSpending');

    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idCar': carId.toString(),
          'name': name,
          'description': desc,
          'isPlaned': isPlanned ? '1' : '0',
          'date': date,
          'millage': millage.toString(),
          'type': type,
          'cost': cost.toString()
        }),
        encoding: Encoding.getByName("utf-8"));
    return response.body;
  }

  static Future<String> addCar_IdToUserCar(int carId, String mark, String model, String generation) async {
    final uri = Uri.parse('http://192.168.0.121:3000/addCar_IdToUserCar');

    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idCar' : carId.toString(),
          'mark' : mark,
          'model' : model,
          'generation': generation
        }),
        encoding: Encoding.getByName("utf-8"));
    return response.body;
  }

  static Future<String> getMarks() async {
    final uri = Uri.parse('http://192.168.0.121:3000/getCarMarks');

    final http.Response response = await http.get(uri);

    return response.body;
  }

  static Future<String> getModelsFromMark(String mark) async {
    final uri = Uri.parse('http://192.168.0.121:3000/getModelsFromMark/$mark');

    final http.Response response = await http.get(uri);

    return response.body;
  }

  static Future<String> getGenerationsFromModel(String model) async {
    final uri = Uri.parse('http://192.168.0.121:3000/getGenerationsFromModel/$model');

    final http.Response response = await http.get(uri);

    return response.body;
  }

  static Future<String> getServices(String mark, model, generation) async {
    final uri = Uri.parse('http://192.168.0.121:3000/getServices/$mark/$model/$generation');

    final http.Response response = await http.get(uri);

    return response.body;
  }

  static Future<String> login(String pas, login) async {
    final uri = Uri.parse('http://192.168.0.121:3000/login/$pas/$login');

    final http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      return response.body;
    } else if(response.statusCode == 400) {
      return "No user";
    } else {
      return "Server error";
    }
  }

  static Future<String> getOperatingModes() async {
    final uri = Uri.parse('http://192.168.0.121:3000/getOperatingModes');

    final http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      return response.body;
    } else {
      return "Server error";
    }
  }

  static Future<String> getSpendingTypes() async {
    final uri = Uri.parse('http://192.168.0.121:3000/getSpendingTypes');

    final http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      return response.body;
    } else {
      return "Server error";
    }
  }

  static Future<String> getUserCars(String token) async {
    final uri = Uri.parse('http://192.168.0.121:3000/getUsercars/$token');

    final http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      return response.body;
    } else {
      return 'Error';
    }
  }

  static Future<String> getSost(String name) async {
    final uri = Uri.parse('http://192.168.0.121:3000/getSost/$name');

    final http.Response response = await http.get(uri);

    if(response.statusCode == 200){
      return response.body;
    } else {
      return 'Error';
    }
  }

  static Future<Image> getUserPhoto(String photoName) async {
    return Image.network('http://192.168.0.121:3000/getUserPhoto/$photoName');
  }

  static Future<Image> getCarPhoto(String photoName) async {
    return Image.network('http://192.168.0.121:3000/getCarPhoto/$photoName');
  }

  static Future<String> deleteUserCar(int id) async{
    final uri = Uri.parse('http://192.168.0.121:3000/deleteUserCar/$id');

    final http.Response response = await http.delete(uri);

    if(response.statusCode == 200){
      return response.body;
    } else {
      return 'Error';
    }

  }

  static Future<String> addRefueling(int id, quality, millage, date, String type,) async{
    final uri = Uri.parse('http://192.168.0.121:3000/addRefuelingToUserCar');

    final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idCar': id.toString(),
          'quality': quality.toString(),
          'date': date.toString(),
          'millage': millage.toString(),
          'type': type}),
        encoding: Encoding.getByName("utf-8")
    );

    if(response.statusCode == 200){
      return response.body;
    } else {
      return 'Error';
    }

  }

  static Future<String> addOilChange(int id, millage, date) async{
    final uri = Uri.parse('http://192.168.0.121:3000/addOilChangeToUserCar');

    final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idCar': id.toString(),
          'date': date.toString(),
          'millage': millage.toString()}),
        encoding: Encoding.getByName("utf-8")
    );

    if(response.statusCode == 200){
      return response.body;
    } else {
      return 'Error';
    }

  }
}
