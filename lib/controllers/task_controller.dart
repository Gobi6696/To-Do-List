import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = 'https://todo-baaa5-default-rtdb.firebaseio.com';

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TaskController() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _subscribeToTasks(user.uid);
      } else {
        _tasks = [];
        notifyListeners();
      }
    });
  }

  Future<void> _subscribeToTasks(String uid) async {
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    if (_auth.currentUser == null) return;
    final uid = _auth.currentUser!.uid;

    _setLoading(true);
    try {
      final token = await _auth.currentUser!.getIdToken();
      final url = Uri.parse('$_baseUrl/tasks/$uid.json?auth=$token');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body == 'null') {
          _tasks = [];
        } else {
          final data = json.decode(response.body) as Map<String, dynamic>;
          _tasks = data.entries.map((e) {
            final Map<String, dynamic> item = Map<String, dynamic>.from(
              e.value as Map,
            );
            return TaskModel.fromMap(item, e.key);
          }).toList();

          _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      } else {
        _errorMessage = 'Failed to load tasks';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshTasks() async {
    await fetchTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  Future<bool> addTask(String title, String description, String status) async {
    if (_auth.currentUser == null) return false;
    final uid = _auth.currentUser!.uid;

    try {
      final token = await _auth.currentUser!.getIdToken();
      final url = Uri.parse('$_baseUrl/tasks/$uid.json?auth=$token');

      final newTaskDetails = {
        'title': title,
        'description': description,
        'isCompleted': status == 'Completed',
        'status': status,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final response = await http.post(url, body: json.encode(newTaskDetails));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newId = responseData['name'];
        final task = TaskModel(
          id: newId,
          title: newTaskDetails['title'] as String,
          description: newTaskDetails['description'] as String,
          isCompleted: newTaskDetails['isCompleted'] as bool,
          status: newTaskDetails['status'] as String,
          createdAt: DateTime.parse(newTaskDetails['createdAt'] as String),
        );
        _tasks.insert(0, task);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    if (_auth.currentUser == null) return false;
    final uid = _auth.currentUser!.uid;

    try {
      final token = await _auth.currentUser!.getIdToken();
      final url = Uri.parse('$_baseUrl/tasks/$uid/${task.id}.json?auth=$token');

      final response = await http.patch(url, body: json.encode(task.toMap()));

      if (response.statusCode == 200) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTaskCompletion(TaskModel task) async {
    if (_auth.currentUser == null) return false;
    final uid = _auth.currentUser!.uid;

    try {
      final token = await _auth.currentUser!.getIdToken();
      final url = Uri.parse('$_baseUrl/tasks/$uid/${task.id}.json?auth=$token');

      final newIsCompleted = !task.isCompleted;
      final newStatus = newIsCompleted ? 'Completed' : 'Pending';

      final response = await http.patch(
        url,
        body: json.encode({'isCompleted': newIsCompleted, 'status': newStatus}),
      );

      if (response.statusCode == 200) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task.copyWith(
            isCompleted: newIsCompleted,
            status: newStatus,
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    if (_auth.currentUser == null) return false;
    final uid = _auth.currentUser!.uid;

    try {
      final token = await _auth.currentUser!.getIdToken();
      final url = Uri.parse('$_baseUrl/tasks/$uid/$id.json?auth=$token');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _tasks.removeWhere((t) => t.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
