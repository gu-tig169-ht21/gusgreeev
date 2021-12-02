// ignore_for_file: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

const nyckel = '27e84a37-c7c9-4c65-bd3a-ceea1c5e99db';
const url = 'https://todoapp-api-pyq5q.ondigitalocean.app';

class Api {
  static Future<List<TodoTask>> postList(String title) async {
    Map<String, dynamic> json = {'title': title};
    var bodyString = jsonEncode(json);
    var response = await http.post(
      Uri.parse('$url/todos?key=$nyckel'),
      body: bodyString,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    bodyString = response.body;
    var list = jsonDecode(bodyString);
    return list.map<TodoTask>((data) {
      return TodoTask.fromJson(data);
    }).toList();
  }

  static Future<List<TodoTask>> getList() async {
    http.Response response =
        await http.get(Uri.parse('$url/todos?key=$nyckel'));
    var list = jsonDecode(response.body);

    return list.map<TodoTask>((data) {
      return TodoTask.fromJson(data);
    }).toList();
  }

  static Future<List<TodoTask>?> updateList(TodoTask checkbox) async {
    Map<String, dynamic> json = {
      'title': checkbox.title,
      'done': checkbox.item,
    };
    var bodyString = jsonEncode(json);
    http.Response response = await http.put(
      Uri.parse('$url/todos/${checkbox.id}?key=$nyckel'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: bodyString,
    );
    bodyString = response.body;
    var list = jsonDecode(bodyString);
    return list.map<TodoTask>((data) {
      return TodoTask.fromJson(data);
    }).toList();
  }

  static Future deleteList(TodoTask checkbox) async {
    http.Response response = await http.delete(
      Uri.parse('$url/todos/${checkbox.id}?key=$nyckel'),
    );
    var bodyString = response.body;
    var list = jsonDecode(bodyString);

    return list.map<TodoTask>((data) {
      return TodoTask.fromJson(data);
    }).toList();
  }
}
