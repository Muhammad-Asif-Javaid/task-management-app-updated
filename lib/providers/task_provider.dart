import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {

  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  TaskProvider(){
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('tasks');

    if(data != null){
      _tasks = List<Map<String, dynamic>>.from(json.decode(data));
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(_tasks));
  }

  void addTask(String title){
    _tasks.add({
      "title": title,
      "done": false
    });
    saveTasks();
    notifyListeners();
  }

  void toggleTask(int index){
    _tasks[index]['done'] = !_tasks[index]['done'];
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index){
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }
}