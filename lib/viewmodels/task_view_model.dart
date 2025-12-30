import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Uuid _uuid = const Uuid();

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Simulate an API call or database operation
  Future<void> fetchTasks() async {
    _setLoading(true);
    _setError(null);
    try {
      // Simulate delay
      await Future.delayed(const Duration(milliseconds: 800));
      // In a real app, you would fetch from a repository here
      _setLoading(false);
    } catch (e) {
      _setError("Failed to fetch tasks: ${e.toString()}");
      _setLoading(false);
    }
  }

  Future<void> addTask(String title, String description) async {
    if (title.isEmpty) {
      _setError("Title cannot be empty");
      return;
    }

    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newTask = Task(
        id: _uuid.v4(),
        title: title,
        description: description,
      );
      _tasks.add(newTask);
      _setLoading(false);
      _setError(null);
    } catch (e) {
      _setError("Failed to add task");
      _setLoading(false);
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      _setLoading(false);
      _setError(null);
    } catch (e) {
      _setError("Failed to update task");
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String id) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _tasks.removeWhere((t) => t.id == id);
      _setLoading(false);
      _setError(null);
    } catch (e) {
      _setError("Failed to delete task");
      _setLoading(false);
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index].isCompleted = !_tasks[index].isCompleted;
        notifyListeners();
      }
    } catch (e) {
      _setError("Failed to toggle status");
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
