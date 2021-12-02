import 'package:flutter/material.dart';
import 'api.dart';

class TodoTask {
  String title;
  bool item;
  String id;

  TodoTask({required this.title, this.item = true, this.id = ''});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': item,
      'id': id,
    };
  }

  factory TodoTask.fromJson(Map<String, dynamic> json) {
    return TodoTask(
      title: json['title'],
      item: json["done"],
      id: json["id"],
    );
  }
}

List<TodoTask> _getFilteredList(allItems, filterSetting) {
  if (filterSetting == 'all') return allItems;
  if (filterSetting == 'some') {
    return allItems.where((item) => item.item == true).toList();
  }
  if (filterSetting == 'no') {
    return allItems.where((item) => item.item == false).toList();
  }
  return allItems;
}

class TodolistProvider extends ChangeNotifier {
  TodolistProvider() {
    getList();
  }

  List<TodoTask> _list = [];
  String _filterSetting = 'all';

  String get filterSetting => _filterSetting;

  List<TodoTask> get list => _list;

  Future getList() async {
    List<TodoTask> list = await Api.getList();
    _list = list;
    notifyListeners();
  }

  void setFilterBy(String filterSetting) {
    _filterSetting = filterSetting;
    notifyListeners();
  }

  void removeToDo(TodoTask checkbox) async {
    _list = await Api.deleteList(checkbox);
    notifyListeners();
  }

  void addTodo(checkbox) async {
    _list = await Api.postList(checkbox);
    notifyListeners();
  }

  void upDateTodo(TodoTask checkbox) async {
    checkbox.item = !checkbox.item;
    List<TodoTask>? _list = await Api.updateList(checkbox);
    notifyListeners();
  }
}
