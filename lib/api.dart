// ignore_for_file: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';

var nyckel = '3cede50c-960d-4ada-950a-5b2079c2432b';
//https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=3cede50c-960d-4ada-950a-5b2079c2432b
List<TodoTask> _list = [];

class TodoTask {
  String title;
  bool item;
  String id;

  TodoTask(this.title, this.item, this.id);

  factory TodoTask.fromJson(Map<String, dynamic> json) {
    return TodoTask(
      json['title'] as String,
      json['item'] as bool,
      json['id'] as String,
    );
  }
}

class Api {
//Sparar
  static Future<List<TodoTask>> postList(String title, bool item) async {
    final response = await http.post(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'title': title,
        },
      ),
    );
    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body) as List;
      _list =
          jsonResponse.map((response) => TodoTask.fromJson(response)).toList();
      return _list;
    } else {
      throw Exception('Failed to create list.');
    }
  }

//Get
  static Future<TodoTask> getList() async {
    final response = await http.get(Uri.parse(
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'));
    if (response.statusCode == 200) {
      return TodoTask.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load the list');
    }
  }

//Uppdaterar
  static Future<http.Response> updateList(String title, bool item, String id) {
    return http.put(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );
  }

//Tar bort
  static Future<http.Response> deleteList(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('https://todoapp-api-pyq5q.ondigitalocean.app/todosid?key=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}
