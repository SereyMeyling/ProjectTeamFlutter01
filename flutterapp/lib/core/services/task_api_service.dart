import 'package:demo_sccess_refresh_token_app/models/task/task.dart';

abstract class TaskApiService {
  Future<List<Task>> getTasks();
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(int id);
  Future<Task> toggleComplete(int id, bool isCompleted);
}