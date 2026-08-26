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

    print('TASK STATUS: ${response.statusCode}');
    print('TASK RESPONSE: ${response.data}');

    final responseData = response.data;

    if (responseData is List) {
      return responseData
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];

      if (data is Map<String, dynamic>) {
        final content = data['content'];

        if (content is List) {
          return content
              .map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      final content = responseData['content'];

      if (content is List) {
        return content
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return [];
  }

  @override
  Future<Task> createTask(Task task) async {
    final response = await _dio.post(ConstantUri.taskBase, data: task.toJson());
    final data = response.data['data'];
    return Task.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final response = await _dio.put(
      ConstantUri.taskById(task.id!),
      data: task.toJson(),
    );
    final data = response.data['data'];
    return Task.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _dio.delete(ConstantUri.taskById(id));
  }

  @override
  Future<Task> toggleComplete(int id, bool isCompleted) async {
    final response = await _dio.patch(
      ConstantUri.taskComplete(id),
      data: {"completed": isCompleted},
    );
    final data = response.data['data'];
    return Task.fromJson(data as Map<String, dynamic>);
  }
}
