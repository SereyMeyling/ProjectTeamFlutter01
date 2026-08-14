import 'package:dio/dio.dart';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/remote/dio_client.dart';
import 'package:demo_sccess_refresh_token_app/core/services/task_api_service.dart';
import 'package:demo_sccess_refresh_token_app/models/task/task.dart';

class TaskApiServiceImpl extends TaskApiService {
  TaskApiServiceImpl({Dio? dio}) : _dio = dio ?? DioClient().dio;
  final Dio _dio;

  @override
  Future<List<Task>> getTasks() async {
    final response = await _dio.get(ConstantUri.taskBase);
    final List data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data['data'] ?? []);
    return data.map((e) => Task.fromJson(e)).toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    final response = await _dio.post(ConstantUri.taskBase, data: task.toJson());
    return Task.fromJson(response.data);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final response = await _dio.put(
      ConstantUri.taskById(task.id!),
      data: task.toJson(),
    );
    return Task.fromJson(response.data);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _dio.delete(ConstantUri.taskById(id));
  }

  @override
  Future<Task> toggleComplete(int id, bool isCompleted) async {
    final response = await _dio.patch(
      ConstantUri.taskComplete(id),
      data: {"isCompleted": isCompleted},
    );
    return Task.fromJson(response.data);
  }
}